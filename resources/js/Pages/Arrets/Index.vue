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
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Gestion des Arrêts</h4>
                    <div class="quick-link-wrapper w-100 d-md-flex flex-md-wrap">
                        <ul class="quick-links ml-auto">
                            <li><Link :href="route('dashboard')">Tableau de bord</Link></li>
                            <li>Arrêts</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filtres -->
        <div class="row mb-3">
            <div class="col-md-4">
                <div class="form-group">
                    <label>Ligne</label>
                    <select v-model="filters.ligne_id" class="form-control">
                        <option value="">Toutes les lignes</option>
                        <option v-for="ligne in lignes" :key="ligne.id" :value="ligne.id">
                            {{ ligne.nom }}
                        </option>
                    </select>
                </div>
            </div>
            <div class="col-md-4">
                <div class="form-group">
                    <label>Recherche</label>
                    <input
                        v-model="filters.search"
                        type="text"
                        class="form-control"
                        placeholder="Rechercher par gare..."
                    />
                </div>
            </div>
        </div>

        <!-- Tableau -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="card-title mb-0">Liste des Arrêts</h4>
                            <Link :href="route('arret.create')" class="btn btn-primary btn-icon-text">
                                <Plus size="16" class="me-1" />
                                Nouvel Arrêt
                            </Link>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Ligne</th>
                                        <th>Gare</th>
                                        <th>Distance (km)</th>
                                        <th>Ordre</th>
                                        <th>Vente en train</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(arret, index) in arrets.data" :key="arret.id">
                                        <td>{{ arrets.from + index }}</td>
                                        <td>{{ arret.ligne.nom }}</td>
                                        <td>{{ arret.gare.nom }}</td>
                                        <td>{{ arret.distance_depart }} km</td>
                                        <td>{{ arret.ordre }}</td>
                                        <td>
                                            <span :class="arret.vente_chef_train ? 'text-success' : 'text-danger'">
                                                {{ arret.vente_chef_train ? 'Oui' : 'Non' }}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group btn-group-sm">
                                                <button @click="editArret(arret.id)" class="btn btn-warning">
                                                    <Pencil size="14" />
                                                </button>
                                                <button @click="deleteArret(arret.id)" class="btn btn-danger">
                                                    <Trash size="14" />
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr v-if="arrets.data.length === 0">
                                        <td colspan="7" class="text-center py-4 text-muted">
                                            Aucun arrêt trouvé
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <p class="text-muted">
                                    Affichage de {{ arrets.from }} à {{ arrets.to }} sur {{ arrets.total }} arrêts
                                </p>
                            </div>
                            <div class="col-md-6">
                                <nav class="float-end">
                                    <ul class="pagination">
                                        <li v-for="link in arrets.links" :key="link.label"
                                            class="page-item" :class="{ active: link.active, disabled: !link.url }">
                                            <Link v-if="link.url" :href="link.url" class="page-link" v-html="link.label" />
                                            <span v-else class="page-link" v-html="link.label"></span>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
/* Style général */
.users-header {
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

.users-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 1.5rem;
}

/* Carte principale */
.users-card {
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    border: 1px solid #e1e5eb;
    overflow: hidden;
    margin-bottom: 2rem;
}

/* En-tête du tableau */
.table-header {
    padding: 1.25rem 1.5rem;
    border-bottom: 1px solid #f0f0f0;
    background-color: #f9fafb;
    display: flex;
    justify-content: flex-end;
    align-items: center;
    flex-wrap: wrap;
    gap: 1rem;
}

/* Barre de recherche */
.search-box {
    position: relative;
    min-width: 250px;
}

.search-input {
    width: 100%;
    padding: 0.5rem 1rem 0.5rem 2.5rem;
    border: 1px solid #e1e5eb;
    border-radius: 6px;
    font-size: 0.9rem;
    transition: all 0.2s;
}

.search-input:focus {
    border-color: #4a6cf7;
    box-shadow: 0 0 0 0.2rem rgba(74, 108, 247, 0.25);
    outline: none;
}

.search-btn {
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 2.5rem;
    background: transparent;
    border: none;
    color: #6c757d;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* Tableau */
.users-table {
    width: 100%;
    border-collapse: collapse;
}

.users-table thead {
    background-color: #f8f9fa;
}

.users-table th {
    padding: 1rem 1.25rem;
    text-align: left;
    font-weight: 600;
    color: #495057;
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    border-bottom: 1px solid #e1e5eb;
}

.users-table td {
    padding: 1rem 1.25rem;
    border-bottom: 1px solid #f0f0f0;
    vertical-align: middle;
}

.users-table tr:last-child td {
    border-bottom: none;
}

.users-table tr:hover td {
    background-color: #f9fafb;
}

/* Colonnes spécifiques */
.column-id {
    width: 60px;
    color: #6c757d;
    font-weight: 500;
}

.column-name {
    font-weight: 500;
}

/* Badges de statut */
.status-badge {
    padding: 0.25rem 0.75rem;
    border-radius: 50px;
    font-size: 0.8rem;
    font-weight: 500;
    display: inline-block;
}

.status-badge.active {
    background-color: #e6f7ff;
    color: #1890ff;
}

.status-badge.inactive {
    background-color: #fff2f0;
    color: #ff4d4f;
}

/* Boutons d'action */
.action-buttons {
    display: flex;
    gap: 0.5rem;
}

.btn-action {
    width: 32px;
    height: 32px;
    border-radius: 6px;
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
    border-radius: 4px;
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

/* Boutons */
.btn-create-user {
    background-color: #4a6cf7;
    border: none;
    color: white;
    padding: 0.5rem 1.25rem;
    border-radius: 6px;
    font-size: 0.95rem;
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.btn-create-user:hover {
    background-color: #3a5ce4;
    transform: translateY(-1px);
}

/* Responsive */
@media (max-width: 768px) {
    .header-title-wrapper {
        flex-direction: column;
        align-items: flex-start;
        gap: 1rem;
    }

    .table-header {
        flex-direction: column;
        align-items: stretch;
    }

    .search-box {
        width: 100%;
    }

    .table-footer {
        flex-direction: column;
    }

    .users-table {
        display: block;
        overflow-x: auto;
    }
}
</style>
