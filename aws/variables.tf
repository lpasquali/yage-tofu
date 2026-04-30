variable "region" {
  description = "AWS region for the CAPI workload cluster."
  type        = string
}

variable "cluster_name" {
  description = "Name of the yage workload cluster (used to name IAM resources)."
  type        = string
}
