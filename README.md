# 🎯 Projet de gestion de billets de train avec Laravel, Vue 3 & Inertia.js

Ce projet est une application de gestion de ventes de billets de train pour une entreprise ferroviaire. Il inclut un système complet de :

- **Création et gestion des trains, wagons, et places**
- **Planification de voyages classiques et récurrents**
- **Attribution automatique de places disponibles lors d’une vente**
- **Gestion des bagages, rapports, colis et paramètres tarifaires**

---

## 📐 Structure des données

### Trains & Wagons

- Chaque **train** peut avoir plusieurs **wagons**
- Chaque **wagon** possède un nombre fixe de **places**
- Les **places** sont attribuées automatiquement lors de la vente

### Voyages

- Un **voyage** est lié à un **train**
- Le train est sélectionné automatiquement lors de la création du voyage
- Le voyage peut être **classique** ou **récurrent**

---

## 🧠 Fonctionnement de la vente

Lors de la création d'une vente (`store` dans `VenteController`) :
1. L'utilisateur choisit un **voyage**
2. Le système déduit automatiquement le **train** lié à ce voyage
3. Une place libre est recherchée dans les wagons de ce train
4. Si une place est disponible :
   - Elle est attribuée automatiquement
   - La vente est créée
5. Si aucune place n’est disponible :
   - Une erreur est retournée avec **SweetAlert** : _« Aucune place disponible dans ce train »_

---

## ⚠️ Points importants

- Le champ `train_id` est **supprimé du formulaire de vente**, car le train est **déjà défini dans le voyage**
- Chaque vente est liée à une **place unique**
- La place devient **disponible à nouveau** si la vente est supprimée
- Une vérification est faite pour éviter les doublons de places attribuées
- Le système prend aussi en charge :
  - Le poids et tarif des bagages
  - Les jours de circulation pour les voyages récurrents
  - Les paramètres tarifaires des colis

---

## ✅ Prochaine étape (TODO)

- Côté Vue.js, gérer l’alerte avec `SweetAlert2` si l’attribution échoue
- Ajouter une vue dynamique de disponibilité des places lors du choix du voyage
- Améliorer les performances (lazy load, cache, indexes sur les tables critiques)

---

## 📁 Technologies utilisées

- **Laravel 11+** (Eloquent, Migrations)
- **Inertia.js**
- **Vue 3 (Composition API)**
- **PostgreSQL**
- **SweetAlert2** pour les alertes utilisateur
