variable "project_id" {
  description = "GCP project ID for the CAPI workload cluster."
  type        = string
}

variable "cluster_name" {
  description = "Name of the yage workload cluster (used to name GCP resources)."
  type        = string
}
