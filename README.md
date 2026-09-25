# Projet DevOps: Déploiement ERPNext sur Azure

Ce document présente l'architecture, les prérequis et le flux CI/CD pour déployer ERPNext sur Azure avec Terraform et Docker, en appliquant les bonnes pratiques de sécurité et d'exploitation.

## Badges

- Azure
- Terraform
- Docker
- GitHub Actions
- ERPNext

## Objectif

Industrialiser le déploiement d'ERPNext sur Microsoft Azure avec une approche Infrastructure as Code, en garantissant la reproductibilité, la sécurité des secrets et la supervision des environnements.

- Provisionner réseau et ressources Azure via Terraform.
- Déployer ERPNext avec Docker Compose et configurations adaptées.
- Automatiser build, test, plan, apply et déploiement via pipeline CI/CD.
- Appliquer la segmentation des environnements (dev, staging, prod).

## Arborescence utile

```text
ERPNext/
├─ frappe_docker/
│  ├─ compose.yaml
│  └─ overrides/
└─ infrastructure/
   └─ terraform/
      ├─ main.tf
      ├─ network.tf
      ├─ providers.tf
      ├─ variables.tf
      └─ outputs.tf
```

## Prérequis

- Compte Azure avec abonnement actif.
- Azure CLI connecté : `az login`
- Terraform installé (version compatible providers)
- Docker et Docker Compose installés
- Accès GitHub pour pipeline et gestion des secrets

> Conseil : stocker les secrets dans Azure Key Vault ou GitHub Secrets, jamais dans les fichiers suivis par Git.

## Flux de déploiement

1. Initialisation Terraform : `terraform init` puis validation `terraform plan`.
2. Provision des ressources réseau et compute sur Azure.
3. Build images et déploiement des services ERPNext avec Docker Compose.
4. Vérification post-déploiement (santé services, logs, tests de connectivité).

## Exemple de commandes

```bash
cd infrastructure/terraform
terraform init
terraform fmt
terraform validate
terraform plan -out tfplan
# terraform apply tfplan
```

```bash
cd frappe_docker
docker compose -f compose.yaml up -d
# Optionnel avec override:
# docker compose -f compose.yaml -f overrides/compose.proxy.yaml up -d
```

## Sécurité

- Ignorer les fichiers sensibles : `*.tfvars`, `*.tfstate`, `.terraform/`
- Utiliser des identités managées quand possible
- Restreindre les ports avec NSG et règles minimales
- Activer journalisation et alertes Azure Monitor

> Important : ne pas committer de mots de passe, clés API ou chaînes de connexion en clair.

## Pipeline CI/CD recommandé (résumé)

- Étape 1 : lint + tests Terraform et scripts.
- Étape 2 : Terraform plan sur pull request.
- Étape 3 : approbation manuelle avant apply en production.
- Étape 4 : déploiement Docker ERPNext et checks de santé.
- Étape 5 : supervision continue et rollback documenté.

---

Documentation projet - ERPNext DevOps sur Azure
