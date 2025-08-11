<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Pencil, Trash, Plus } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    arrets: Object,
    filters: Object,
    flash: Object,
    lignes: Array, // Ajouté pour le filtre par ligne
});

// Filtres réactifs
const filters = reactive({
    search: props.filters.search || "",
    ligne_id: props.filters.ligne_id || "",
});

// Watch pour les filtres
watch(
    () => filters,
    (newFilters) => {
        router.get(
            route("arret.index"),
            { search: newFilters.search, ligne_id: newFilters.ligne_id },
            { preserveState: true, replace: true }
        );
    },
    { deep: true }
);

// Affichage des messages flash
if (props.flash?.success) {
    Swal.fire("Succès", props.flash.success, "success");
}

// Navigation
const editArret = (id) => router.visit(route("arret.edit", id));

// Suppression avec confirmation
const deleteArret = (id) => {
    Swal.fire({
        title: "Confirmation",
        text: "Voulez-vous vraiment supprimer cet arrêt ?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Oui, supprimer",
        cancelButtonText: "Annuler",
    }).then((result) => {
        if (result.isConfirmed) {
            router.delete(route("arret.destroy", id), {
                onSuccess: () => {
                    Swal.fire("Supprimé", "L'arrêt a été supprimé.", "success");
                },
                onError: () => {
                    Swal.fire("Erreur", "La suppression a échoué.", "error");
                },
            });
        }
    });
};
</script>

<template>
    <AppLayout>
        <!-- En-tête -->
        <div class="sales-header">
            <div class="header-content">
                <div class="header-title-wrapper">
                    <h1 class="page-title">Gestion des Arrêts</h1>
                    <Link :href="route('create')" class="btn-create">
                        <Plus size="16" class="me-1" />
                        Nouveaux Arrêts
                    </Link>
                </div>
                <div class="breadcrumb-wrapper">
                    <ul class="breadcrumb">
                        <li class="breadcrumb-item">
                            <Link :href="route('dashboard')"
                                >Tableau de bord</Link
                            >
                            <span class="breadcrumb-divider">/</span>
                        </li>
                        <li class="breadcrumb-item active">Arrêts</li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="sales-container">
            <!-- Filtres améliorés -->
            <div class="filters-container">
                <div class="filter-group">
                    <label class="filter-label">Filtrer par lignes</label>
                    <select
                        v-model="filters.voyage_id"
                        class="filter-select"
                        aria-label="Filtrer par lignes"
                    >
                        <option value="" selected>Toutes les lignes</option>
                        <option
                            v-for="ligne in lignes"
                            :key="ligne.id"
                            :value="ligne.id"
                        >
                            {{ ligne.nom }}
                        </option>
                    </select>
                </div>

                <div class="filter-group search-group">
                    <label class="filter-label">Rechercher</label>
                    <div class="search-box">
                        <input
                            type="text"
                            v-model="filters.search"
                            placeholder="Rechercher par gares..."
                            class="search-input"
                            aria-label="Rechercher des arrets"
                            @keyup.enter="
                                router.get(route('arret.index'), filters)
                            "
                        />
                        <button
                            class="search-btn"
                            @click="router.get(route('arret.index'), filters)"
                            aria-label="Lancer la recherche"
                        >
                            <i class="mdi mdi-magnify"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Carte du tableau -->
            <div class="sales-card">
                <div class="table-header">
                    <h3 class="table-title">Liste des Arrêts</h3>
                    <Link
                        :href="route('create')"
                        class="btn-create-sm"
                        aria-label="Créer une nouvelle vente"
                    >
                        <Plus size="16" class="me-1" />
                        Nouvel Arret
                    </Link>
                </div>
                <div class="table-responsive">
                    <table class="sales-table" aria-label="Liste des arrets">
                        <thead>
                            <tr>
                                <th class="column-id">#</th>
                                <th>Ligne</th>
                                <th>Gare</th>
                                <th>Distance (km)</th>
                                <th>Ordre</th>
                                <th>Vente en train</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr
                                v-for="(arret, index) in arrets.data"
                                :key="arret.id"
                            >
                                <td>{{ arrets.from + index }}</td>
                                <td>{{ arret.ligne.nom }}</td>
                                <td>{{ arret.gare.nom }}</td>
                                <td>{{ arret.distance_depart }} km</td>
                                <td>{{ arret.ordre }}</td>
                                <td>
                                    <span
                                        :class="
                                            arret.vente_chef_train
                                                ? 'text-success'
                                                : 'text-danger'
                                        "
                                    >
                                        {{
                                            arret.vente_chef_train
                                                ? "Oui"
                                                : "Non"
                                        }}
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <button
                                            @click="editArret(arret.id)"
                                            class="btn-action btn-edit"
                                        >
                                            <Pencil size="14" />
                                        </button>
                                        <button
                                            @click="deleteArret(arret.id)"
                                            class="btn-action btn-delete"
                                        >
                                            <Trash size="14" />
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr v-if="arrets.data.length === 0">
                                <td
                                    colspan="7"
                                    class="text-center py-4 text-muted"
                                >
                                    Aucun arrêt trouvé
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="table-footer">
                    <div class="pagination-info">
                        <p class="text-muted">
                            Affichage de {{ arrets.from }} à {{ arrets.to }} sur
                            {{ arrets.total }} arrets
                        </p>
                    </div>
                    <div class="pagination-controls">
                        <nav class="float-end">
                            <ul class="pagination">
                                <li
                                    v-for="link in arrets.links"
                                    :key="link.label"
                                    class="page-item"
                                    :class="{
                                        active: link.active,
                                        disabled: !link.url,
                                    }"
                                >
                                    <Link
                                        v-if="link.url"
                                        :href="link.url"
                                        class="page-link"
                                        v-html="link.label"
                                    />
                                    <span
                                        v-else
                                        class="page-link"
                                        v-html="link.label"
                                    ></span>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
                <!-- Fin pagination -->
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
/* Style général */
.sales-header {
    background-color: #f8f9fa;
    padding: 1.5rem 2rem;
    border-bottom: 1px solid #e1e5eb;
    margin-bottom: 1.5rem;
}

