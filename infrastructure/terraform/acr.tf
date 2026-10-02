resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.acr_sku

  admin_enabled = false

  tags = {
    Project     = "ERPNext"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.main.id
}

# GitHub Actions CI/CD → AcrPush (push images to registry)
resource "azurerm_role_assignment" "github_actions_acr_push" {
  principal_id         = azurerm_user_assigned_identity.github_actions.principal_id
  role_definition_name = "AcrPush"
  scope                = azurerm_container_registry.main.id
}