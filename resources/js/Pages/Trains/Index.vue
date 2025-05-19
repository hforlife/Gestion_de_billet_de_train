<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Trash, Pencil } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    trains: Array,
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
            route("train.index"),
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
const editTrain = (id) => {
    router.visit(route("train.edit", id));
};

const deleteTrain = (id) => {
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
            router.delete(route("train.destroy", id), {
                onSuccess: () => {
                    Swal.fire(
                        "Supprimé !",
                        "Le Train a été supprimée avec succès.",
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
                    <h4 class="page-title">Gestion des Trains</h4>
                </div>
            </div>
        </div>

        <!-- 🔍 Barre de recherche -->
        <div class="input-group filter mb-3">
            <input
                type="text"
                v-model="filters.search"
                placeholder="Rechercher par numero de train..."
                class="form-control"
            />
        </div>

        <!-- 📋 Tableau des Trains -->
        <div class="row">
            <div class="col-lg-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <!-- Titre -->
                        <div class="d-flex justify-content-between">
                            <h4 class="card-title mb-0">Listes des Trains</h4>
                        </div>

                        <!-- Message flash -->
                        <div
                            v-if="props.flash.success"
                            class="alert alert-success"
                        >
                            {{ props.flash.success }}
                        </div>

                        <!-- ➕ Bouton de création -->
                        <div class="pt-4 pb-4">
                            <Link
                                type="button"
                                :href="route('train.create')"
                                class="btn btn-primary toolbar-item"
                                >Nouveau Train</Link
                            >
                        </div>

                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Numéro du Train</th>
                                        <th>Capacité(Personnes)</th>
                                        <th>Etat</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(train, index) in trains.data"
                                        :key="train.id"
                                    >
                                        <td class="py-1">{{ index + 1 }}</td>
                                        <td>{{ train.numero }}</td>
                                        <td>{{ train.capacite }}</td>
                                        <td>{{ train.etat }}</td>
                                        <td>
                                            <button
                                                @click="editTrain(train.id)"
                                                class="btn btn-warning toolbar-item m-2"
                                            >
                                                <Pencil size="16" />
                                            </button>
                                            <button
                                                @click="deleteTrain(train.id)"
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
                                    v-for="link in trains.links"
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
            <!-- Fin Tableau -->
        </div>
    </AppLayout>
</template>
