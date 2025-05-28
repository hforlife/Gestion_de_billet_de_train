<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Pencil, Trash, Eye, Plus } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    voyages: Object,
    filters: Object,
    flash: Object,
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
            route("voyage.index"),
            { search: newValue },
            {
                preserveState: true,
                replace: true,
            }
        );
    }
);
// Affichage du message flash
if (props.flash && props.flash.success) {
    Swal.fire("Succès", props.flash.success, "success");
}

// Fonction pour rediriger vers la page d’édition avec l'ID
const editVoyage = (id) => {
    router.visit(route("voyage.edit", id));
};

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
                        "Le Voyage a été supprimée avec succès.",
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
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Gestion des Voyages</h4>
                    <div
                        class="quick-link-wrapper w-100 d-md-flex flex-md-wrap"
                    >
                        <ul class="quick-links">
                            <li><a href="#">Dashboard</a></li>
                            <li><a href="#">Voyages</a></li>
                        </ul>
                        <ul class="quick-links ml-auto">
                            <li><a href="#">Settings</a></li>
                            <li><a href="#">Analytics</a></li>
                            <li><a href="#">Watchlist</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- 🔍 Barre de recherche -->
         <div class="row mb-3">
            <div class="col-md-6">
                <div class="input-group">
                    <input
                        type="text"
                        v-model="filters.search"
                        placeholder="Rechercher par nom..."
                        class="form-control"
                    />
                    <button
                        class="btn btn-outline-secondary"
                        type="button"
                        @click="getResults"
                    >
                        <i class="mdi mdi-magnify"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- 📋 Tableau des Voyages -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <!-- Titre -->
                        <div
                            class="d-flex justify-content-between align-items-center mb-4"
                            >
                            <h4 class="card-title mb-0">Liste des voyages</h4>
                            <!-- ➕ Bouton de création -->
                            <Link
                                :href="route('voyage.create')"
                                class="btn btn-primary btn-icon-text"
                            >
                                <Plus size="16" class="me-1" />
                                Nouveaux Voyages
                            </Link>
                        </div>
                        
                        <!-- Formulaire -->
                         <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Nom du voyage</th>
                                        <th>Train</th>
                                        <th>Gare de Depart</th>
                                        <th>Gare d'Arrivée</th>
                                        <th>Date Depart</th>
                                        <th>Date Arrivée</th>
                                        <th>Tarif (FCFA)</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(voyage, index) in voyages.data"
                                        :key="voyage.id"
                                    >
                                        <td class="py-1">
                                            {{ index + 1 }}
                                        </td>
                                        <td>{{ voyage.name }}</td>
                                        <td>{{ voyage.train.numero }}</td>
                                        <td>{{ voyage.gare_depart.nom }}</td>
                                        <td>{{ voyage.gare_arrivee.nom }}</td>
                                        <td>{{ voyage.date_depart }}</td>
                                        <td>{{ voyage.date_arrivee }}</td>
                                        <td>{{ voyage.prix }}</td>
                                        <td>{{ voyage.statut }}</td>
                                        <td>
                                            <button
                                                @click="editVoyage(voyage.id)"
                                                class="btn btn-warning toolbar-item m-2"
                                            >
                                                <Pencil size="16" />
                                            </button>
                                            <button
                                                @click="deleteVoyage(voyage.id)"
                                                class="btn btn-danger toolbar-item"
                                            >
                                                <Trash size="16" />
                                            </button>
                                        </td>
                                    </tr>
                                     <tr v-if="voyages.data.length === 0">
                                        <td
                                            colspan="8"
                                            class="text-center py-4 text-muted"
                                        >
                                            Aucune vente trouvée
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 📄 Pagination -->
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <p class="text-muted">
                                    Affichage de {{ voyages.from }} à
                                    {{ voyages.to }} sur
                                    {{ voyages.total }} voyages
                                </p>
                            </div>
                            <div class="col-md-6">
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
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
