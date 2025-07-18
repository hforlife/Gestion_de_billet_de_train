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
watch(filters, () => {
    clearTimeout(filterTimeout);
    filterTimeout = setTimeout(() => {
        router.get(route("vente.index"), filters, {
            preserveState: true,
            preserveScroll: true,
            replace: true,
        });
    }, 300);
}, { deep: true });

// Affichage des messages flash
if (props.flash?.success) {
    showToast('success', props.flash.success);
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
            onSuccess: () => showToast('success', 'La vente a été supprimée'),
            onError: () => showToast('error', 'Erreur lors de la suppression'),
        });
    }
};

// Formatage des données pour affichage
const formatPrice = (price) => price ? `${price.toLocaleString()} FCFA` : "---";
const formatDate = (dateString) => {
    if (!dateString) return "---";
    const date = new Date(dateString);
    return date.toLocaleDateString('fr-FR', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
    });
};
</script>

<template>
    <AppLayout>
        <!-- Titre et fil d'ariane -->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Gestion des Ventes</h4>
                    <div class="quick-link-wrapper w-100 d-md-flex flex-md-wrap">
                        <ul class="quick-links ml-auto">
                            <li><Link :href="route('dashboard')">Tableau de bord</Link></li>
                            <li>Ventes</li>
                        </ul>
                    </div>
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
                            {{ voyage.name }} ({{ formatDate(voyage.date_depart) }})
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
                        <div class="d-flex justify-content-between align-items-center mb-4">
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
                            <table class="table table-hover" aria-label="Liste des ventes">
                                <thead class="table-light">
                                    <tr>
                                        <th scope="col">#</th>
                                        <th scope="col">Client</th>
                                        <th scope="col">Voyage</th>
                                        <th scope="col">Train</th>
                                        <th scope="col" class="text-end">Prix Unitaire(PU)</th>
                                        <th scope="col">Bagage</th>
                                        <th scope="col" class="text-end">Quantité</th>
                                        <th scope="col" class="text-end">Poids</th>
                                        <th scope="col" class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(vente, index) in ventes.data" :key="vente.id">
                                        <td>{{ ventes.from + index }}</td>
                                        <td>{{ vente.client_nom || "---" }}</td>
                                        <td>
                                            <template v-if="vente.voyage">
                                                {{ vente.voyage.name }}
                                                <small class="text-muted d-block">
                                                    {{ formatDate(vente.voyage.date_depart) }}
                                                </small>
                                            </template>
                                            <span v-else>---</span>
                                        </td>
                                        <td>{{ vente.train?.numero || "---" }}</td>
                                        <td class="text-end">{{ formatPrice(vente.prix) }}</td>
                                        <td>
                                            <span :class="`badge bg-${vente.bagage ? 'success' : 'secondary'}`">
                                                {{ vente.bagage ? "Oui" : "Non" }}
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            {{ vente.quantite ? `${vente.quantite} Billets` : "---" }}
                                        </td>
                                        <td class="text-end">
                                            {{ vente.poids_bagage ? `${vente.poids_bagage} kg` : "---" }}
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group" aria-label="Actions">
                                                <button
                                                    @click="showVente(vente.id)"
                                                    class="btn btn-info btn-sm"
                                                    aria-label="Voir détails"
                                                >
                                                    <Eye size="16" />
                                                </button>
                                                <Link
                                                    :href="route('vente.edit', vente.id)"
                                                    class="btn btn-warning btn-sm"
                                                    aria-label="Modifier"
                                                >
                                                    <Pencil size="16" />
                                                </Link>
                                                <button
                                                    @click="deleteVente(vente.id)"
                                                    class="btn btn-danger btn-sm"
                                                    aria-label="Supprimer"
                                                >
                                                    <Trash size="16" />
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr v-if="ventes.data.length === 0">
                                        <td colspan="9" class="text-center py-4 text-muted">
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
                                    Affichage de {{ ventes.from }} à {{ ventes.to }} sur {{ ventes.total }} ventes
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
                                                :aria-current="link.active ? 'page' : null"
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
    </AppLayout>
</template>

<style scoped>
.table-hover tbody tr:hover {
    background-color: rgba(75, 73, 172, 0.05);
    transition: background-color 0.2s ease;
}

.badge {
    padding: 5px 10px;
    border-radius: 50px;
    font-weight: 500;
    font-size: 0.85em;
}

.btn-group {
    white-space: nowrap;
}

.btn-sm {
    padding: 0.25rem 0.5rem;
}

.page-item.active .page-link {
    background-color: #4b49ac;
    border-color: #4b49ac;
}

.page-link {
    color: #4b49ac;
}
</style>
