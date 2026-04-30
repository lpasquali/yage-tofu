terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.6"
}

resource "tls_private_key" "capi" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "oci_identity_user" "capi" {
  compartment_id = var.tenancy_ocid
  name           = "yage-capi-${var.cluster_name}"
  description    = "yage CAPI bootstrap user for cluster ${var.cluster_name}"
}

resource "oci_identity_api_key" "capi" {
  user_id   = oci_identity_user.capi.id
  key_value = tls_private_key.capi.public_key_pem
}

resource "oci_identity_group" "capi" {
  compartment_id = var.tenancy_ocid
  name           = "yage-capi-${var.cluster_name}"
  description    = "yage CAPI group for cluster ${var.cluster_name}"
}

resource "oci_identity_user_group_membership" "capi" {
  group_id = oci_identity_group.capi.id
  user_id  = oci_identity_user.capi.id
}
