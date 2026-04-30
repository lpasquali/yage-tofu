output "token_id" {
  description = "Proxmox API token ID (user@realm!tokenname)."
  value       = proxmox_virtual_environment_user_token.capi.id
  sensitive   = true
}

output "token_secret" {
  description = "Proxmox API token secret UUID."
  value       = proxmox_virtual_environment_user_token.capi.value
  sensitive   = true
}
