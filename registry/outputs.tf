# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 Luca Pasquali
#
# Outputs consumed by yage's EnsureRegistry phase to populate
# cfg.ImageRegistryMirror and the cert-manager bootstrap chain.

output "registry_ip" {
  description = "IPv4 address of the provisioned registry VM (first detected by qemu-guest-agent)."
  value = try(
    [for ip in proxmox_virtual_environment_vm.registry.ipv4_addresses : ip[0] if length(ip) > 0][0],
    "",
  )
}

output "registry_host" {
  description = "DNS hostname configured on the registry VM (TLS SAN)."
  value       = var.registry_hostname
}

output "registry_url" {
  description = "Full https URL written to cfg.ImageRegistryMirror by EnsureRegistry."
  value       = "https://${var.registry_hostname}"
}

output "registry_flavor" {
  description = "Registry implementation deployed (harbor or zot)."
  value       = var.registry_flavor
}

output "registry_tls_cert_pem" {
  description = "TLS certificate served by the registry (passthrough of input for downstream wiring)."
  value       = var.registry_tls_cert_pem
  sensitive   = true
}

output "registry_ca_bundle_pem" {
  description = "CA bundle the registry trusts (passthrough; used by EnsureRegistry to verify pulls)."
  value       = var.registry_ca_bundle_pem
}

output "vm_id" {
  description = "Proxmox VM ID of the registry VM (for operator diagnostics and tofu destroy)."
  value       = proxmox_virtual_environment_vm.registry.vm_id
}
