output "service_account_key_json" {
  description = "Base64-encoded JSON key for the CAPI service account."
  value       = google_service_account_key.capi.private_key
  sensitive   = true
}

output "service_account_email" {
  description = "Email address of the CAPI service account."
  value       = google_service_account.capi.email
}
