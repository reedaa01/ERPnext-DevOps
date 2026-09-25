resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  address_space = [var.vnet_address_space]

  tags = {
    Project     = "ERPNext"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_subnet" "aks" {
  name                 = "snet-aks"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = [var.aks_subnet_address_prefix]
}