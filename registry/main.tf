# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 Luca Pasquali
#
# yage-tofu/registry/ — provisions a Proxmox VM running an OCI registry
# (Harbor by default, Zot opt-in) per ADR 0009. yage's EnsureRegistry phase
# reads the outputs and wires ImageRegistryMirror before kind cluster start.

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

locals {
  vm_name = "yage-registry-${var.cluster_name}"

  # cloud-init payload installs the chosen registry flavor on first boot.
  # Image seeding (CAPI/CNI/Helm) remains an operator step in Phase H per
  # ADR 0009 §1; this script only stands up the registry daemon.
  cloud_init_user_data = templatefile("${path.module}/cloud-init/registry.yaml.tftpl", {
    registry_flavor         = var.registry_flavor
    registry_hostname       = var.registry_hostname
    registry_admin_password = var.registry_admin_password
    registry_tls_cert_pem   = var.registry_tls_cert_pem
    registry_tls_key_pem    = var.registry_tls_key_pem
    registry_ca_bundle_pem  = var.registry_ca_bundle_pem
  })
}

resource "proxmox_virtual_environment_file" "cloud_init" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.registry_node

  source_raw {
    file_name = "${local.vm_name}-user-data.yaml"
    data      = local.cloud_init_user_data
  }
}

resource "proxmox_virtual_environment_vm" "registry" {
  name      = local.vm_name
  node_name = var.registry_node
  tags      = ["yage", "registry", var.cluster_name]

  clone {
    vm_id = var.registry_template_id
    full  = true
  }

  cpu {
    cores = var.registry_vm_cores
    type  = "host"
  }

  memory {
    dedicated = var.registry_vm_memory_mb
  }

  disk {
    datastore_id = var.registry_storage
    interface    = "scsi0"
    size         = var.registry_vm_disk_gb
    file_format  = "raw"
  }

  network_device {
    bridge = var.registry_network
    model  = "virtio"
  }

  initialization {
    datastore_id = var.registry_storage

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_init.id
  }

  agent {
    enabled = true
  }
}
