output "token" {
  description = "Scoped Linode Personal Access Token for CAPI."
  value       = linode_token.capi.token
  sensitive   = true
}
