# EPIC 3 — Bootstrap AKS

**Jira :** ER-20  
**Statut :** Terminé(e)

## Objectif

Préparer le cluster AKS pour recevoir ERPNext en installant les composants fondamentaux de la plateforme Kubernetes :

- NGINX Ingress Controller
- cert-manager
- Let's Encrypt
- HTTPS
- Argo CD
- validation du bootstrap

## Tâches / LABs

| ID | LAB | Tâche | État |
|---|---|---|---|
| ER-21 | LAB-18 | Préparer et valider le cluster AKS | ✅ Terminé |
| ER-22 | LAB-19 | Installer NGINX Ingress Controller | ✅ Terminé |
| ER-23 | LAB-20 | Installer cert-manager | ✅ Terminé |
| ER-24 | LAB-21 | Configurer HTTPS avec Let's Encrypt | ✅ Terminé |
| ER-25 | LAB-22 | Installer Argo CD | ✅ Terminé |
| ER-26 | LAB-23 | Valider et documenter le bootstrap AKS | ✅ Terminé |

## Architecture obtenue

```text
                         Internet
                            │
                            ▼
                 erp-dev.shopvelmoria.store
                            │
                            ▼
                    Azure Public IP
                     57.168.99.255
                            │
                            ▼
                 Azure Load Balancer
                            │
                            ▼
                    NGINX Ingress
                       │       │
                    HTTP      HTTPS
                       │       │
                       │       ▼
                       │   cert-manager
                       │       │
                       │       ▼
                       │  Let's Encrypt
                       │
                       ▼
                 Kubernetes Services
```

Argo CD :

```text
Git Repository
      │
      ▼
   Argo CD
      │
      ▼
 Kubernetes API
      │
      ▼
     AKS
```

## Ce qu'on a appris

- fonctionnement d'un Ingress Controller ;
- différence entre Service, Ingress et LoadBalancer ;
- intégration Azure Load Balancer ↔ AKS ;
- DNS → IP publique → Ingress ;
- fonctionnement de cert-manager ;
- ACME / HTTP-01 ;
- certificats Let's Encrypt ;
- TLS/HTTPS dans Kubernetes ;
- installation et architecture d'Argo CD ;
- principe GitOps ;
- utilisation de Helm pour installer des composants Kubernetes ;
- validation d'un cluster avant déploiement applicatif.

## Résultat

À la fin de l'EPIC 3, AKS dispose de la plateforme nécessaire pour recevoir ERPNext :

```text
Terraform
    ↓
Azure
    ↓
AKS
    ↓
NGINX Ingress
    ↓
HTTPS / cert-manager
    ↓
Argo CD
    ↓
ERPNext       ← prochaine phase
```

## Livrable attendu

La plateforme Kubernetes est prête, sécurisée au niveau du front d'entrée, avec certificat TLS actif et GitOps initialisé pour la prochaine phase de déploiement applicatif.
