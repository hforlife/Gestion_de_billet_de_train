<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Trash, Pencil } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    gares: Object, // paginated data
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
            route("gare.index"),
            { search: newValue },
            {
                preserveState: true,
                replace: true,
            }
        );
    }
);

// ✏️ Redirection vers la page d’édition
const editGare = (id) => {
    router.visit(route("gare.edit", id));
};

// 🗑️ Suppression avec confirmation
const deleteGare = (id) => {
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
            router.delete(route("gare.destroy", id), {
                onSuccess: () => {
                    Swal.fire(
                        "Supprimé !",
                        "La gare a été supprimée avec succès.",
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
                    <h4 class="page-title">Gestion des Gares</h4>
                </div>
            </div>
        </div>

        <!-- 🔍 Barre de recherche -->
        <div class="input-group filter mb-3">
            <input
                type="text"
                v-model="filters.search"
                placeholder="Rechercher par nom..."
                class="form-control"
            />
        </div>

        <!-- 📋 Tableau des gares -->
        <div class="row">
            <div class="col-lg-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <!-- Titre -->
                        <div class="d-flex justify-content-between">
                            <h4 class="card-title mb-0">Liste des Gares</h4>
                        </div>

                        <!-- ➕ Bouton de création -->
                        <div class="mt-3">
                            <Link
                                :href="route('gare.create')"
                                class="btn btn-primary"
                                >Nouvelle Gare</Link
                            >
                        </div>

                        <!-- Formulaire -->
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Nom</th>
                                        <th>Adresse</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(gare, index) in gares.data"
                                        :key="gare.id"
                                    >
                                        <td>{{ index + 1 }}</td>
                                        <td>{{ gare.nom }}</td>
                                        <td>{{ gare.adresse }}</td>
                                        <td>
                                            <button
                                                @click="editGare(gare.id)"
                                                class="btn btn-warning toolbar-item m-2"
                                            >
                                                <Pencil size="16" />
                                            </button>
                                            <button
                                                @click="deleteGare(gare.id)"
                                                class="btn btn-danger toolbar-item"
                                            >
                                                <Trash size="16" />
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 📄 Pagination -->
                        <nav class="mt-4">
                            <ul class="pagination">
                                <li
                                    v-for="link in gares.links"
                                    :key="link.label"
                                    :class="[
                                        'page-item',
                                        {
                                            active: link.active,
                                            disabled: !link.url,
                                        },
                                    ]"
                                >
                                    <Link
                                        v-if="link.url"
                                        class="page-link"
                                        :href="link.url"
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
    </AppLayout>
</template>
