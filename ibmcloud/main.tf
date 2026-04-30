terraform {
  required_providers {
    ibm = {
      source  = "ibm-cloud/ibm"
      version = "~> 1.66"
    }
  }
  required_version = ">= 1.6"
}

provider "ibm" {
  region = var.region
}

resource "ibm_iam_service_id" "capi" {
  name        = "yage-capi-${var.cluster_name}"
  description = "yage CAPI bootstrap service ID for cluster ${var.cluster_name}"
}

resource "ibm_iam_service_api_key" "capi" {
  name           = "yage-capi-${var.cluster_name}"
  iam_service_id = ibm_iam_service_id.capi.iam_id
}

resource "ibm_iam_access_group" "capi" {
  name = "yage-capi-${var.cluster_name}"
}

resource "ibm_iam_access_group_members" "capi" {
  access_group_id = ibm_iam_access_group.capi.id
  ibm_ids         = []
  iam_service_ids = [ibm_iam_service_id.capi.iam_id]
}
