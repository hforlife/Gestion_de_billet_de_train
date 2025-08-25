<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Pencil, Trash, Plus } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    voyages: Object,
    filters: Object,
    flash: Object,
    sort: String,
});

// Filtres réactifs
const filters = reactive({
    search: props.filters.search || "",
    date_depart: props.filters.date_depart || "",
    statut: props.filters.statut || "",
});

// Surveillance des filtres pour mise à jour automatique
watch(
    () => ({ ...filters }),
    (newFilters) => {
        router.get(route("voyage.index"), newFilters, {
            preserveState: true,
            replace: true,
        });
    },
    { deep: true }
);

// Tri
const changeSort = () => {
    router.get(route("voyage.index"), {
        ...filters,
        sort: props.sort === "asc" ? "desc" : "asc",
    });
};

// Actions
const editVoyage = (id) => router.visit(route("voyage.edit", id));

const deleteVoyage = (id) => {
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
            router.delete(route("voyage.destroy", id), {
                onSuccess: () => {
                    Swal.fire(
                        "Supprimé !",
                        "Le voyage a été supprimé avec succès.",
                        "success"
                    );
                },
            });
        }
    });
};

const formatDate = (date) => {
    return new Date(date).toLocaleString("fr-FR", {
        day: "2-digit",
        month: "2-digit",
        year: "numeric",
        hour: "2-digit",
        minute: "2-digit",
    });
};

const getStatusClass = (statut) => statut.replace("é", "e").replace(" ", "_");

const formatStatus = (statut) =>
    statut.charAt(0).toUpperCase() + statut.slice(1).replace("_", " ");
</script>