.header-content {
    max-width: 1400px;
    margin: 0 auto;
}

.header-title-wrapper {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
}

.page-title {
    font-size: 1.8rem;
    font-weight: 600;
    color: #2c3e50;
    margin: 0;
}

.breadcrumb-wrapper {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 1rem;
}

.breadcrumb {
    display: flex;
    align-items: center;
    padding: 0;
    margin: 0;
    list-style: none;
    font-size: 0.9rem;
}

.breadcrumb-item {
    color: #6c757d;
    text-decoration: none;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.breadcrumb-item:hover {
    color: #4a6cf7;
}

.breadcrumb-item.active {
    color: #4a6cf7;
    font-weight: 500;
}

.breadcrumb-divider {
    color: #adb5bd;
    margin: 0 0.5rem;
}

.sales-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 1.5rem;
}

/* Filtres */
.filters-container {
    display: flex;
    gap: 1.5rem;
    margin-bottom: 1.5rem;
    flex-wrap: wrap;
}

.filter-group {
    flex: 1;
    min-width: 250px;
}

.filter-label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
    color: #495057;
    font-size: 0.9rem;
}

.filter-select {
    width: 100%;
    padding: 0.75rem 1rem;
    border: 1px solid #e1e5eb;
    border-radius: 8px;
    font-size: 1rem;
    transition: all 0.2s;
    background-color: white;
    appearance: none;
    background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
    background-repeat: no-repeat;
    background-position: right 1rem center;
    background-size: 1em;
}

.filter-select:focus {
    border-color: #4a6cf7;
    box-shadow: 0 0 0 0.2rem rgba(74, 108, 247, 0.15);
    outline: none;
}

.search-group {
    flex: 2;
}

.search-box {
    position: relative;
}

.search-input {
    width: 100%;
    padding: 0.75rem 1rem 0.75rem 3rem;
    border: 1px solid #e1e5eb;
    border-radius: 8px;
    font-size: 1rem;
    transition: all 0.2s;
}

.search-input:focus {
    border-color: #4a6cf7;
    box-shadow: 0 0 0 0.2rem rgba(74, 108, 247, 0.15);
    outline: none;
}

