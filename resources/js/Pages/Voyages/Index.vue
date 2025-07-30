<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Pencil, Trash, Plus } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    voyages: Object,
    filters: Object,
});

const filters = reactive({
    search: props.filters.search || "",
});

watch(
    () => filters.search,
    (newValue) => {
        router.get(
            route("voyage.index"),
            { search: newValue },
            { preserveState: true, replace: true }
        );
    }
);

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
                        "Le voyage a été supprimé avec succès.",
                        "success"
                    );
                },
            });
        }
    });
};

const formatDate = (date) => {
    return new Date(date).toLocaleString("fr-FR", {
        day: "2-digit",
        month: "2-digit",
        year: "numeric",
        hour: "2-digit",
        minute: "2-digit",
    });
};

const getStatusClass = (statut) => {
    return statut.replace("é", "e").replace(" ", "_");
};

const formatStatus = (statut) => {
    return statut.charAt(0).toUpperCase() + statut.slice(1).replace("_", " ");
};
</script>

<template>
    <AppLayout>
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Gestion des Voyages</h4>
                    <div
                        class="quick-link-wrapper w-100 d-md-flex flex-md-wrap"
                    >
                        <ul class="quick-links ml-auto">
                            <li>
                                <Link :href="route('dashboard')"
                                    >Tableau de bord</Link
                                >
                            </li>
                            <li><a href="#">Voyages</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <div class="input-group">
                    <input
                        type="text"
                        v-model="filters.search"
                        placeholder="Rechercher un voyage..."
                        class="form-control"
                    />
                    <button class="btn btn-outline-secondary" type="button">
                        <i class="mdi mdi-magnify"></i>
                    </button>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div
                            class="d-flex justify-content-between align-items-center mb-4"
                        >
                            <h4 class="card-title mb-0">Liste des voyages</h4>
                            <Link
                                :href="route('voyage.create')"
                                class="btn btn-primary btn-icon-text"
                            >
                                <Plus size="16" class="me-1" />
                                Nouveau Voyage
                            </Link>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Nom</th>
                                        <th>Train</th>
                                        <th>Ligne</th>
                                        <th>Départ</th>
                                        <th>Arrivée</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(voyage, index) in voyages.data"
                                        :key="voyage.id"
                                    >
                                        <td>{{ index + 1 }}</td>
                                        <td>{{ voyage.nom }}</td>
                                        <td>{{ voyage.train.numero }}</td>
                                        <td>{{ voyage.ligne.nom }}</td>
                                        <td>
                                            {{ formatDate(voyage.date_depart) }}
                                        </td>
                                        <td>
                                            {{
                                                formatDate(voyage.date_arrivee)
                                            }}
                                        </td>
                                        <td>
                                            <span
                                                :class="`badge badge-${getStatusClass(
                                                    voyage.statut
                                                )}`"
                                            >
                                                {{
                                                    formatStatus(voyage.statut)
                                                }}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <button
                                                    @click="
                                                        editVoyage(voyage.id)
                                                    "
                                                    class="btn btn-warning btn-sm"
                                                    title="Modifier"
                                                >
                                                    <Pencil size="16" />
                                                </button>
                                                <button
                                                    @click="
                                                        deleteVoyage(voyage.id)
                                                    "
                                                    class="btn btn-danger btn-sm"
                                                    title="Supprimer"
                                                >
                                                    <Trash size="16" />
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr v-if="voyages.data.length === 0">
                                        <td
                                            colspan="9"
                                            class="text-center py-4 text-muted"
                                        >
                                            Aucun voyage trouvé
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

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

<style>
.badge-programmé {
    background-color: #17a2b8;
}
.badge-en_cours {
    background-color: #28a745;
}
.badge-terminé {
    background-color: #6c757d;
}
.badge-annulé {
    background-color: #dc3545;
}
</style>
