<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Plus, Pencil, Trash } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    ClassesWagons: Object, // objet paginé venant du contrôleur
    filters: Object,
    flash: Object,
});

// Filtres réactifs
const filters = reactive({
    search: props.filters.search || "",
});

// Mise à jour automatique de la recherche
watch(
    () => filters.search,
    (newValue) => {
        router.get(
            route("classe.index"),
            { search: newValue },
            { preserveState: true, replace: true }
        );
    }
);

// Message flash succès
if (props.flash && props.flash.success) {
    Swal.fire("Succès", props.flash.success, "success");
}

// Actions
const editClasse = (id) => {
    router.visit(route("classe.edit", id));
};

const deleteClasse = (id) => {
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
            router.delete(route("classe.destroy", id), {
                onSuccess: () => {
                    Swal.fire(
                        "Supprimé !",
                        "La classe a été supprimée avec succès.",
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
        <!-- Titre et navigation -->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Gestion des Classes de Wagons</h4>
                    <div class="quick-link-wrapper w-100 d-md-flex flex-md-wrap">
                        <ul class="quick-links ml-auto">
                            <li><Link :href="route('dashboard')">Tableau de bord</Link></li>
                            <li><Link :href="route('classe.index')">Classes de Wagons</Link></li>
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
                        placeholder="Rechercher par nom de classe..."
                        class="form-control"
                    />
                    <button class="btn btn-outline-secondary" type="button" @click="$router.reload()">
                        <i class="mdi mdi-magnify"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- Tableau des Classes de Wagons -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="card-title mb-0">Liste des Classes de Wagons</h4>
                            <Link
                                :href="route('classe.create')"
                                class="btn btn-primary btn-icon-text"
                            >
                                <Plus size="16" class="me-1" />
                                Nouvelle Classe
                            </Link>
                        </div>

                        <!-- Message flash -->
                        <div v-if="props.flash.success" class="alert alert-success">
                            {{ props.flash.success }}
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Nom de la Classe</th>
                                        <th>Multiplicateur de Prix</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(classe, index) in ClassesWagons.data" :key="classe.id">
                                        <td class="py-1">{{ ClassesWagons.from + index }}</td>
                                        <td>{{ classe.classe }}</td>
                                        <td>{{ classe.prix_multiplier }}</td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group">
                                                <button
                                                    @click="editClasse(classe.id)"
                                                    class="btn btn-warning btn-sm"
                                                    title="Modifier"
                                                >
                                                    <Pencil size="16" />
                                                </button>
                                                <button
                                                    @click="deleteClasse(classe.id)"
                                                    class="btn btn-danger btn-sm"
                                                    title="Supprimer"
                                                >
                                                    <Trash size="16" />
                                                </button>
                                            </div>
                                        </td>
                                    </tr>

                                    <tr v-if="ClassesWagons.data.length === 0">
                                        <td colspan="4" class="text-center py-4 text-muted">
                                            Aucune classe trouvée
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <p class="text-muted">
                                    Affichage de {{ ClassesWagons.from }} à
                                    {{ ClassesWagons.to }} sur {{ ClassesWagons.total }} classes
                                </p>
                            </div>
                            <div class="col-md-6">
                                <nav class="float-end" aria-label="Pagination">
                                    <ul class="pagination">
                                        <li
                                            v-for="link in ClassesWagons.links"
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

                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
