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