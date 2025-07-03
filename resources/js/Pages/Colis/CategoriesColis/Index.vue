<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Pencil, Trash, Plus } from "lucide-vue-next";
import Swal from "sweetalert2";

// Props envoyées depuis le contrôleur
const props = defineProps({
    categories: Object, // objet paginé
    filters: Object,
    flash: Object,
});

// Filtres réactifs
const filters = reactive({
    search: props.filters.search || "",
});

// Mise à jour automatique des résultats au changement du champ recherche
watch(
    () => filters.search,
    (newValue) => {
        router.get(
            route("categories-colis.index"),
            { search: newValue },
            {
                preserveState: true,
                replace: true,
            }
        );
    }
);

// Message de succès
if (props.flash?.success) {
    Swal.fire("Succès", props.flash.success, "success");
}

// Redirection vers la page d’édition
const editCategorie = (id) => {
    router.visit(route("categories-colis.edit", id));
};

// Suppression avec confirmation
const deleteCategorie = (id) => {
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
            router.delete(route("categories-colis.destroy", id), {
                onSuccess: () => {
                    Swal.fire(
                        "Supprimé !",
                        "La catégorie de colis a été supprimée avec succès.",
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
        <!-- Titre de la page -->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Catégories de Colis</h4>
                    <div class="quick-link-wrapper w-100 d-md-flex flex-md-wrap">
                        <ul class="quick-links ml-auto">
                            <li><a href="#">Tableau de bord</a></li>
                            <li><a href="#">Catégories</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Barre de recherche -->
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="input-group">
                    <input
                        type="text"
                        v-model="filters.search"
                        placeholder="Rechercher par nom de catégorie..."
                        class="form-control"
                    />
                </div>
            </div>
        </div>

        <!-- Tableau des catégories -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <!-- En-tête -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="card-title mb-0">Liste des Catégories</h4>
                            <Link
                                :href="route('categories-colis.create')"
                                class="btn btn-primary btn-icon-text"
                            >
                                <Plus size="16" class="me-1" />
                                Nouvelle Catégorie
                            </Link>
                        </div>

                        <!-- Tableau -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Nom</th>
                                        <th>Description</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(categorie, index) in categories.data"
                                        :key="categorie.id"
                                    >
                                        <td>{{ index + 1 }}</td>
                                        <td>{{ categorie.nom }}</td>
                                        <td>{{ categorie.description }}</td>
                                        <td class="text-center">
                                            <div class="btn-group">
                                                <button
                                                    @click="editCategorie(categorie.id)"
                                                    class="btn btn-warning btn-sm"
                                                >
                                                    <Pencil size="16" />
                                                </button>
                                                <button
                                                    @click="deleteCategorie(categorie.id)"
                                                    class="btn btn-danger btn-sm"
                                                >
                                                    <Trash size="16" />
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr v-if="categories.data.length === 0">
                                        <td colspan="4" class="text-center text-muted py-4">
                                            Aucune catégorie trouvée
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <p class="text-muted">
                                    Affichage de {{ categories.from }} à
                                    {{ categories.to }} sur
                                    {{ categories.total }} catégories
                                </p>
                            </div>
                            <div class="col-md-6">
                                <nav class="float-end">
                                    <ul class="pagination">
                                        <li
                                            v-for="link in categories.links"
                                            :key="link.label"
                                            class="page-item"
                                            :class="{ active: link.active, disabled: !link.url }"
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
        </div>
    </AppLayout>
</template>
