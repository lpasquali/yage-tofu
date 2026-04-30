output "application_credential_id" {
  description = "OpenStack application credential ID."
  value       = openstack_identity_application_credential_v3.capi.id
  sensitive   = true
}

output "application_credential_secret" {
  description = "OpenStack application credential secret."
  value       = openstack_identity_application_credential_v3.capi.secret
  sensitive   = true
}