.search-btn {
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 3rem;
    background: transparent;
    border: none;
    color: #6c757d;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* Carte du tableau */
.sales-card {
    background-color: white;
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    border: 1px solid #e1e5eb;
    overflow: hidden;
    margin-bottom: 2rem;
}

.table-header {
    padding: 1.5rem;
    border-bottom: 1px solid #f0f0f0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 1rem;
}

.table-title {
    font-size: 1.2rem;
    font-weight: 600;
    color: #2c3e50;
    margin: 0;
}

/* Boutons */
.btn-create,
.btn-create-sm {
    background-color: #4a6cf7;
    border: none;
    color: white;
    padding: 0.5rem 1.25rem;
    border-radius: 8px;
    font-size: 0.95rem;
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    text-decoration: none;
}

.btn-create-sm {
    padding: 0.4rem 1rem;
    font-size: 0.9rem;
}

.btn-create:hover,
.btn-create-sm:hover {
    background-color: #3a5ce4;
    transform: translateY(-1px);
}

/* Tableau */
.sales-table {
    width: 100%;
    border-collapse: collapse;
}

.sales-table thead {
    background-color: #f8f9fa;
}

.sales-table th {
    padding: 1rem 1.25rem;
    text-align: left;
    font-weight: 600;
    color: #495057;
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    border-bottom: 1px solid #e1e5eb;
}

.sales-table th.text-center {
    text-align: center;
}

.sales-table th.text-end {
    text-align: right;
}

.sales-table td {
    padding: 1rem 1.25rem;
    border-bottom: 1px solid #f0f0f0;
    vertical-align: middle;
}

.sales-table td.text-center {
    text-align: center;
}

.sales-table td.text-end {
    text-align: right;
}

.sales-table tr:last-child td {
    border-bottom: none;
}

.sales-table tr:hover td {
    background-color: #f9fafb;
}

/* Colonnes spécifiques */
.column-id {
    width: 60px;
    color: #6c757d;
    font-weight: 500;
    text-align: center;
}

.client-name {
    font-weight: 500;
    color: #2c3e50;
}

.voyage-info {
    min-width: 200px;
}

.voyage-name {
    font-weight: 500;
}

.voyage-date {
    font-size: 0.85rem;
    color: #6c757d;
}

.train-number {
    font-family: monospace;
    font-size: 1.1rem;
}

.price,
.quantity,
.weight {
    font-family: monospace;
    font-weight: 500;
}

/* Badges de statut */
.status-badge {
    padding: 0.35rem 0.75rem;
    border-radius: 50px;
    font-size: 0.8rem;
    font-weight: 500;
    display: inline-block;
}

.status-badge.yes {
    background-color: #e6f7ff;
    color: #1890ff;
}

.status-badge.no {
    background-color: #fff2f0;
    color: #ff4d4f;
}

/* Boutons d'action */
.action-buttons {
    display: flex;
    justify-content: center;
    gap: 0.5rem;
}

.btn-action {
    width: 32px;
    height: 32px;
    border-radius: 8px;
    border: none;
    background-color: transparent;
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
}

.btn-action:hover {
    transform: scale(1.1);
}

.btn-view {
    color: #4a6cf7;
    background-color: rgba(74, 108, 247, 0.1);
}

.btn-view:hover {
    background-color: rgba(74, 108, 247, 0.2);
}

.btn-edit {
    color: #faad14;
    background-color: rgba(250, 173, 20, 0.1);
}

.btn-edit:hover {
    background-color: rgba(250, 173, 20, 0.2);
}

.btn-delete {
    color: #ff4d4f;
    background-color: rgba(255, 77, 79, 0.1);
}

.btn-delete:hover {
    background-color: rgba(255, 77, 79, 0.2);
}

/* Message aucun résultat */
.no-results {
    text-align: center;
    padding: 3rem;
    color: #6c757d;
    font-size: 1rem;
}

.no-results i {
    font-size: 1.5rem;
    margin-bottom: 0.5rem;
    display: block;
    color: #adb5bd;
}

/* Pied de tableau */
.table-footer {
    padding: 1.25rem 1.5rem;
    border-top: 1px solid #f0f0f0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 1rem;
}

.pagination-info {
    font-size: 0.9rem;
    color: #6c757d;
}

.pagination-controls {
    display: flex;
    gap: 0.5rem;
}

.pagination-link {
    padding: 0.5rem 0.75rem;
    border-radius: 6px;
    border: 1px solid #e1e5eb;
    color: #495057;
    text-decoration: none;
    font-size: 0.9rem;
    min-width: 36px;
    text-align: center;
    transition: all 0.2s;
}

.pagination-link:hover:not(.active):not(.disabled) {
    background-color: #f8f9fa;
    border-color: #dae0e5;
}

.pagination-link.active {
    background-color: #4a6cf7;
    border-color: #4a6cf7;
    color: white;
}

.pagination-link.disabled {
    color: #adb5bd;
    cursor: not-allowed;
    opacity: 0.7;
}

.pagination-link.prev-next {
    font-weight: bold;
}

/* Responsive */
@media (max-width: 992px) {
    .filters-container {
        flex-direction: column;
        gap: 1rem;
    }

    .filter-group,
    .search-group {
        min-width: 100%;
    }

    .sales-table {
        display: block;
        overflow-x: auto;
        white-space: nowrap;
    }

    .header-title-wrapper {
        flex-direction: column;
        align-items: flex-start;
        gap: 1rem;
    }

    .table-footer {
        flex-direction: column;
    }
}

@media (max-width: 768px) {
    .action-buttons {
        flex-direction: column;
        gap: 0.5rem;
    }

    .btn-action {
        width: 100%;
    }
}
</style>
