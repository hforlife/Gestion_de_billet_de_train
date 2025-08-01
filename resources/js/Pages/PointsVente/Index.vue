<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Plus, Pencil, Trash, Search } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    pointsVente: Object,
    filters: Object,
    flash: Object,
});

const filters = reactive({
    search: props.filters.search || "",
});

watch(
    () => filters.search,
    (search) => {
        router.get(
            route("points-vente.index"),
            { search },
            {
                preserveState: true,
                replace: true,
            }
        );
    }
);

const deletePoint = (id) => {
    Swal.fire({
        title: "Confirmer la suppression",
        text: "Êtes-vous sûr de vouloir supprimer ce point de vente ?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Oui, supprimer",
        cancelButtonText: "Annuler",
    }).then((result) => {
        if (result.isConfirmed) {
            router.delete(route("points-vente.destroy", id));
        }
    });
};
</script>

<template>
    <AppLayout>
        <!-- En-tête de page amélioré -->
        <div class="users-header">
            <div class="header-content">
                <div class="header-title-wrapper">
                    <h1 class="page-title">Points de Vente</h1>
                    <Link
                        :href="route('points-vente.create')"
                        class="btn-create-user"
                    >
                        <Plus size="16" class="me-1" />
                        Nouveau point de vente
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
                        <li class="breadcrumb-item active">Points de vente</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Contenu principal -->
        <div class="users-container">
            <div class="users-card">
                <!-- Barre d'outils avec recherche -->
                <div class="table-header">
                    <div class="search-box">
                        <input
                            type="text"
                            v-model="filters.search"
                            placeholder="Rechercher par gare..."
                            class="search-input"
                        />
                        <button class="search-btn">
                            <Search size="16" />
                        </button>
                    </div>
                </div>

                <!-- Tableau -->
                <div class="table-responsive">
                    <table class="users-table">
                        <thead>
                            <tr>
                                <th class="column-id">#</th>
                                <th>Gare</th>
                                <th>Type de gare</th>
                                <th>Type de point</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr
                                v-for="(point, index) in pointsVente.data"
                                :key="point.id"
                            >
                                <td class="column-id">{{ index + 1 }}</td>
                                <td class="column-name">
                                    {{ point.gare_nom }}
                                </td>
                                <td>{{ point.gare_type }}</td>
                                <td class="text-capitalize">
                                    {{ point.type }}
                                </td>
                                <td>
                                    <span
                                        :class="{
                                            'status-badge active':
                                                point.actif === 'Actif',
                                            'status-badge inactive':
                                                point.actif === 'Inactif',
                                        }"
                                    >
                                        {{ point.actif }}
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <Link
                                            :href="
                                                route(
                                                    'points-vente.edit',
                                                    point.id
                                                )
                                            "
                                            class="btn-action btn-edit"
                                            title="Modifier"
                                        >
                                            <Pencil size="16" />
                                        </Link>
                                        <button
                                            @click="deletePoint(point.id)"
                                            class="btn-action btn-delete"
                                            title="Supprimer"
                                        >
                                            <Trash size="16" />
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr v-if="pointsVente.data.length === 0">
                                <td colspan="6" class="no-results">
                                    <i>Aucun point de vente trouvé</i>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="table-footer">
                    <div class="pagination-info">
                        Affichage de {{ pointsVente.from }} à
                        {{ pointsVente.to }} sur {{ pointsVente.total }} points
                    </div>
                    <div class="pagination-controls">
                        <!-- <Link
                            v-for="link in pointsVente.links"
                            :key="link.label"
                            :href="link.url"
                            class="pagination-link"
                            :class="{
                                'active': link.active,
                                'disabled': !link.url,
                                'prev-next': link.label.includes('Previous') || link.label.includes('Next')
                            }"
                            v-html="link.label"
                        /> -->
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
