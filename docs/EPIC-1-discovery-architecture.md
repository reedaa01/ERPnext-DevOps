# EPIC 1 — Discovery & Architecture

> ERPNext · Frappe · Docker · mapping Kubernetes

---

## 01 / Objectif

Définir le modèle d'architecture ERPNext avant le provisionnement Azure et le déploiement AKS.

## 02 / Architecture fonctionnelle ERPNext

```mermaid
flowchart TB
    FE[Frontend] --> BE[Backend Frappe]
    WS[WebSocket] --> BE
    SCH[Scheduler] --> BE
    QS[Queue Short] --> BE
    QL[Queue Long] --> BE
    BE --> DB[(MariaDB)]
    BE --> RC[(Redis Cache)]
    BE --> RQ[(Redis Queue)]
    BE --> SITES[(Sites / Assets)]
```

## 03 / Composants clés

| Domaine | Composant | Rôle |
|---|---|---|
| Application | Frontend | Exposition web ERPNext |
| Application | Backend Frappe | API et logique applicative |
| Application | WebSocket | Temps réel |
| Exécution | Scheduler | Planification des jobs |
| Exécution | queue-short / queue-long | Exécution asynchrone |
| Data | MariaDB | Base transactionnelle |
| Data | Redis cache / queue | Cache et broker de tâches |
| Stockage | Sites | Données partagées applicatives |

## 04 / Mapping Docker vers Kubernetes

| Docker | Kubernetes |
|---|---|
| Container | Pod |
| Compose service | Deployment / StatefulSet |
| Volume | PV / PVC |
| Docker network | CNI + Services |
| DNS Compose | CoreDNS |

## 05 / Cibles techniques préparées

- Découpage stateful/stateless.
- Dépendances inter-services ERPNext.
- Exigences stockage persistant (DB, sites/assets).
- Exposition HTTP/HTTPS via Ingress.
- Trajectoire GitOps pour les déploiements.

## 06 / Compétences

- Architecture ERPNext/Frappe
- Docker Compose
- Modélisation Kubernetes
- Cartographie réseau et persistance
- Préparation migration vers AKS