# ERPNext DevOps

Projet DevOps / Cloud pour déployer ERPNext sur Azure Kubernetes Service (AKS)
avec Terraform, Kubernetes, Helm et Argo CD.

## Architecture du repository

```text
ERPNext/
├── docs/                    # Documentation du projet
├── infrastructure/
│   └── terraform/           # Infrastructure Azure avec Terraform
├── K8S/
│   ├── argocd/              # Ressources Argo CD
│   ├── cert-manager/        # TLS / Let's Encrypt
│   ├── ingress-nginx/       # Ingress Controller
│   └── erpnext/             # Ressources Kubernetes ERPNext
├── helm/
│   └── erpnext/             # Helm chart ERPNext
└── frappe_docker/            # Environnement Docker local