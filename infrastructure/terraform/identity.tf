resource "azurerm_user_assigned_identity" "erpnext" {
  name                = var.managed_identity_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Project     = "ERPNext"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}