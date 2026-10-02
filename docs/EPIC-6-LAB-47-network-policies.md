# LAB-47 - Network Policies ERPNext

## 1. Objectif

Le but de ce lab est de passer d'un modele reseau permissif a une isolation de type least privilege pour le namespace `erpnext-gitops`. La strategie cible limite les communications entre les Pods ERPNext aux seuls flux utiles au fonctionnement de l'application, tout en gardant les regles lisibles et maintenables via Helm + Argo CD.

## 2. Architecture reseau observee

L'application ERPNext s'exécute dans `erpnext-gitops` avec les workloads suivants : `frontend`, `backend`, `websocket`, `queue-short`, `queue-long`, `scheduler`, `redis-cache`, `redis-queue` et `mariadb`.

Les labels observes sur les Pods permettent des selectors stables bases sur `app=<role>` et sur les labels Helm standard (`app.kubernetes.io/instance`, `app.kubernetes.io/part-of`, `helm.sh/chart`). Le trafic externe arrive via le controller NGINX Ingress du namespace `ingress-nginx`.

## 3. NetworkPolicy engine detecte

Le cluster AKS expose le label noeud `kubernetes.azure.com/network-policy=none`. Cela indique qu'aucun moteur NetworkPolicy effectif n'est active pour l'instant. Les policies sont donc preparees dans Git et prêtes a etre appliquees, mais leur enforcement ne sera reel qu'apres activation d'un moteur reseau compatible sur AKS.

## 4. Flux reseau autorises

| Source | Destination | Port | Protocole | Raison |
| --- | --- | --- | --- | --- |
| ingress-nginx controller | frontend | 8080 | TCP | Exposer l'application au trafic HTTP(S) entrant via l'Ingress NGINX |
| frontend | backend | 8000 | TCP | Le frontend proxy les appels applicatifs vers le backend ERPNext |
| frontend | websocket | 9000 | TCP | Le frontend doit joindre le service Socket.IO |
| backend | mariadb | 3306 | TCP | Acces applicatif aux donnees ERPNext |
| backend | redis-cache | 6379 | TCP | Cache et coordination interne ERPNext |
| backend | redis-queue | 6379 | TCP | Traitement asynchrone et files de jobs |
| queue-short / queue-long / scheduler | mariadb | 3306 | TCP | Taches planifiees et workers ayant besoin de la base |
| queue-short / queue-long / scheduler | redis-queue | 6379 | TCP | Consommation de la file de jobs |
| websocket | redis-queue | 6379 | TCP | Socket.IO et coordination de la couche temps reel |
| erpnext-site-init | mariadb | 3306 | TCP | Initialisation du site ERPNext |
| tous les Pods ERPNext | CoreDNS | 53 | UDP/TCP | Resolution DNS Kubernetes |

## 5. NetworkPolicies creees

### `erpnext-default-deny-ingress`

- Selector: `podSelector: {}` dans `erpnext-gitops`
- Ingress: aucun flux autorise par defaut
- Egress: non concerne
- Justification: instaurer la base de confinement ingress pour tout le namespace.

### `erpnext-default-deny-egress`

- Selector: `podSelector: {}` dans `erpnext-gitops`
- Ingress: non concerne
- Egress: aucun flux autorise par defaut
- Justification: bloquer les sorties non declarees avant d'ajouter les exceptions necessaires.

### `erpnext-allow-dns`

- Selector: tous les Pods du namespace
- Egress: vers `kube-system` / `k8s-app=kube-dns` sur 53 UDP et TCP
- Justification: sans DNS, les services internes `backend`, `websocket`, `mariadb` et Redis ne peuvent pas etre resolus correctement.

### `erpnext-allow-frontend-from-ingress-nginx`

- Selector: `app=frontend`
- Ingress: uniquement depuis le controller NGINX Ingress du namespace `ingress-nginx`
- Ports: 8080/TCP
- Justification: le frontend ne doit pas etre exposé a tout le cluster.

### `erpnext-allow-frontend-egress`

- Selector: `app=frontend`
- Egress: vers `backend` sur 8000/TCP et vers `websocket` sur 9000/TCP
- Justification: le frontend reverse-proxy les appels applicatifs et la couche temps reel vers ces deux services.

### `erpnext-allow-backend`

- Selector: `app=backend`
- Ingress: depuis `frontend` uniquement sur 8000/TCP
- Egress: vers `mariadb`, `redis-cache` et `redis-queue`
- Justification: le backend est le coeur applicatif et ne doit parler qu'aux composants dont il depend reellement.

### `erpnext-allow-websocket`

- Selector: `app=websocket`
- Ingress: depuis `frontend` uniquement sur 9000/TCP
- Egress: vers `redis-queue`
- Justification: Socket.IO doit rester isole et ne contacter que la file de messages requise.

### `erpnext-allow-mariadb`

