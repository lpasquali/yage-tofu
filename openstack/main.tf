terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 2.1"
    }
  }
  required_version = ">= 1.6"
}

provider "openstack" {
  cloud = var.cloud
}

resource "openstack_identity_application_credential_v3" "capi" {
  name        = "yage-capi-${var.cluster_name}"
  description = "yage CAPI bootstrap credential for cluster ${var.cluster_name}"
  roles       = ["member"]
}
