output "api_key" {
  description = "IBM Cloud API key for the CAPI service ID."
  value       = ibm_iam_service_api_key.capi.apikey
  sensitive   = true
}

output "service_id" {
  description = "IBM Cloud IAM service ID."
  value       = ibm_iam_service_id.capi.iam_id
}
