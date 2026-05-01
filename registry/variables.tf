# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 Luca Pasquali

# --- Proxmox API credentials ---------------------------------------------------

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

# --- Registry placement (ADR 0009 §1) -----------------------------------------

variable "cluster_name" {
  description = "Name of the yage workload cluster (used to scope the VM name and tags)."
  type        = string
}

variable "registry_node" {
  description = "Proxmox node name where the registry VM is provisioned (YAGE_REGISTRY_NODE)."
  type        = string
}

variable "registry_network" {
  description = "Proxmox bridge name attached to the registry VM (YAGE_REGISTRY_NETWORK)."
  type        = string
  default     = "vmbr0"
}

variable "registry_storage" {
  description = "Proxmox storage pool used for the registry VM disk (YAGE_REGISTRY_STORAGE)."
  type        = string
  default     = "local-lvm"
}

variable "registry_template_id" {
  description = "Proxmox VM template ID to clone for the registry VM (cloud-init enabled Ubuntu/Debian recommended)."
  type        = number
}

# --- Registry VM spec (task: cores / mem / disk) ------------------------------
#
# ADR 0009 names a single `YAGE_REGISTRY_VM_FLAVOR` knob; the task specifies
# explicit cores / memory / disk inputs. We expose all three as discrete
# variables and treat `registry_vm_flavor` as a deferred concern (the
# orchestrator can map a flavor name to these three values before tofu apply).

variable "registry_vm_cores" {
  description = "Registry VM vCPU count."
  type        = number
  default     = 2
}

variable "registry_vm_memory_mb" {
  description = "Registry VM memory in MiB."
  type        = number
  default     = 4096
}

variable "registry_vm_disk_gb" {
  description = "Registry VM root disk size in GiB."
  type        = number
  default     = 100
}

# --- Registry application -----------------------------------------------------

variable "registry_flavor" {
  description = "Registry implementation: 'harbor' (default, replication-capable) or 'zot' (lightweight)."
  type        = string
  default     = "harbor"

  validation {
    condition     = contains(["harbor", "zot"], var.registry_flavor)
    error_message = "registry_flavor must be 'harbor' or 'zot'."
  }
}

variable "registry_hostname" {
  description = "DNS hostname for the registry (used as cloud-init hostname and TLS SAN)."
  type        = string
}

# --- TLS material -------------------------------------------------------------
#
# The orchestrator (EnsureRegistry) supplies the serving certificate as PEM
# strings. yage's existing InternalCABundle / issuing-ca flows generate or
# load the chain off-process and pass the values via -var; the module never
# reads from disk. Defaults are empty strings so plan succeeds without certs
# (the cloud-init bootstrap script tolerates absent certs in dev mode).

variable "registry_tls_cert_pem" {
  description = "PEM-encoded TLS certificate (leaf + chain) served by the registry."
  type        = string
  default     = ""
  sensitive   = true
}

variable "registry_tls_key_pem" {
  description = "PEM-encoded TLS private key for registry_tls_cert_pem."
  type        = string
  default     = ""
  sensitive   = true
}

variable "registry_ca_bundle_pem" {
  description = "PEM-encoded CA bundle the registry trusts for issuing-ca / mTLS verification."
  type        = string
  default     = ""
}

# --- Initial admin credential -------------------------------------------------

variable "registry_admin_password" {
  description = "Initial admin password seeded into the registry (Harbor) on first boot."
  type        = string
  default     = ""
  sensitive   = true
}
