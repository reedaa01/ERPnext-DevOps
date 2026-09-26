# EPIC 2 — Infrastructure as Code / Terraform

**Jira :** ER-11  
**Statut :** Terminé(e)

## Objectif

Construire toute l'infrastructure Azure nécessaire au projet ERPNext avec Terraform, de manière reproductible et sans configuration manuelle dans le portail Azure.

## Tâches / LABs

| ID | LAB | Tâche | État |
|---|---|---|---|
| ER-12 | LAB-10 | Préparer le projet Terraform | ✅ Terminé |
| ER-13 | LAB-11 | Créer le Resource Group Azure | ✅ Terminé |
| ER-14 | LAB-12 | Concevoir et créer le réseau Azure | ✅ Terminé |
| ER-15 | LAB-13 | Configurer les NSG | ✅ Terminé |
| ER-16 | LAB-14 | Créer Azure Container Registry | ✅ Terminé |
| ER-17 | LAB-15 | Créer le cluster AKS | ✅ Terminé |
| ER-18 | LAB-16 | Ajouter Key Vault, Log Analytics et Managed Identity | ✅ Terminé |
| ER-19 | LAB-17 | Valider et documenter l'infrastructure Terraform | ✅ Terminé |

## Infrastructure construite

```text
Azure
│
├── Resource Group
│
├── VNet 10.20.0.0/16
│   └── AKS Subnet 10.20.0.0/22
│       └── NSG
│
├── Azure Container Registry
│
├── AKS
│   └── 2 × System Nodes
│
├── Key Vault
│
├── Log Analytics Workspace
│
└── Managed Identity
```

## Compétences acquises

- Terraform providers
- Variables et outputs
- Terraform State
- `terraform init`
- `terraform fmt`
- `terraform validate`
- `terraform plan`
- `terraform apply`
- Azure Resource Group
- VNet / Subnet
- NSG et règles réseau
- ACR
- AKS
- Managed Identity
- RBAC Azure
- Key Vault
- Log Analytics
- intégration AKS ↔ ACR
- infrastructure déclarative et reproductible

## Principe appliqué

```text
Terraform
    │
    ▼
Azure Resources
    │
    ├── Networking
    ├── Security
    ├── Registry
    ├── Kubernetes
    ├── Identity
    └── Monitoring
```

## Livrable attendu

La phase doit avoir produit une base Azure fonctionnelle, versionnée en code Terraform, prête à recevoir le bootstrap AKS et les composants de runtime ERPNext.
