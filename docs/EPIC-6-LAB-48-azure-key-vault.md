# EPIC 6 - LAB-48 - Integrer Azure Key Vault avec Managed Identity

## 1. Objectif
Mettre en place un flux de secrets securise entre Azure Key Vault et AKS sans identifiants Azure statiques dans les pods.

Objectifs techniques du LAB:
- Reutiliser la Key Vault existante
- Reutiliser la User Assigned Managed Identity existante
- Activer AKS Workload Identity via Terraform
- Declarer une Federated Identity Credential ciblee sur le ServiceAccount Kubernetes
- Integrer Secrets Store CSI Driver + provider Azure
- Ajouter un SecretProviderClass cible (objets nommes, pas toute la vault)
- Garder une approche GitOps et non destructive

## 2. Architecture cible

ERPNext Pod
     |
     v
Kubernetes ServiceAccount
     |
     v
Workload Identity
     |
     v
Azure Managed Identity
     |
     v
Azure Key Vault
     |
     v
Secret

## 3. Ressources Azure identifiees (existant)
- Subscription: 0ecd925a-30a0-4a1b-8085-713b0da91cc1
- Tenant: 69fac05d-67f4-4519-8b00-e4e4e6f8162d
- Resource Group: rg-erpnext-dev
- AKS: aks-erpnext-dev
- Key Vault: kv-erpnext-dev
- User Assigned Managed Identity: id-erpnext-dev

## 4. Managed Identity
Identite reutilisee (pas de recreation):
- Name: id-erpnext-dev
- Client ID: 87810cb4-d2ed-44f7-8a6a-c87149bb2dd0
- Principal ID: a4c3fc04-c574-46ed-b5c6-bfa81a79b0d5
- Resource ID: /subscriptions/0ecd925a-30a0-4a1b-8085-713b0da91cc1/resourceGroups/rg-erpnext-dev/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-erpnext-dev

## 5. AKS Workload Identity et OIDC
Mise a jour Terraform appliquee:
- oidc_issuer_enabled = true
- workload_identity_enabled = true

OIDC issuer verifie:
- https://westeurope.oic.prod-aks.azure.com/69fac05d-67f4-4519-8b00-e4e4e6f8162d/e6eda30a-d6a7-4c53-b3eb-7272e54c24b2/

## 6. Federated Identity Credential
Ajout Terraform:
- Name: fic-erpnext-workload
- Issuer: OIDC issuer AKS
- Subject: system:serviceaccount:erpnext-gitops:erpnext-workload
- Audience: api://AzureADTokenExchange

## 7. Azure RBAC
Role minimal confirme sur la Key Vault:
- Role: Key Vault Secrets User
- Scope: /subscriptions/0ecd925a-30a0-4a1b-8085-713b0da91cc1/resourceGroups/rg-erpnext-dev/providers/Microsoft.KeyVault/vaults/kv-erpnext-dev
- Principal: Managed Identity id-erpnext-dev

## 8. Secrets Store CSI Driver
Etat:
- Driver installe: secrets-store.csi.k8s.io
- CRD installee: secretproviderclasses.secrets-store.csi.x-k8s.io
- Provider Azure installe dans kube-system

## 9. SecretProviderClass
Ajout Helm:
- Fichier: helm/erpnext/templates/secretproviderclass.yaml
- Provider: azure
- Auth: Workload Identity (clientID de la UAMI)
- Key Vault ciblee: kv-erpnext-dev
- Objets cibles (nommes explicitement):
  - erpnext-mariadb-root-password
  - erpnext-admin-password
  - erpnext-db-password

## 10. ServiceAccount
Adaptation Helm:
- Fichier: helm/erpnext/templates/serviceaccount.yaml
- Nom: erpnext-workload
- Annotation: azure.workload.identity/client-id
- Label: azure.workload.identity/use=true
- Automount token active uniquement en mode Key Vault

## 11. Montage CSI
Adaptation Helm:
- Fichier: helm/erpnext/templates/backend-deployment.yaml
- Volume CSI monte sur /mnt/secrets-store
- SecretProviderClass: erpnext-keyvault
- Activation conditionnelle via values

## 12. Synchronisation vers Kubernetes Secret
Mecanisme active dans SecretProviderClass via secretObjects pour fournir:
- Secret Kubernetes: erpnext-site-secret
- Cles:
  - mariadb-root-password
  - admin-password
  - db-password

Justification:
- ERPNext et jobs existants utilisent deja des secretKeyRef
- Le sync evite une reecriture massive des workloads
- Aucune valeur de secret n est versionnee dans Git

## 13. GitOps et mode d activation
Pour ne pas casser l existant, le mode Key Vault est desactive par defaut dans values.yaml.

Activation LAB via override:
- helm/erpnext/values-lab48-keyvault.yaml

Commandes de validation:
- helm lint helm/erpnext
- helm template erpnext helm/erpnext --namespace erpnext-gitops -f helm/erpnext/values-lab48-keyvault.yaml
- helm template erpnext helm/erpnext --namespace erpnext-gitops -f helm/erpnext/values-lab48-keyvault.yaml | kubectl apply --dry-run=server -f -

## 14. Tests realises
Realises sans exposition de valeurs de secret:
- terraform fmt
- terraform validate
- terraform plan
- terraform apply (cible identite/federation)
- az aks show (OIDC + workload identity)
- az identity show
- az identity federated-credential list
- az role assignment list (scope Key Vault)
- kubectl get csidriver + CRD + pods provider
- helm lint
- helm template
- kubectl apply --dry-run=server

## 15. Securite
Pourquoi plus securise que des credentials statiques:
- Pas de client secret Azure dans Kubernetes
- Authentification feder ee basee sur OIDC + tokens courts
- Scope RBAC minimal (Key Vault Secrets User)
- Secret values non presentes dans Git
- Secret retrieval a la demande via CSI

## 16. Limites
- Le compte Azure courant utilise pour les commandes n a pas l autorisation de lister les metadonnees de secrets dans la Key Vault.
- Le test applicatif complet de lecture reelle d un secret par un pod ERPNext depend de l existence des objets Key Vault cibles et du deploiement GitOps de cette revision.
- Aucun secret n a ete cree/modifie par ce LAB pour eviter toute manipulation sensible hors procedure d exploitation.

## 17. Rollback
Rollback applicatif:
1. Revenir a une revision Git precedente sans integration Key Vault.
2. Re-synchroniser Argo CD.

Rollback infrastructure:
1. terraform plan pour verifier les changements inverses.
2. terraform apply pour retirer uniquement:
   - azurerm_federated_identity_credential.erpnext_workload
   - workload_identity_enabled (si besoin)
3. Ne jamais executer terraform destroy.
