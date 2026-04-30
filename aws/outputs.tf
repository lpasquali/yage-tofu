output "access_key_id" {
  description = "AWS access key ID for the CAPI IAM user."
  value       = aws_iam_access_key.capi.id
  sensitive   = true
}

output "secret_access_key" {
  description = "AWS secret access key for the CAPI IAM user."
  value       = aws_iam_access_key.capi.secret
  sensitive   = true
}
