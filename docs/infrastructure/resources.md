# Inventaire des ressources Azure

## Tableau synthese

| Ressource | Nom | Role |
|---|---|---|
| Resource Group | rg-erpnext-dev | Conteneur logique |
| VNet | vnet-erpnext-dev | Reseau |
| Subnet | snet-aks | Reseau AKS |
| NSG | nsg-aks-dev | Filtrage reseau |
| ACR | acrerpnextdev | Registry |
| AKS | aks-erpnext-dev | Cluster Kubernetes |
| Key Vault | kv-erpnext-dev | Secrets |
| Log Analytics | law-erpnext-dev | Logs/monitoring |
| Managed Identity | id-erpnext-dev | Identite Azure |

## Notes d'exploitation

- Les noms suivent une convention `type-projet-env`.
- Les ressources sont cibles pour un environnement `dev`.
- Ce fichier sert de reference rapide pour l'equipe DevOps, SecOps et Ops.