- Selector: `app=mariadb`
- Ingress: depuis `backend`, `queue-short`, `queue-long`, `scheduler`, `erpnext-site-init`
- Ports: 3306/TCP
- Justification: MariaDB ne doit accepter que les clients ERPNext qui utilisent reellement la base.

### `erpnext-allow-redis-cache`

- Selector: `app=redis-cache`
- Ingress: depuis `backend` uniquement sur 6379/TCP
- Justification: le cache Redis n'a pas vocation a etre consomme par d'autres workloads.

### `erpnext-allow-redis-queue`

- Selector: `app=redis-queue`
- Ingress: depuis `backend`, `queue-short`, `queue-long`, `scheduler`, `websocket`
- Ports: 6379/TCP
- Justification: la file de jobs et la couche temps reel sont les seuls consommateurs declares.

### `erpnext-allow-workers-egress`

- Selector: `app in [queue-short, queue-long, scheduler]`
- Egress: vers `mariadb` et `redis-queue`
- Justification: les workers et le scheduler doivent pouvoir traiter les jobs et persister l'etat necessaire.

### `erpnext-allow-site-init-egress`

- Selector: `app=erpnext-site-init`
- Egress: vers `mariadb`
- Justification: le job d'initialisation du site doit uniquement preparer la base ERPNext.

## 6. Principe least privilege

La strategie applique le minimum utile a chaque composant. Les politiques ne laissent pas un namespace entier parler librement a MariaDB ou Redis. Le frontend n'accede qu'au backend et au service websocket. Les workers ne parlent qu'aux services de persistence ou de file de jobs. Les flux transverses sont reserves a DNS et a l'Ingress NGINX.

## 7. Strategie default deny

Deux policies de base sont posees : une pour l'ingress, une pour l'egress. Elles sont volontairement deployees avant les allow rules, afin d'exprimer clairement la posture de securite cible. Dans le cluster actuel, l'enforcement reste inactif tant que `kubernetes.azure.com/network-policy=none` est presente.

## 8. DNS

Les Pods ERPNext doivent resoudre les noms de services Kubernetes. La policy DNS cible les Pods CoreDNS du namespace `kube-system` via le label `k8s-app=kube-dns` et autorise les ports 53 UDP et TCP. Aucun autre trafic vers `kube-system` n'est autorise.

## 9. Ingress NGINX

Le traffic entrant vers `frontend` est limite au controller NGINX Ingress du namespace `ingress-nginx`. Le selector combine le namespace et les labels du controller pour eviter d'autoriser tout le namespace ou tout Pod du cluster.

## 10. MariaDB

MariaDB n'accepte que les clients ERPNext declares dans l'architecture actuelle. Le frontend, NGINX et les services non relies a la persistence n'ont aucun acces a la base.

## 11. Redis

Deux services Redis sont distingues. `redis-cache` est reserve au backend. `redis-queue` est reserve au backend, aux workers, au scheduler et au websocket. Cette separation reduit les risques de couplage inutile entre cache, file de jobs et temps reel.

## 12. Egress

Aucun besoin externe explicite n'a ete declare dans les manifests Helm observes. La strategie choisie bloque donc l'egress generique et n'autorise que DNS plus les services internes identifiés. Si une future integration ERPNext requiert SMTP ou une API tierce, il faudra ajouter une exception egress documentee plutot que rouvrir l'ensemble du trafic sortant.

## 13. Tests positifs

Les tests positifs attendus sont : `backend -> MariaDB`, `backend -> Redis cache`, `backend -> Redis queue`, `queue-short/queue-long/scheduler -> MariaDB`, `queue-short/queue-long/scheduler -> Redis queue`, `frontend -> backend`, `frontend -> websocket`, et resolution DNS par les Pods ERPNext.

## 14. Tests negatifs

Les tests negatifs attendus sont : `frontend -> MariaDB`, `frontend -> Redis cache`, `frontend -> Redis queue`, et tout acces direct non declare vers les services de persistence depuis des Pods non autorises.

## 15. Resultats

Les policies sont ajoutees au chart Helm et pretes pour un deploiement GitOps. Le cluster courant ne dispose pas d'un moteur NetworkPolicy actif, donc l'enforcement n'a pas pu etre verifie en conditions reelles sur les Pods en place.

## 16. Limites

- Le moteur reseau du cluster est desactive (`network-policy=none`).
- Les policies sont donc preparatoires et ne prouvent pas encore l'isolation effective.
- Les besoins externes eventuels de ERPNext ne sont pas declares dans la configuration actuelle.

## 17. Risques eventuels

- Activation future d'un moteur reseau sans prise en compte des probes kubelet ou d'une exception manquante.
- Apparition d'une dependance externe ERPNext non documentee dans les manifests actuels.
- Besoin de revisiter les selectors si les labels des Deployments changent.

## 18. Rollback

Le rollback consiste a retirer les NetworkPolicies du chart Helm, puis a resynchroniser Argo CD. Comme les policies sont gerees par GitOps, le retour en arriere reste simple et traceable via Git.