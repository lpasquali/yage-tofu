terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.52"
    }
  }
  required_version = ">= 1.6"
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}

resource "azuread_application" "capi" {
  display_name = "yage-capi-${var.cluster_name}"
}

resource "azuread_service_principal" "capi" {
  client_id = azuread_application.capi.client_id
}

resource "azuread_service_principal_password" "capi" {
  service_principal_id = azuread_service_principal.capi.id
}

resource "azurerm_role_assignment" "capi" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.capi.object_id
}
