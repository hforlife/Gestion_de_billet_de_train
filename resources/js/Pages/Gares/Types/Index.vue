<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Pencil, Trash, Plus } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    types: Object, // pagination des types de gare
    filters: Object,
    flash: Object,
});

const filters = reactive({
    search: props.filters.search || "",
});

// Recherche en live
watch(
    () => filters.search,
    (newValue) => {
        router.get(
            route("type.index"),
            { search: newValue },
            {
                preserveState: true,
                replace: true,
            }
        );
    }
);

// Modifier
const editType = (id) => {
    router.visit(route("type.edit", id));
};

// Supprimer avec confirmation
const deleteType = (id) => {
    Swal.fire({
        title: "Supprimer ce type ?",
        text: "Cette action est irréversible.",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Oui, supprimer",
        cancelButtonText: "Annuler",
    }).then((result) => {
        if (result.isConfirmed) {
            router.delete(route("type.destroy", id), {
                onSuccess: () =>
                    Swal.fire("Supprimé", "Type supprimé avec succès", "success"),
            });
        }
    });
};
</script>

<template>
    <AppLayout>
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Types de Gare</h4>
                    <div class="quick-link-wrapper w-100 d-md-flex flex-md-wrap">
                        <ul class="quick-links ml-auto">
                            <li>
                                <Link :href="route('dashboard')">Tableau de bord</Link>
                            </li>
                            <li><span>Types de gare</span></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- 🔍 Barre de recherche -->
        <div class="row mb-3">
            <div class="col-md-6">
                <input
                    type="text"
                    v-model="filters.search"
                    placeholder="Rechercher un type..."
                    class="form-control"
                />
            </div>
        </div>

        <!-- 📋 Tableau -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div
                            class="d-flex justify-content-between align-items-center mb-4"
                        >
                            <h4 class="card-title mb-0">Liste des Types de Gares</h4>
                            <Link
                                :href="route('type.create')"
                                class="btn btn-primary btn-icon-text"
                            >
                                <Plus size="16" class="me-1" />
                                Nouveau Type
                            </Link>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Type</th>
                                        <th>Description</th>
                                        <th>Nombre de Gares</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(type, index) in types.data"
                                        :key="type.id"
                                    >
                                        <td>{{ index + 1 }}</td>
                                        <td>{{ type.type }}</td>
                                        <td>{{ type.description }}</td>
                                        <td>{{ type.gares_count }}</td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <button
                                                    @click="editType(type.id)"
                                                    class="btn btn-warning btn-sm"
                                                    title="Modifier"
                                                >
                                                    <Pencil size="16" />
                                                </button>
                                                <button
                                                    @click="deleteType(type.id)"
                                                    class="btn btn-danger btn-sm"
                                                    title="Supprimer"
                                                >
                                                    <Trash size="16" />
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr v-if="types.data.length === 0">
                                        <td colspan="5" class="text-center text-muted py-4">
                                            Aucun type de gare trouvé
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 📄 Pagination -->
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <p class="text-muted">
                                    Affichage de {{ types.from }} à {{ types.to }} sur
                                    {{ types.total }} types
                                </p>
                            </div>
                            <div class="col-md-6">
                                <nav class="float-end">
                                    <ul class="pagination">
                                        <li
                                            v-for="link in types.links"
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
