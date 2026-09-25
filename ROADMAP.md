# Roadmap Professionnelle - ERPNext sur Azure (DevOps)

## Vision
Construire une plateforme ERPNext sur Azure, entièrement industrialisée, sécurisée et opérable en production, avec une approche GitOps et Infrastructure as Code.

## Principes directeurs
- Pas de configuration manuelle dans Azure (hors initialisation du compte).
- Tout changement doit être versionné, relu et traçable.
- Sécurité by design et observabilité by default.
- Déploiement progressif, avec critères de sortie à chaque phase.

---

## Phase 0 - Architecture
### Objectif
Concevoir la cible technique avant toute implémentation Terraform.

### Travaux
- Analyser les besoins ERPNext (charge, disponibilité, conformité, RTO/RPO).
- Identifier les composants applicatifs et plateforme.
- Dessiner l'architecture cible (compute, réseau, stockage, sécurité, observabilité).
- Définir les flux réseau (north-south et east-west).
- Définir les besoins de stockage (DB, fichiers, backups, logs).
- Définir les exigences de sécurité (IAM, secrets, chiffrement, segmentation).

### Livrables
- Diagramme d'architecture Azure.
- Catalogue des composants.
- Matrice des flux réseau.
- Dossier d'exigences de sécurité.

### Critères de sortie
- Architecture validée techniquement.
- Risques majeurs identifiés et plan d'atténuation rédigé.

---

## Phase 1 - Terraform
### Objectif
Provisionner la fondation cloud uniquement via code.

### Périmètre
- Resource Group
- VNet
- Subnets
- NSG
- ACR
- AKS
- Key Vault
- Log Analytics
- Managed Identity

### Exigences
- Modules Terraform structurés.
- Variables et outputs explicites.
- State distant sécurisé (backend).
- Nommage normalisé et tags obligatoires.

### Critères de sortie
- `terraform fmt`, `validate` et `plan` propres.
- Reproductibilité confirmée sur environnement vierge.

---

## Phase 2 - Bootstrap AKS
### Objectif
Installer le socle Kubernetes nécessaire à l'exploitation.

### Composants
- NGINX Ingress Controller
- cert-manager
- Argo CD

### Critères de sortie
- Ingress opérationnel.
- Certificats TLS automatisés.
- Argo CD synchronisant un dépôt de test.

---

## Phase 3 - GitOps
### Objectif
Séparer les responsabilités et industrialiser les flux de changement.

### Dépôts à créer
- Dépôt 1: infrastructure Terraform
- Dépôt 2: manifests GitOps
- Dépôt 3: configuration Helm

### Règles
- Branch protection + PR obligatoires.
- Revue de code systématique.
- Convention de versionnement et releases.

### Critères de sortie
- Promotion dev -> staging -> prod pilotée par Git.
- Rollback documenté et testé.

---

## Phase 4 - Déployer ERPNext
### Objectif
Déployer ERPNext de manière fiable sur AKS.

### Concepts maîtrisés
- StatefulSets
- Persistent Volumes
- Persistent Volume Claims
- ConfigMaps
- Secrets
- Jobs
- CronJobs

### Critères de sortie
- ERPNext accessible et stable.
- Persistance vérifiée après redémarrage/replanification.
- Jobs de maintenance opérationnels.

---

## Phase 5 - Observabilité
### Objectif
Rendre la plateforme observable, mesurable et exploitable.

### Stack
- Prometheus
- Grafana
- Loki

### Résultats attendus
- Dashboards applicatifs ERPNext.
- Dashboards infrastructure AKS.
- Alertes actionnables (latence, erreurs, saturation CPU/RAM/disque, indisponibilité).

### Critères de sortie
- Runbook d'alerte disponible.
- MTTR réduit par instrumentation pertinente.

---

## Phase 6 - Sécurité
### Objectif
Renforcer la posture sécurité de bout en bout.

### Contrôles
- Network Policies
- Pod Security Standards
- RBAC
- Secrets via Azure Key Vault
- Managed Identity
- HTTPS
- Rotation des secrets

### Critères de sortie
- Moindre privilège appliqué.
- Aucune exposition de secret en clair dans les dépôts.
- Contrôles sécurité audités et validés.

---

## Phase 7 - Sauvegarde et reprise
### Objectif
Assurer la continuité d'activité et la résilience.

### Périmètre
- Sauvegarde MariaDB
- Sauvegarde volumes persistants
- Tests de restauration
- Documentation du plan de reprise après incident (DR)

### Critères de sortie
- Restauration testée avec succès.
- RTO/RPO mesurés et conformes aux objectifs.

---

## Phase 8 - Industrialisation
### Objectif
Automatiser les contrôles qualité et sécurité de la chaîne de livraison.

### Intégrations
- GitHub Actions
- Lint Terraform
- Validation des manifests
- Tests Helm
- Scans de sécurité (Trivy)
- Scans d'images conteneurs

### Critères de sortie
- Pipelines bloquants en cas de non-conformité.
- Preuve d'exécution des contrôles à chaque PR.

---

## Phase 9 - Documentation
### Objectif
Fournir une documentation professionnelle et exploitable par les équipes.

### Contenu
- Diagrammes d'architecture
- Choix techniques et compromis
- Guide de déploiement
- Procédures d'exploitation
- Procédures de reprise
- Coûts estimés
- Pistes d'amélioration

### Critères de sortie
- Documentation versionnée, à jour, et relue.
- Onboarding d'un nouvel ingénieur possible sans transfert oral.

---

## Gouvernance et pilotage
### Rituels recommandés
- Revue hebdomadaire d'avancement par phase.
- Revue des risques et décisions d'architecture.
- Démonstration de fin de phase avec preuves techniques.

### Indicateurs suggérés
- Lead time de changement.
- Taux d'échec des déploiements.
- MTTR.
- Couverture des alertes critiques.
- Conformité sécurité (secrets, RBAC, policies).

## Prochaine étape conseillée
Démarrer par la production des livrables de la phase 0 (architecture + flux + sécurité), puis figer un backlog technique découpé en epics et user stories pour la phase 1.
