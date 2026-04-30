terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.30"
    }
  }
  required_version = ">= 1.6"
}

provider "google" {
  project = var.project_id
}

resource "google_service_account" "capi" {
  account_id   = "yage-capi-${substr(var.cluster_name, 0, 20)}"
  display_name = "yage CAPI — ${var.cluster_name}"
  project      = var.project_id
}

resource "google_project_iam_member" "capi_compute" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.capi.email}"
}

resource "google_project_iam_member" "capi_iam" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.capi.email}"
}

resource "google_service_account_key" "capi" {
  service_account_id = google_service_account.capi.name
}
