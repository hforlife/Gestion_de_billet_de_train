<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { router, Link } from "@inertiajs/vue3";
import { Pencil, Trash, Eye, Plus } from "lucide-vue-next";
import { reactive, watch, computed } from "vue";
import { useToast } from "@/Components/useToast";

const props = defineProps({
    ventes: Object,
    voyages: Array,
    filters: Object,
    flash: Object,
});

const { showToast } = useToast();

// Filtres réactifs avec debounce intégré
const filters = reactive({
    search: props.filters?.search || "",
    voyage_id: props.filters?.voyage_id || "",
});

let filterTimeout;
watch(
    filters,
    () => {
        clearTimeout(filterTimeout);
        filterTimeout = setTimeout(() => {
            router.get(route("vente.index"), filters, {
                preserveState: true,
                preserveScroll: true,
                replace: true,
            });
        }, 300);
    },
    { deep: true }
);

// Affichage des messages flash
if (props.flash?.success) {
    showToast("success", props.flash.success);
}

// Actions
const showVente = (id) => {
    router.visit(route("vente.show", id));
};

const deleteVente = async (id) => {
    const { isConfirmed } = await Swal.fire({
        title: "Confirmer la suppression",
        text: "Cette action est irréversible !",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d33",
        cancelButtonColor: "#3085d6",
        confirmButtonText: "Supprimer",
        cancelButtonText: "Annuler",
    });

    if (isConfirmed) {
        router.delete(route("vente.destroy", id), {
            onSuccess: () => showToast("success", "La vente a été supprimée"),
            onError: () => showToast("error", "Erreur lors de la suppression"),
        });
    }
};

// Formatage des données pour affichage
const formatPrice = (price) =>
    price ? `${price.toLocaleString()} FCFA` : "---";
const formatDate = (dateString) => {
    if (!dateString) return "---";
    const date = new Date(dateString);
    return date.toLocaleDateString("fr-FR", {
        day: "2-digit",
        month: "2-digit",
        year: "numeric",
    });
};
</script>

