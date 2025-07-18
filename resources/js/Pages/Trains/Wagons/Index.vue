<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Plus, Pencil, Trash, Eye, Search, Download } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    wagons: Array,
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
            route("wagon.index"),
            { search: newValue },
            {
                preserveState: true,
                replace: true,
            }
        );
    }
);

if (props.flash && props.flash.success) {
    Swal.fire("Succès", props.flash.success, "success");
}

// Fonction pour rediriger vers la page d’édition avec l'ID
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
                        "Le wagon a été supprimée avec succès.",
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
                    <h4 class="page-title">Gestion des wagons</h4>
                    <div class="quick-link-wrapper w-100 d-md-flex flex-md-wrap">
                    <ul class="quick-links ml-auto">
                     <li><Link :href="route('dashboard')">Tableau de bord</Link></li>
                      <li><Link :href="wagon">wagons </Link></li>
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
                    >
                    <button class="btn btn-outline-secondary" type="button" @click="getResults">
                        <i class="mdi mdi-magnify"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- 📋 Tableau des wagons -->
         <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="card-title mb-0">Liste des wagons</h4>
                            <!-- ➕ Bouton de création -->
                            <Link
                                :href="route('wagon.create')"
                                class="btn btn-primary btn-icon-text"
                            >
                                <Plus size="16" class="me-1" />
                                Nouveaux wagon
                            </Link>
                        </div>

                        <!-- Message flash -->
                        <div
                            v-if="props.flash.success"
                            class="alert alert-success"
                        >
                            {{ props.flash.success }}
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Train d'affiliation</th>
                                        <th>Nom du Wagon</th>
                                        <th>Nombre de Places</th>
                                        <th class="text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(wagon, index) in wagons.data"
                                        :key="wagon.id"
                                    >
                                        <td class="py-1">{{ index + 1 }}</td>
                                        <td>{{ wagon.train_id }}</td>
                                        <td>{{ wagon.nom }}</td>
                                        <td>{{ wagon.nombre_places }}</td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <button
                                                    @click="editwagon(wagon.id)"
                                                    class="btn btn-warning btn-sm"
                                                >
                                                    <Pencil size="16" />
                                                </button>
                                                <button
                                                    @click="deletewagon(wagon.id)"
                                                    class="btn btn-danger btn-sm"
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
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <p class="text-muted">
                                    Affichage de {{ wagons.from }} à
                                    {{ wagons.to }} sur
                                    {{ wagons.total }} wagons
                                </p>
                            </div>
                            <div class="col-md-6">
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
                    </div>
                </div>
            </div>
            <!-- Fin Tableau -->
        </div>
    </AppLayout>
</template>
