terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 2.23"
    }
  }
  required_version = ">= 1.6"
}

provider "linode" {}

resource "linode_token" "capi" {
  label  = "yage-capi-${var.cluster_name}"
  scopes = "linodes:read_write,nodebalancers:read_write,images:read_write,volumes:read_write,vpcs:read_write"
}
