<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Pencil, Trash, Eye, Plus } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    lignes: Object, // paginated data
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
            route("ligne.index"),
            { search: newValue },
            {
                preserveState: true,
                replace: true,
            }
        );
    }
);

// ✏️ Redirection vers la page d’édition
const editLigne = (id) => {
    router.visit(route("ligne.edit", id));
};

// 🗑️ Suppression avec confirmation
const deleteLigne = (id) => {
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
            router.delete(route("ligne.destroy", id), {
                onSuccess: () => {
                    Swal.fire(
                        "Supprimé !",
                        "La ligne a été supprimée avec succès.",
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
                    <h4 class="page-title">Gestion des Lignes</h4>
                    <div
                        class="quick-link-wrapper w-100 d-md-flex flex-md-wrap"
                    >
                        <ul class="quick-links ml-auto">
                           <li><Link :href="route('dashboard')">Tableau de bord</Link></li>
                            <li><a href="#">Lignes</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div

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

        <!-- 📋 Tableau des lignes -->
       <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <!-- Titre -->
                        <div
                            class="d-flex justify-content-between align-items-center mb-4"
                        >
                            <h4 class="card-title mb-0">Liste des lignes</h4>
                            <!-- ➕ Bouton de création -->
                            <Link
                                :href="route('ligne.create')"
                                class="btn btn-primary btn-icon-text"
                            >
                                <Plus size="16" class="me-1" />
                                Nouvelle ligne
                            </Link>
                        </div>



                        <!-- Formulaire -->
                       <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Nom</th>
                                        <th>Gare de Depart</th>
                                        <th>Gare d'Arrivée</th>
                                        <th>Distance Totale</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(ligne, index) in lignes.data"
                                        :key="ligne.id"
                                    >
                                        <td>{{ index + 1 }}</td>
                                        <td>{{ ligne.nom }}</td>
                                        <td>{{ ligne.gare_depart_id }}</td>
                                        <td>{{ ligne.gare_arrivee_id }}</td>
                                        <td>{{ ligne.distance_totale }}</td>
                                        <td>
                                            <div class="btn-group" role="group">
                                            <button
                                                @click="editLigne(ligne.id)"
                                                class="btn btn-warning btn-sm"
                                                title="Modifier"
                                            >
                                                <Pencil size="16" />
                                            </button>
                                            <button
                                                @click="deleteLigne(ligne.id)"
                                                class="btn btn-danger btn-sm"
                                                title="Supprimer"
                                            >
                                                <Trash size="16" />
                                            </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr v-if="lignes.data.length === 0">
                                        <td
                                            colspan="8"
                                            class="text-center py-4 text-muted"
                                        >
                                            Aucune ligne trouvée
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 📄 Pagination -->
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <p class="text-muted">
                                    Affichage de {{ lignes.from }} à
                                    {{ lignes.to }} sur
                                    {{ lignes.total }} ventes
                                </p>
                            </div>
                            <div class="col-md-6">
                                <nav class="float-end">
                                    <ul class="pagination">
                                        <li
                                            v-for="link in lignes.links"
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
