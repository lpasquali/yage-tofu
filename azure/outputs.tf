output "client_id" {
  description = "Azure AD application (client) ID."
  value       = azuread_application.capi.client_id
  sensitive   = true
}

output "client_secret" {
  description = "Azure AD service principal client secret."
  value       = azuread_service_principal_password.capi.value
  sensitive   = true
}

output "tenant_id" {
  description = "Azure AD tenant ID."
  value       = data.azurerm_subscription.current.tenant_id
  sensitive   = true
}

output "subscription_id" {
  description = "Azure subscription ID."
  value       = data.azurerm_subscription.current.subscription_id
  sensitive   = true
}
