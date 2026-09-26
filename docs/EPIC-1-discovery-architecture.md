# EPIC 1 — Discovery & Architecture

**Jira :** ER-1  
**Statut :** Terminé(e)

## Objectif

Comprendre ERPNext et concevoir l'architecture cible avant de commencer Terraform et Azure.

## Tâches / LABs

| ID | LAB | Tâche | État |
|---|---|---|---|
| ER-2 | LAB-01 | Préparer l'environnement Docker | ✅ Terminé |
| ER-3 | LAB-02 | Comprendre l'architecture Frappe / ERPNext | ✅ Terminé |
| ER-4 | LAB-03 | Déployer et analyser ERPNext avec Docker Compose | ✅ Terminé |
| ER-5 | LAB-04 | Installer ERPNext localement et valider son fonctionnement | ✅ Terminé |
| ER-6 | LAB-05 | Analyser les conteneurs et les workloads ERPNext | ✅ Terminé |
| ER-7 | LAB-06 | Analyser le réseau Docker et la communication inter-services | ✅ Terminé |
| ER-8 | LAB-07 | Comprendre les volumes et la persistance | ✅ Terminé |
| ER-9 | LAB-08 | Tester les redémarrages et la persistance des données | ✅ Terminé |
| ER-10 | LAB-09 | Concevoir et documenter l'architecture ERPNext | ✅ Terminé |

## Résultat de l'EPIC

À la fin de cette phase, tu savais expliquer :

```text
ERPNext
   │
   ├── Frontend
   ├── Backend / Frappe
   ├── Workers
   ├── Scheduler
   ├── WebSocket
   │
   ├── Redis
   │    ├── Cache
   │    └── Queue
   │
   ├── MariaDB
   │
   └── Sites / Files
```

Et surtout, tu as fait le mapping vers Kubernetes :

```text
Docker                         Kubernetes
────────────────────────────────────────────
Container          →           Pod
Service            →           Service
Volume             →           PV/PVC
Docker network     →           Kubernetes Network
Service DNS        →           Kubernetes DNS
Compose            →           Kubernetes/Helm
```

## Document produit

La phase doit laisser derrière elle une documentation d'architecture contenant :

- architecture ERPNext ;
- composants ;
- flux réseau ;
- stockage ;
- composants stateful/stateless ;
- dépendances ;
- mapping Docker → Kubernetes ;
- architecture cible AKS.

## Livrable attendu

Une documentation technique claire et exploitable pour la suite du projet, notamment pour les phases suivantes :

- Terraform / Azure infrastructure
- Bootstrap AKS
- GitOps
- Déploiement ERPNext sur Kubernetes
