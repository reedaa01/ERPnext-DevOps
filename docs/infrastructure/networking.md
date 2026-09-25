# Networking - Plan d'adressage et filtrage

## Plan d'adressage

```text
VNet
10.20.0.0/16
    │
    └── snet-aks
        10.20.0.0/22
            │
            ├── Node 1 -> 10.20.0.4
            └── Node 2 -> 10.20.0.5
```

## Politique reseau (NSG)

Regles attendues:

- HTTPS 443 -> Allow
- HTTP 80 -> Allow
- SSH 22 -> Non expose
- MariaDB -> Non expose
- Redis -> Non expose

## Principes

- Exposition minimale des services publics.
- Aucun acces direct aux ports d'administration des workloads.
- Les flux est-ouest sont controles et prepares pour Network Policies Kubernetes.

## Evolutions recommandees

- Ajouter des NSG rules detaillees par source/destination.
- Integrer WAF/Ingress policy selon les exigences applicatives.
- Mettre en place audits de flux et alertes en cas de deviation.
