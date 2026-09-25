# Documentation Infrastructure - ERPNext sur Azure

Cette documentation decrit ce qui a ete construit avec Terraform et AKS pour le projet ERPNext sur Azure.

## Documents disponibles

- [Architecture](architecture.md)
- [Terraform](terraform.md)
- [Networking](networking.md)
- [Security](security.md)
- [Resources](resources.md)

## Scope technique

- Resource Group dedie
- VNet `10.20.0.0/16`
- Subnet AKS `10.20.0.0/22`
- AKS (node pool systeme)
- ACR
- Key Vault
- Log Analytics
- User Assigned Managed Identity

## Arborescence

```text
docs/
└── infrastructure/
    ├── README.md
    ├── README.html
    ├── architecture.md
    ├── terraform.md
    ├── networking.md
    ├── security.md
    └── resources.md
```

## Usage

```bash
cd infrastructure/terraform
terraform init
terraform validate
terraform plan
```

## Bonnes pratiques

- Ne pas versionner de secrets.
- Garder exclus de Git: `*.tfvars`, `*.tfstate`, `.terraform/`.
- Utiliser RBAC et Managed Identity pour les acces Azure.

## Note GitHub

GitHub rend naturellement les fichiers Markdown (`.md`) dans le depot.
Le fichier [README.html](README.html) reste utile pour une version visuelle enrichie, mais la version principale pour GitHub est [README.md](README.md).
