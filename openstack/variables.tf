variable "cloud" {
  description = "OpenStack cloud name from clouds.yaml (passed via OS_CLOUD env var or directly)."
  type        = string
}

variable "cluster_name" {
  description = "Name of the yage workload cluster."
  type        = string
}
