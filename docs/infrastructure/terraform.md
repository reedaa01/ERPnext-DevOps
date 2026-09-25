# Terraform - Standards et fonctionnement

## Version Terraform

- Terraform CLI: version verrouillee dans l'equipe (a documenter dans le pipeline).
- Le depot contient le lock provider dans `.terraform.lock.hcl` pour la reproductibilite.

## Provider AzureRM

- Provider principal: `hashicorp/azurerm`.
- Gestion des ressources Azure via Infrastructure as Code uniquement.

## Variables

- Les variables sont declarees dans `variables.tf`.
- Les valeurs d'environnement sont injectees via fichiers `*.tfvars` non versionnes.
- Les secrets ne sont pas commites (exclus via `.gitignore`).

## State Terraform

- Le state local est utile en phase labo, mais non recommande pour la prod.
- Cible entreprise: backend distant (ex: Azure Storage + verrouillage).
- Les fichiers `*.tfstate` et locks sont exclus du depot Git.

## Plan / Apply

Flux recommande:

1. `terraform fmt`
2. `terraform validate`
3. `terraform plan`
4. `terraform apply` apres revue et approbation

## Dependances Terraform

- Les dependances sont resolues implicitement via references inter-ressources.
- Les references doivent rester explicites pour eviter les ordres de creation ambigus.

## Reproductibilite

- Reposant sur:
  - code Terraform versionne,
  - lock provider,
  - conventions de nommage,
  - pipeline CI qui verifie `fmt/validate/plan`.
- Objectif: reconstruire l'infrastructure sur un environnement vierge de facon deterministe.
