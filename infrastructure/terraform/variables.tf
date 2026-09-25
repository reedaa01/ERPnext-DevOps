variable "project_name" {
  description = "Nom du projet"
  type        = string
  default     = "erpnext"
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Région Azure"
  type        = string
  default     = "westeurope"
}
variable "vnet_address_space" {
  description = "CIDR du VNet Azure"
  type        = string
  default     = "10.20.0.0/16"
}

variable "aks_subnet_address_prefix" {
  description = "CIDR du subnet AKS"
  type        = string
  default     = "10.20.0.0/22"
}
variable "acr_name" {
  description = "Nom globalement unique de l'Azure Container Registry"
  type        = string
  default     = "acrerpnextdev"
}

variable "acr_sku" {
  description = "SKU de l'Azure Container Registry"
  type        = string
  default     = "Basic"
}

variable "kubernetes_version" {
  description = "Version Kubernetes du cluster AKS"
  type        = string
  default     = "1.36.3"
}

variable "aks_node_count" {
  description = "Nombre de nodes du system node pool"
  type        = number
  default     = 2
}

variable "aks_vm_size" {
  description = "Taille des VM du system node pool"
  type        = string
  default     = "Standard_D4ads_v6"
}
variable "key_vault_name" {
  description = "Nom globalement unique du Key Vault"
  type        = string
  default     = "kv-erpnext-dev"
}

variable "log_analytics_name" {
  description = "Nom du Log Analytics Workspace"
  type        = string
  default     = "law-erpnext-dev"
}

variable "managed_identity_name" {
  description = "Nom de la Managed Identity"
  type        = string
  default     = "id-erpnext-dev"
}