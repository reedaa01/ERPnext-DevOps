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