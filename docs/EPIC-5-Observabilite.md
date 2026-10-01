# EPIC 5 — Observabilité ERPNext & AKS

## 1. Objectif
Assurer la supervision continue d'ERPNext sur AKS, avec visibilité sur les métriques, les logs et les alertes. L'objectif est de détecter rapidement les dégradations (disponibilité, ressources, redémarrages, stockage) et de faciliter le diagnostic opérationnel.

## 2. Architecture
Composants en place :
- Prometheus : collecte des métriques.
- Grafana : visualisation des dashboards et des logs.
- Loki : stockage/requête des logs.
- Alloy : collecte des logs Kubernetes et envoi vers Loki.
- Alertmanager : réception et gestion des alertes Prometheus.

Schéma simplifié :

```text
AKS nodes/pods
   | metrics                    | logs
   v                            v
Prometheus -----------------> Alertmanager
   |
   v
Grafana <-------------------- Loki <---------------- Alloy (DaemonSet)
```

## 3. Prometheus
- Installation via kube-prometheus-stack.
- Collecte active des métriques Kubernetes (kube-state-metrics) et nodes (node-exporter).
- Rétention configurée à 7 jours.
- Suivi des métriques ERPNext/AKS : disponibilité des Deployments/StatefulSets, redémarrages de pods, CPU, mémoire, usage PVC.

## 4. Grafana
- Grafana est connecté à Prometheus pour les métriques.
- Dashboards Kubernetes disponibles pour la lecture de l'état cluster/workloads.
- Utilisé pour visualiser l'usage des ressources AKS et les workloads ERPNext.
- Grafana est également connecté à Loki pour la consultation des logs applicatifs.

## 5. Loki & Alloy
- Loki est déployé en mode monolithique (single binary) avec stockage filesystem.
- Alloy est déployé en DaemonSet sur les nodes AKS.
- Alloy découvre les pods Kubernetes, collecte leurs logs et les envoie à Loki.
- Les logs ERPNext sont consultables depuis Grafana via la source Loki.

## 6. Alerting
Règles personnalisées définies :
- ERPNextDeploymentUnavailable
- ERPNextMariaDBUnavailable
- ERPNextPodCrashLooping
- ERPNextPodRestarting
- AKSNodeHighCPU
- AKSNodeHighMemory
- PersistentVolumeAlmostFull

Pendant la validation, les règles personnalisées étaient `inactive` et `healthy`, ce qui indique qu'aucune condition anormale correspondante n'était présente.

Alertmanager est opérationnel et reçoit les alertes émises par Prometheus.

## 7. Validation
Validations réalisées sur l'implémentation actuelle :
- Prometheus opérationnel.
- Targets Prometheus fonctionnelles.
- Grafana opérationnel.
- Loki opérationnel.
- Alloy collecte et achemine les logs.
- Logs ERPNext visibles dans Grafana.
- Alertmanager opérationnel.
- Règles Prometheus chargées et saines.
- PVC et ressources Kubernetes effectivement surveillés.

## 8. Problèmes rencontrés
Points rencontrés pendant LAB-42/LAB-43 et résolution :
- Ressources mémoire insuffisantes avec les caches Loki : désactivation des caches non nécessaires (`chunksCache`, `resultsCache`) pour l'environnement.
- Conflits de configuration Loki en mode monolithique (replication factor / cibles SSD) : ajustement explicite de `replication_factor` et neutralisation des replicas `read/write/backend`.
- Adaptation de la configuration Loki/Alloy : stockage/schéma Loki explicites et pipeline Alloy aligné sur la découverte des pods Kubernetes.
- Alertes Kubernetes par défaut liées à certains composants du control plane AKS : observées comme alertes de plateforme, et non comme erreurs ERPNext.

## 9. Conclusion
L'EPIC 5 met en place une observabilité complète et exploitable pour ERPNext sur AKS : métriques, logs centralisés et alerting personnalisé. La base opérationnelle est en place, validée, et prête pour le suivi de production et l'amélioration continue.