# ERPNext DevOps

<p align="center">
	<img src="https://readme-typing-svg.herokuapp.com?font=JetBrains+Mono&weight=700&size=22&duration=2500&pause=800&color=00C2FF&center=true&vCenter=true&width=820&lines=%E2%9A%A1+Terraform+%E2%86%92+Azure+%E2%86%92+AKS+%E2%86%92+GitOps;%F0%9F%9A%80+ERPNext+Platform+with+Observability+and+Security" alt="animated title" />
</p>

<p align="center">
	<img src="https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white" alt="Azure" />
	<img src="https://img.shields.io/badge/AKS-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white" alt="AKS" />
	<img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform" />
	<img src="https://img.shields.io/badge/ArgoCD-EF7B4D?style=for-the-badge&logo=argo&logoColor=white" alt="Argo CD" />
	<img src="https://img.shields.io/badge/Helm-0F1689?style=for-the-badge&logo=helm&logoColor=white" alt="Helm" />
</p>

<p>
	<span style="color:#00C2FF;"><b>Projet</b></span> Cloud/DevOps pour déployer ERPNext sur Azure Kubernetes Service avec un modèle GitOps.
</p>

<img width="1536" height="1024" alt="Architecture ERPNext DevOps sur Azure" src="https://github.com/user-attachments/assets/6718fed0-6db6-42bf-9192-cdfd955e459e" />


## Cost (LAB)

| Scope | Période | Coût réel (USD) | Prévision (USD) |
|---|---|---:|---:|
| Rida Guila | Sep 1 - Oct 28, 2026 | 60.46 | 246.21 |

_Source: Azure Cost Analysis (vue Custom)._ 

## Docs

- [EPIC-9 Architecture Finale](docs/EPIC-9-Architecture-Finale.md)
- [EPIC-9 Choix Techniques & Compromis](docs/EPIC-9-Choix-Techniques-Compromis.md)
- [EPIC-9 Guide Déploiement & Exploitation](docs/EPIC-9-Guide-Deploiement-Exploitation.md)
- [EPIC-9 Documentation Finale](docs/EPIC-9-Documentation-Finale.md)

## Structure

```text
ERPNext/
├── docs/                    # Documentation projet
├── infrastructure/terraform # Infrastructure Azure
├── K8S/                     # Manifests Kubernetes & GitOps
├── helm/                    # Chart ERPNext + observability values
└── .github/workflows/       # CI GitHub Actions
```
