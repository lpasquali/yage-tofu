terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.6"
}

# Intermediate CA private key (ECDSA P-256, matching the inline Go generator
# in yage's internal/platform/opentofux/issuing_ca.go).
resource "tls_private_key" "intermediate" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

# CSR for the intermediate, naming it after the workload cluster.
resource "tls_cert_request" "intermediate" {
  private_key_pem = tls_private_key.intermediate.private_key_pem

  subject {
    common_name = "yage-issuing-ca-${var.cluster_name}"
  }
}

# Intermediate CA cert signed by the operator-supplied root.
# is_ca_certificate = true, with cert_signing usage so cert-manager can use
# the issued material as a ClusterIssuer of kind CA.
resource "tls_locally_signed_cert" "intermediate" {
  cert_request_pem   = tls_cert_request.intermediate.cert_request_pem
  ca_private_key_pem = var.root_ca_key
  ca_cert_pem        = var.root_ca_cert

  validity_period_hours = var.validity_hours
  early_renewal_hours   = var.early_renewal_hours
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
}
