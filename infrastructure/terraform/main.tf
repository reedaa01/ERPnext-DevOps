resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location

  tags = {
    Project     = "ERPNext"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}