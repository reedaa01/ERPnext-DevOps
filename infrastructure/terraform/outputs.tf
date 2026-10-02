output "project_name" {
  description = "Nom du projet"
  value       = var.project_name
}

output "environment" {
  description = "Environnement"
  value       = var.environment
}

output "location" {
  description = "Région Azure"
  value       = var.location
}
output "resource_group_name" {
  description = "Nom du Resource Group Azure"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID du Resource Group Azure"
  value       = azurerm_resource_group.main.id
}
output "acr_login_server" {
  description = "URL du registry ACR"
  value       = azurerm_container_registry.main.login_server
}

output "aks_name" {
  description = "Nom du cluster AKS"
  value       = azurerm_kubernetes_cluster.main.name
}

output "aks_oidc_issuer_url" {
  description = "OIDC issuer URL du cluster AKS"
  value       = azurerm_kubernetes_cluster.main.oidc_issuer_url
}

output "key_vault_name" {
  description = "Nom du Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_id" {
  description = "ID du Key Vault"
  value       = azurerm_key_vault.main.id
}

output "managed_identity_name" {
  description = "Nom de la User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.erpnext.name
}

output "managed_identity_id" {
  description = "Resource ID de la User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.erpnext.id
}

output "managed_identity_client_id" {
  description = "Client ID de la User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.erpnext.client_id
}

output "managed_identity_principal_id" {
  description = "Principal ID de la User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.erpnext.principal_id
}