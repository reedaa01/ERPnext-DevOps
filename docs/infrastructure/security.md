# Security - Identites, RBAC et secrets

## Modele d'identite

```text
AKS
 ├── SystemAssigned Identity
 ├── Kubelet Identity
 │     └── AcrPull -> ACR
 │
 └── RBAC

Key Vault
 └── RBAC
       └── User Assigned Identity
             └── Key Vault Secrets User
```

## Controles appliques

- AKS utilise des identites managées (systeme + kubelet).
- L'identite kubelet recoit le role `AcrPull` pour lire les images depuis ACR.
- L'acces Key Vault passe par RBAC Azure et identite dediee.
- Les permissions sont attribuees selon le principe du moindre privilege.

## Bonnes pratiques

- Ne jamais stocker de secret en clair dans Git.
- Utiliser Key Vault comme source unique des secrets de production.
- Auditer regulierement les attributions RBAC.
- Appliquer HTTPS bout-en-bout sur les endpoints exposes.

## Prochaine etape

- Connecter workloads AKS a Key Vault via Managed Identity.
- Definir la rotation periodique des secrets et certificats.
