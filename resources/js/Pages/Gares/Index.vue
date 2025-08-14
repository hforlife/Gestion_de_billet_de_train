<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Pencil, Trash, Eye, Plus } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    gares: Object, // paginated data
    filters: Object, // { search: '...' }
    flash: Object, // flash messages
});

// 🔍 Filtres réactifs
const filters = reactive({
    search: props.filters.search || "",
});

// 🔍 Watch pour mise à jour auto lors de la recherche
watch(
    () => filters.search,
    (newValue) => {
        router.get(
            route("gare.index"),
            { search: newValue },
            {
                preserveState: true,
                replace: true,
            }
        );
    }
);

// ✏️ Redirection vers la page d’édition
const editGare = (id) => {
    router.visit(route("gare.edit", id));
};

// 🗑️ Suppression avec confirmation
const deleteGare = (id) => {
    Swal.fire({
        title: "Êtes-vous sûr ?",
        text: "Cette action est irréversible !",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Oui, supprimer !",
        cancelButtonText: "Annuler",
    }).then((result) => {
        if (result.isConfirmed) {
            router.delete(route("gare.destroy", id), {
                onSuccess: () => {
                    Swal.fire(
                        "Supprimé !",
                        "La gare a été supprimée avec succès.",
                        "success"
                    );
                },
            });
        }
    });
};
</script>

<template>
    <AppLayout>
        <!-- En-tête modernisé -->
        <div class="page-header-container">
            <div class="header-content">
                <div class="header-title-wrapper">
                    <h1 class="page-title">Gestion des Gares</h1>
                    <Link :href="route('gare.create')" class="btn-create">
                        <Plus size="16" class="me-1" />
                        Nouvelle Gare
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
                        <li class="breadcrumb-item active">Gares</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Contenu principal -->
        <div class="page-container">
            <!-- Barre de recherche améliorée -->
            <div class="search-container">
                <div class="search-box">
                    <input
                        type="text"
                        v-model="filters.search"
                        placeholder="Rechercher par nom, adresse ou type..."
                        class="search-input"
                        @keyup.enter="getResults"
                    />
                    <button class="search-btn" @click="getResults">
                        <i class="mdi mdi-magnify"></i>
                    </button>
                </div>
            </div>

            <!-- Carte du tableau -->
            <div class="data-card">
                <div class="table-header">
                    <h3 class="table-title">Liste des gares</h3>
                    <Link
                        :href="route('gare.create')"
                        class="btn-create-sm"
                        aria-label="Créer une nouvelle gare"
                    >
                        <Plus size="16" class="me-1" />
                        Nouvelle Gare
                    </Link>
                </div>

                <div class="table-container">
                    <!-- Tableau amélioré -->
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th class="column-id">#</th>
                                    <th>Nom</th>
                                    <th>Adresse</th>
                                    <th>Type</th>
                                    <th class="text-center">Internet</th>
                                    <th class="text-center">Électricité</th>
                                    <th class="text-center">Guichets</th>
                                    <th class="text-center">Contrôle Bagage</th>
                                    <th class="text-center">Distance (km)</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(gare, index) in gares.data"
                                    :key="gare.id"
                                >
                                    <td class="column-id">{{ index + 1 }}</td>
                                    <td class="gare-name">{{ gare.nom }}</td>
                                    <td class="gare-address">
                                        {{ gare.adresse }}
                                    </td>
                                    <td class="gare-type">{{ gare.type }}</td>
                                    <td class="text-center">
                                        <span
                                            :class="`status-badge ${gare.internet.toLowerCase()}`"
                                        >
                                            {{ gare.internet }}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <span
                                            :class="`status-badge ${gare.electricite.toLowerCase()}`"
                                        >
                                            {{ gare.electricite }}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        {{ gare.nombre_guichets }}
                                    </td>
                                    <td class="text-center">
                                        <span
                                            :class="`status-badge ${gare.controle_bagage.toLowerCase()}`"
                                        >
                                            {{ gare.controle_bagage }}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        {{ gare.distance_km }}
                                    </td>
                                    <td class="text-center">
                                        <div class="action-buttons">
                                            <button
                                                @click="editGare(gare.id)"
                                                class="btn-action btn-edit"
                                                title="Modifier"
                                            >
                                                <Pencil size="16" />
                                            </button>
                                            <button
                                                @click="deleteGare(gare.id)"
                                                class="btn-action btn-delete"
                                                title="Supprimer"
                                            >
                                                <Trash size="16" />
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr v-if="gares.data.length === 0">
                                    <td colspan="10" class="no-results">
                                        <i class="mdi mdi-database-remove"></i>
                                        Aucune gare trouvée
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="table-footer">
                        <div class="pagination-info">
                            <p class="text-muted">
                                Affichage de {{ gares.from }} à
                                {{ gares.to }} sur {{ gares.total }} gares
                            </p>
                        </div>
                        <div class="pagination-controls">
                            <nav class="float-end">
                                <ul class="pagination">
                                    <li
                                        v-for="link in gares.links"
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
        </div>
    </AppLayout>
</template>

<style scoped>
/* Style général */
.page-header-container {
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

.page-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 1.5rem;
}

/* Bouton de création */
.btn-create {
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
    text-decoration: none;
}

.btn-create:hover {
    background-color: #3a5ce4;
    transform: translateY(-1px);
}

/* Barre de recherche */
.search-container {
    margin-bottom: 1.5rem;
}

.search-box {
    position: relative;
    max-width: 500px;
}

.search-input {
    width: 100%;
    padding: 0.75rem 1rem 0.75rem 3rem;
    border: 1px solid #e1e5eb;
    border-radius: 6px;
    font-size: 1rem;
    transition: all 0.2s;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
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
.data-card {
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
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

.table-container {
    padding: 1.5rem;
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
.data-table {
    width: 100%;
    border-collapse: collapse;
}

.data-table thead {
    background-color: #f8f9fa;
}

.data-table th {
    padding: 1rem 1.25rem;
    text-align: left;
    font-weight: 600;
    color: #495057;
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    border-bottom: 1px solid #e1e5eb;
}

.data-table th.text-center {
    text-align: center;
}

.data-table td {
    padding: 1rem 1.25rem;
    border-bottom: 1px solid #f0f0f0;
    vertical-align: middle;
}

.data-table td.text-center {
    text-align: center;
}

.data-table tr:last-child td {
    border-bottom: none;
}

.data-table tr:hover td {
    background-color: #f9fafb;
}

/* Colonnes spécifiques */
.column-id {
    width: 60px;
    color: #6c757d;
    font-weight: 500;
    text-align: center;
}

.gare-name {
    font-weight: 500;
    color: #2c3e50;
}

.gare-address {
    color: #6c757d;
    font-size: 0.9rem;
}

/* Badges de statut */
.status-badge {
    padding: 0.35rem 0.75rem;
    border-radius: 50px;
    font-size: 0.8rem;
    font-weight: 500;
    display: inline-block;
}

.status-badge.oui,
.status-badge.disponible,
.status-badge.actif {
    background-color: #e6f7ff;
    color: #1890ff;
}

.status-badge.non,
.status-badge.indisponible,
.status-badge.inactif {
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
    padding: 1.25rem 0;
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

/* Responsive */
@media (max-width: 992px) {
    .data-table {
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
    .search-box {
        max-width: 100%;
    }

    .action-buttons {
        flex-direction: column;
        gap: 0.5rem;
    }

    .btn-action {
        width: 100%;
    }
}
</style>
