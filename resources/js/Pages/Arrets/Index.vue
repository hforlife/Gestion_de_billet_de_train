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
.btn-group-sm .btn {
    padding: 0.25rem 0.5rem;
}
.page-item.active .page-link {
    background-color: #3b82f6;
    border-color: #3b82f6;
}
</style>
