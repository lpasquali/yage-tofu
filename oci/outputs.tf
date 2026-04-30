output "user_ocid" {
  description = "OCID of the CAPI IAM user."
  value       = oci_identity_user.capi.id
  sensitive   = true
}

output "private_key_pem" {
  description = "PEM-encoded RSA private key for the CAPI API key."
  value       = tls_private_key.capi.private_key_pem
  sensitive   = true
}

output "fingerprint" {
  description = "API key fingerprint."
  value       = oci_identity_api_key.capi.fingerprint
}
