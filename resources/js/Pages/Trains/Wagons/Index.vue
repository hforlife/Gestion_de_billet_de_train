<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Plus, Pencil, Trash } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    wagons: Object,
    filters: Object,
    flash: Object,
});

const filters = reactive({
    search: props.filters.search || "",
});

watch(
    () => filters.search,
    (newValue) => {
        router.get(
            route("wagon.index"),
            { search: newValue },
            { preserveState: true, replace: true }
        );
    }
);

if (props.flash && props.flash.success) {
    Swal.fire("Succès", props.flash.success, "success");
}

const editwagon = (id) => {
    router.visit(route("wagon.edit", id));
};

const deletewagon = (id) => {
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
            router.delete(route("wagon.destroy", id), {
                onSuccess: () => {
                    Swal.fire(
                        "Supprimé !",
                        "Le wagon a été supprimé avec succès.",
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
        <!-- 🧭 Titre -->
        <div class="sales-header">
            <div class="header-content">
                <div class="header-title-wrapper">
                    <h1 class="page-title">Gestion des Wagons</h1>
                    <Link :href="route('train.create')" class="btn-create">
                        <Plus size="16" class="me-1" />
                        Nouveau Wagon
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
                        <li class="breadcrumb-item active">Wagons</li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="sales-container">
            <!-- 🔍 Barre de recherche -->
            <div class="filters-container">
                <div class="filter-group search-group">
                    <label class="filter-label">Rechercher</label>
                    <div class="search-box">
                        <input
                            type="text"
                            v-model="filters.search"
                            placeholder="Rechercher par nom..."
                            class="search-input"
                        />
                        <button
                            class="search-btn"
                            type="button"
                            @click="getResults"
                        >
                            <i class="mdi mdi-magnify"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- 📋 Tableau des wagons -->
            <div class="sales-card">
                <!-- En-tête du tableau -->
                <div class="table-header">
                    <h3 class="table-title">Liste des Wagons</h3>
                    <Link
                        :href="route('wagon.create')"
                        class="btn-create-sm"
                        aria-label="Créer un nouveau wagon"
                    >
                        <Plus size="16" class="me-1" />
                        Nouveau wagon
                    </Link>
                </div>

                <div class="table-responsive">
                    <table class="sales-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Train d'affiliation</th>
                                <th>Classe Voiture</th>
                                <th>Numero du Wagon</th>
                                <th>Nombre de Sièges</th>
                                <th>Sièges Disponibles</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr
                                v-for="(wagon, index) in wagons.data"
                                :key="wagon.id"
                            >
                                <td class="py-1">{{ index + 1 }}</td>
                                <td>{{ wagon.train_numero }}</td>
                                <td>{{ wagon.classe_nom }}</td>
                                <td>{{ wagon.numero_wagon }}</td>
                                <td>{{ wagon.nombre_sieges }}</td>
                                <td>{{ wagon.sieges_disponibles }}</td>
                                <td>
                                    <div class="action-buttons">
                                        <button
                                            @click="editwagon(wagon.id)"
                                            class="btn-action btn-edit"
                                        >
                                            <Pencil size="16" />
                                        </button>
                                        <button
                                            @click="deletewagon(wagon.id)"
                                            class="btn-action btn-delete"
                                        >
                                            <Trash size="16" />
                                        </button>
                                    </div>
                                </td>
                            </tr>

                            <tr v-if="wagons.data.length === 0">
                                <td
                                    colspan="8"
                                    class="text-center py-4 text-muted"
                                >
                                    Aucun wagon trouvée
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- 📄 Pagination -->
                <div class="table-footer">
                    <div class="pagination-info">
                        <p class="text-muted">
                            Affichage de {{ wagons.from }} à {{ wagons.to }} sur
                            {{ wagons.total }} wagons
                        </p>
                    </div>
                    <div class="pagination-controls">
                        <nav class="float-end">
                            <ul class="pagination">
                                <li
                                    v-for="link in wagons.links"
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
                <!-- Fin Pagination -->
            </div>
        </div>
        <!-- Fin Tableau -->
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
