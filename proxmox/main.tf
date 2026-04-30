terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.60"
    }
  }
  required_version = ">= 1.6"
}

provider "proxmox" {
  endpoint = var.proxmox_url
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = var.proxmox_insecure
}

resource "proxmox_virtual_environment_role" "capi" {
  role_id   = "CAPI.${var.cluster_name}"
  privileges = [
    "VM.Allocate", "VM.Clone", "VM.Config.CDROM", "VM.Config.CPU",
    "VM.Config.Cloudinit", "VM.Config.Disk", "VM.Config.HWType",
    "VM.Config.Memory", "VM.Config.Network", "VM.Config.Options",
    "VM.Monitor", "VM.Audit", "VM.PowerMgmt", "Datastore.AllocateSpace",
    "Datastore.Audit", "SDN.Use",
  ]
}

resource "proxmox_virtual_environment_user" "capi" {
  user_id = "yage-capi-${var.cluster_name}@pve"
  comment = "yage CAPI bootstrap user for cluster ${var.cluster_name}"
}

resource "proxmox_virtual_environment_acl" "capi" {
  user_id = proxmox_virtual_environment_user.capi.user_id
  role_id = proxmox_virtual_environment_role.capi.role_id
  path    = "/"
  propagate = true
}

resource "proxmox_virtual_environment_user_token" "capi" {
  user_id    = proxmox_virtual_environment_user.capi.user_id
  token_name = "capi"
  comment    = "yage CAPI token"
  privileges_separation = false
}
