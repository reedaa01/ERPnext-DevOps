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

# GitHub Actions OIDC Identity
resource "azurerm_user_assigned_identity" "github_actions" {
  name                = "id-erpnext-github-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Project     = "ERPNext"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "GitHub Actions CI/CD"
  }
}

# Federated Identity for GitHub Actions OIDC (repo: reedaa01/ERPnext-DevOps, main branch)
resource "azurerm_federated_identity_credential" "github_actions_oidc" {
  name                      = "fic-github-actions"
  user_assigned_identity_id = azurerm_user_assigned_identity.github_actions.id
  issuer                    = "https://token.actions.githubusercontent.com"
  audience                  = ["api://AzureADTokenExchange"]
  subject                   = "repo:reedaa01/ERPnext-DevOps:ref:refs/heads/main"
}