<template>
    <AppLayout>
        <!-- En-tête de page amélioré -->
        <div class="users-header">
            <div class="header-content">
                <div class="header-title-wrapper">
                    <h1 class="page-title">Gestions des Ventes</h1>
                    <Link :href="route('vente.create')" class="btn-create-user">
                        <Plus size="16" class="me-1" />
                        Nouvelle vente
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
                        <li class="breadcrumb-item active">Ventes</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Filtres -->
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="input-group">
                    <select
                        v-model="filters.voyage_id"
                        class="form-control"
                        aria-label="Filtrer par voyage"
                    >
                        <option value="">Tous les voyages</option>
                        <option
                            v-for="voyage in voyages"
                            :key="voyage.id"
                            :value="voyage.id"
                        >
                            {{ voyage.nom }} ({{
                                formatDate(voyage.date_depart)
                            }})
                        </option>
                    </select>
                </div>
            </div>
            <div class="col-md-6">
                <div class="input-group">
                    <input
                        type="text"
                        v-model="filters.search"
                        placeholder="Rechercher par client..."
                        class="form-control"
                        aria-label="Rechercher des ventes"
                    />
                    <button
                        class="btn btn-outline-secondary"
                        type="button"
                        @click="router.get(route('vente.index'), filters)"
                        aria-label="Lancer la recherche"
                    >
                        <i class="mdi mdi-magnify"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- Tableau des ventes -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div
                            class="d-flex justify-content-between align-items-center mb-4"
                        >
                            <h4 class="card-title mb-0">Liste des ventes</h4>
                            <Link
                                :href="route('vente.create')"
                                class="btn btn-primary btn-icon-text"
                                aria-label="Créer une nouvelle vente"
                            >
                                <Plus size="16" class="me-1" />
                                Nouvelle Vente
                            </Link>
                        </div>

                        <div class="table-responsive">
                            <table
                                class="table table-hover"
                                aria-label="Liste des ventes"
                            >
                                <thead class="table-light">
                                    <tr>
                                        <th scope="col">#</th>
                                        <th scope="col">Client</th>
                                        <th scope="col">Voyage</th>
                                        <th scope="col">Train</th>
                                        <th scope="col" class="text-end">
                                            Prix Unitaire(PU)
                                        </th>
                                        <th scope="col">Bagage</th>
                                        <th scope="col" class="text-end">
                                            Quantité
                                        </th>
                                        <th scope="col" class="text-end">
                                            Poids
                                        </th>
                                        <th scope="col" class="text-center">
                                            Actions
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(vente, index) in ventes.data"
                                        :key="vente.id"
                                    >
                                        <td>{{ ventes.from + index }}</td>
                                        <td>{{ vente.client_nom || "---" }}</td>
                                        <td>
                                            <template v-if="vente.voyage">
                                                {{ vente.voyage.nom }}
                                                <small
                                                    class="text-muted d-block"
                                                >
                                                    {{
                                                        formatDate(
                                                            vente.voyage
                                                                .date_depart
                                                        )
                                                    }}
                                                </small>
                                            </template>
                                            <span v-else>---</span>
                                        </td>
                                        <td>
                                            {{ vente.train?.numero || "---" }}
                                        </td>
                                        <td class="text-end">
                                            {{ formatPrice(vente.prix) }}
                                        </td>
                                        <td>
                                            <span
                                                :class="`badge bg-${
                                                    vente.bagage
                                                        ? 'success'
                                                        : 'secondary'
                                                }`"
                                            >
                                                {{
                                                    vente.bagage ? "Oui" : "Non"
                                                }}
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            {{
                                                vente.quantite
                                                    ? `${vente.quantite} Billets`
                                                    : "---"
                                            }}
                                        </td>
                                        <td class="text-end">
                                            {{
                                                vente.poids_bagage
                                                    ? `${vente.poids_bagage} kg`
                                                    : "---"
                                            }}
                                        </td>
                                        <td class="text-center">
                                            <div
                                                class="btn-group"
                                                role="group"
                                                aria-label="Actions"
                                            >
                                                <button
                                                    @click="showVente(vente.id)"
                                                    class="btn btn-info btn-sm"
                                                    aria-label="Voir détails"
                                                >
                                                    <Eye size="16" />
                                                </button>
                                                <Link
                                                    :href="
                                                        route(
                                                            'vente.edit',
                                                            vente.id
                                                        )
                                                    "
                                                    class="btn btn-warning btn-sm"
                                                    aria-label="Modifier"
                                                >
                                                    <Pencil size="16" />
                                                </Link>
                                                <button
                                                    @click="
                                                        deleteVente(vente.id)
                                                    "
                                                    class="btn btn-danger btn-sm"
                                                    aria-label="Supprimer"
                                                >
                                                    <Trash size="16" />
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr v-if="ventes.data.length === 0">
                                        <td
                                            colspan="9"
                                            class="text-center py-4 text-muted"
                                        >
                                            Aucune vente trouvée
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <p class="text-muted">
                                    Affichage de {{ ventes.from }} à
                                    {{ ventes.to }} sur
                                    {{ ventes.total }} ventes
                                </p>
                            </div>
                            <div class="col-md-6">
                                <nav aria-label="Pagination des ventes">
                                    <ul class="pagination float-end">
                                        <li
                                            v-for="link in ventes.links"
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
                                                :aria-label="`Page ${link.label}`"
                                                :aria-current="
                                                    link.active ? 'page' : null
                                                "
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
                    </div>
                </div>
            </div>
        </div>

        <div class="users-container">
            <div class="users-card">
                <!-- Barre d'outils avec recherche -->
                <div class="table-header">
                    <div class="search-box">
                        <input
                            type="text"
                            v-model="filters.search"
                            placeholder="Recherche par client..."
                            class="search-input"
                        />
                        <button
                            class="search-btn"
                            type="button"
                            @click="router.get(route('vente.index'), filters)"
                            aria-label="Lancer la recherche"
                        >
                            <Search size="16" />
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tableau -->
                <div class="table-responsive">
                    <table class="users-table">
                        <thead>
                            <tr>
                                <th class="column-id">#</th>
                                <th>Client</th>
                                <th>Voyages</th>
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
                                    {{ point.client_nom }}
                                </td>
                                <td>{{ point.voyage }}</td>
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
                                        {{ vente.actif }}
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <Link
                                            :href="
                                                route(
                                                    'vente.edit',
                                                    point.id
                                                )
                                            "
                                            class="btn-action btn-edit"
                                            title="Modifier"
                                        >
                                            <Pencil size="16" />
                                        </Link>
                                        <button
                                            @click="deleteVente(vente.id)"
                                            class="btn-action btn-delete"
                                            title="Supprimer"
                                        >
                                            <Trash size="16" />
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr v-if="ventes.data.length === 0">
                                <td colspan="6" class="no-results">
                                    <i>Aucune vente trouvée</i>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

        <!-- Pagination -->
        <div class="table-footer">
            <div class="pagination-info">
                Affichage de {{ ventes.from }} à {{ ventes.to }} sur
                {{ ventes.total }} points
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