<template>
    <AppLayout>
        <!-- En-tête modernisé -->
        <div class="voyage-header">
            <div class="header-content">
                <div class="header-title-wrapper">
                    <h1 class="page-title">Gestion des Voyages</h1>
                    <Link :href="route('voyage.create')" class="btn-create">
                        <Plus size="16" class="me-1" />
                        Nouveau Voyage
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
                        <li class="breadcrumb-item active">Voyages</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Contenu principal -->
        <div class="voyage-container">
            <!-- Barre de recherche améliorée -->
            <div class="search-container">
                <div class="search-box">
                    <input
                        type="text"
                        v-model="filters.search"
                        placeholder="Rechercher par nom, train ou ligne..."
                        class="search-input"
                        @keyup.enter="getResults"
                    />
                    <button class="search-btn" @click="getResults">
                        <i class="mdi mdi-magnify"></i>
                    </button>
                </div>
            </div>

            <!-- Carte du tableau -->
            <div class="voyage-card">
                <div class="table-header">
                    <h3 class="table-title">Liste des voyages</h3>
                    <Link :href="route('voyage.create')" class="btn-create-sm">
                        <Plus size="16" class="me-1" />
                        Nouveau Voyage
                    </Link>
                </div>

                <!-- Tableau amélioré -->
                <div class="table-responsive">
                    <div class="table-filters">
                        <button @click="changeSort" class="filter-btn">
                            <span>Départ</span>
                            <i
                                v-if="sort === 'asc'"
                                class="mdi mdi-arrow-up"
                            ></i>
                            <i v-else class="mdi mdi-arrow-down"></i>
                        </button>

                        <input
                            type="date"
                            v-model="filters.date_depart"
                            class="filter-input"
                            placeholder="Filtrer par date"
                            @change="getResults"
                        />

                        <select
                            v-model="filters.statut"
                            class="filter-select"
                            @change="getResults"
                        >
                            <option value="">Tous les statuts</option>
                            <option value="programme">Programmé</option>
                            <option value="en-cours">En cours</option>
                            <option value="termine">Terminé</option>
                            <option value="annule">Annulé</option>
                        </select>
                    </div>

                    <table class="voyage-table">
                        <thead>
                            <tr>
                                <th class="column-id">#</th>
                                <th>Nom</th>
                                <th>Train</th>
                                <th>Ligne</th>
                                <th>Départ</th>
                                <th>Arrivée</th>
                                <th>Statut</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr
                                v-for="(voyage, index) in voyages.data"
                                :key="voyage.id"
                            >
                                <td class="column-id">{{ index + 1 }}</td>
                                <td class="voyage-name">{{ voyage.nom }}</td>
                                <td class="train-number">
                                    {{ voyage.train.numero }}
                                </td>
                                <td class="line-name">
                                    {{ voyage.ligne.nom }}
                                </td>
                                <td class="departure-time">
                                    <div class="date">
                                        {{ formatDate(voyage.date_depart) }}
                                    </div>
                                    <!-- <div class="time">{{ formatTime(voyage.date_depart) }}</div> -->
                                </td>
                                <td class="arrival-time">
                                    <div class="date">
                                        {{ formatDate(voyage.date_arrivee) }}
                                    </div>
                                    <!-- <div class="time">{{ formatTime(voyage.date_arrivee) }}</div> -->
                                </td>
                                <td>
                                    <span
                                        :class="`status-badge ${getStatusClass(
                                            voyage.statut
                                        )}`"
                                    >
                                        {{ formatStatus(voyage.statut) }}
                                    </span>
                                </td>
                                <td class="text-center">
                                    <div class="action-buttons">
                                        <button
                                            @click="editVoyage(voyage.id)"
                                            class="btn-action btn-edit"
                                            title="Modifier"
                                        >
                                            <Pencil size="16" />
                                        </button>
                                        <button
                                            @click="deleteVoyage(voyage.id)"
                                            class="btn-action btn-delete"
                                            title="Supprimer"
                                        >
                                            <Trash size="16" />
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr v-if="voyages.data.length === 0">
                                <td colspan="8" class="no-results">
                                    <i class="mdi mdi-train-variant-off"></i>
                                    Aucun voyage trouvé
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- 📄 Pagination -->
                <div class="table-footer">
                    <div class="pagination-info">
                        <p class="text-muted">
                            Affichage de {{ voyages.from }} à
                            {{ voyages.to }} sur {{ voyages.total }} voyages
                        </p>
                    </div>

                    <div class="pagination-controls">
                        <nav class="float-end">
                            <ul class="pagination">
                                <li
                                    v-for="link in voyages.links"
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
                <!-- 📄 Pagination -->
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
.table-filters {
    display: flex;
    flex-wrap: wrap;
    gap: 0.75rem;
    align-items: center;
    margin-bottom: 1rem;
}

.filter-btn {
    display: flex;
    align-items: center;
    gap: 0.3rem;
    padding: 0.5rem 1rem;
    background-color: #4a6cf7;
    color: white;
    border: none;
    border-radius: 8px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
}

.filter-btn i {
    font-size: 0.9rem;
}

.filter-btn:hover {
    background-color: #3a5ce4;
    transform: translateY(-1px);
}

.filter-input,
.filter-select {
    padding: 0.45rem 0.75rem;
    border: 1px solid #e1e5eb;
    border-radius: 8px;
    font-size: 0.9rem;
    min-width: 180px;
    transition: all 0.2s;
}

.filter-input:focus,
.filter-select:focus {
    border-color: #4a6cf7;
    box-shadow: 0 0 0 0.15rem rgba(74, 108, 247, 0.25);
    outline: none;
}

/* Style général */
.voyage-header {
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

.voyage-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 1.5rem;
}

/* Barre de recherche */
.search-container {
    margin-bottom: 1.5rem;
}

.search-box {
    position: relative;
    max-width: 600px;
}

.search-input {
    width: 100%;
    padding: 0.75rem 1rem 0.75rem 3rem;
    border: 1px solid #e1e5eb;
    border-radius: 8px;
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
.voyage-card {
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
.voyage-table {
    width: 100%;
    border-collapse: collapse;
}

.voyage-table thead {
    background-color: #f8f9fa;
}

.voyage-table th {
    padding: 1rem 1.25rem;
    text-align: left;
    font-weight: 600;
    color: #495057;
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    border-bottom: 1px solid #e1e5eb;
}

.voyage-table th.text-center {
    text-align: center;
}

.voyage-table td {
    padding: 1rem 1.25rem;
    border-bottom: 1px solid #f0f0f0;
    vertical-align: middle;
}

.voyage-table td.text-center {
    text-align: center;
}

.voyage-table tr:last-child td {
    border-bottom: none;
}

.voyage-table tr:hover td {
    background-color: #f9fafb;
}

/* Colonnes spécifiques */
.column-id {
    width: 60px;
    color: #6c757d;
    font-weight: 500;
    text-align: center;
}

.voyage-name {
    font-weight: 500;
    color: #2c3e50;
}

.train-number {
    font-family: monospace;
    font-size: 1.1rem;
}

.line-name {
    color: #6c757d;
}

.departure-time,
.arrival-time {
    min-width: 120px;
}

.departure-time .date,
.arrival-time .date {
    font-weight: 500;
}

.departure-time .time,
.arrival-time .time {
    font-size: 0.85rem;
    color: #6c757d;
}

/* Badges de statut */
.status-badge {
    padding: 0.35rem 0.75rem;
    border-radius: 50px;
    font-size: 0.8rem;
    font-weight: 500;
    display: inline-block;
}

.status-badge.programme {
    background-color: #e6f7ff;
    color: #1890ff;
}

.status-badge.en-cours {
    background-color: #f6ffed;
    color: #52c41a;
}

.status-badge.termine {
    background-color: #fff2f0;
    color: #ff4d4f;
}

.status-badge.annule {
    background-color: #fffbe6;
    color: #faad14;
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
    .voyage-table {
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
