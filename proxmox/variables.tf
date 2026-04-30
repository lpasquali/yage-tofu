variable "proxmox_url" {
  description = "Proxmox VE API endpoint URL (e.g. https://pve.example.com:8006)."
  type        = string
}

variable "proxmox_username" {
  description = "Proxmox admin username (e.g. root@pam)."
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox admin password."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Skip TLS verification (set true for self-signed certs)."
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "Name of the yage workload cluster."
  type        = string
}
