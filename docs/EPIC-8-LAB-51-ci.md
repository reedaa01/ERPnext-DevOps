# EPIC 8 — LAB-51 : Préparer le pipeline CI

## Objectif
Mettre en place la base du pipeline CI GitHub Actions pour valider le dépôt ERPNext DevOps avant les prochains labs. L'objectif est de sécuriser les changements en amont, sans déployer quoi que ce soit vers AKS.

## Déclencheurs
Le workflow CI est déclenché sur :
- `push` vers `main`
- `pull_request` vers `main`

## Jobs CI

### 1. Terraform
Le job Terraform cible uniquement `infrastructure/terraform/` et exécute :
- `terraform fmt -check -recursive`
- `terraform init -backend=false -input=false`
- `terraform validate`

Ce job vérifie la cohérence du code Terraform sans appliquer ni détruire de ressources.

### 2. Helm
Le job Helm valide les charts et leurs valeurs :
- `helm lint helm/erpnext`
- rendu Helm de `helm/erpnext`
- lint et rendu des charts d'observabilité associés aux fichiers de valeurs du dossier `helm/observability/`

Les charts d'observabilité sont validés à partir des versions publiques épinglées suivantes :
- Loki `18.13.7`
- kube-prometheus-stack `91.9.0`
- Alloy `1.13.0`

### 3. Kubernetes manifests
Le job Kubernetes prend les manifestes rendus par Helm et les passe en validation offline :
- `kubectl apply --dry-run=client --validate=false`

Cette étape vérifie la structure des manifestes sans contact avec un cluster AKS.

## Validations effectuées
Le pipeline prépare trois niveaux de contrôle :
- syntaxe et format Terraform
- lint et rendu Helm
- validation Kubernetes en dry-run client

## Séparation CI / CD
Ce workflow est volontairement limité à la validation.
Il ne fait aucun :
- `terraform apply`
- `terraform destroy`
- déploiement Helm vers AKS
- synchronisation Argo CD
- accès à un kubeconfig de production

Cette séparation évite qu'un simple `push` ou une `pull_request` modifie l'infrastructure.

## Pourquoi la CI ne déploie pas sur AKS
Le dépôt suit une logique GitOps. La CI doit seulement contrôler que les artefacts sont valides avant fusion. Le déploiement réel reste hors du pipeline de validation pour préserver :
- la maîtrise des changements de cluster
- la séparation entre validation et exécution
- la sécurité des environnements Kubernetes et Azure

## Compétences acquises
- structuration d'un workflow GitHub Actions multi-jobs
- validation Terraform sans modification d'infrastructure
- lint et rendu Helm
- validation Kubernetes en dry-run client
- séparation claire entre CI et CD
- gestion de versions d'actions GitHub et de charts Helm

## Résultat attendu
LAB-51 fournit une base CI réutilisable pour les prochains labs, avec des contrôles automatisés avant toute évolution de l'infrastructure ou des manifests.