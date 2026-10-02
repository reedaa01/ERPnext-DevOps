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

resource "azurerm_federated_identity_credential" "erpnext_workload" {
  name                      = "fic-erpnext-workload"
  user_assigned_identity_id = azurerm_user_assigned_identity.erpnext.id
  issuer                    = azurerm_kubernetes_cluster.main.oidc_issuer_url
  audience                  = ["api://AzureADTokenExchange"]
  subject                   = "system:serviceaccount:erpnext-gitops:erpnext-workload"
}