# Architecture - ERPNext sur Azure

## Vue d'ensemble

```text
Azure
│
└── Resource Group
    │
    ├── VNet 10.20.0.0/16
    │   └── snet-aks 10.20.0.0/22
    │       └── AKS
    │           └── System Node Pool
    │               ├── Node 1
    │               └── Node 2
    │
    ├── ACR
    │
    ├── Key Vault
    │
    ├── Log Analytics
    │
    └── User Assigned Managed Identity
```

## Description des composants

- Resource Group: conteneur logique de toutes les ressources du projet ERPNext.
- VNet + Subnet AKS: isolation reseau du cluster Kubernetes.
- AKS: plateforme d'execution des charges applicatives ERPNext.
- ACR: registre prive des images conteneurs.
- Key Vault: stockage securise des secrets et certificats.
- Log Analytics: centralisation des logs et monitoring Azure.
- User Assigned Managed Identity: identite reutilisable pour acces securise aux services.

## Hypotheses d'exploitation

- Les noeuds AKS sont places dans le subnet dedie `snet-aks`.
- Les composants de securite reposent sur RBAC Azure et identites managées.
- Le cluster est pret a etre etendu pour GitOps et observabilite (phases suivantes).
