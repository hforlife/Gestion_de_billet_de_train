<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Pencil, Trash, Plus } from "lucide-vue-next";
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

// Watch de la recherche
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

// Flash message
if (props.flash && props.flash.success) {
    Swal.fire("Succès", props.flash.success, "success");
}

// Actions
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
                    Swal.fire("Supprimé !", "Le voyage a été supprimé.", "success");
                },
            });
        }
    });
};
</script>

<template>
    <AppLayout>
        <!-- 🧭 En-tête -->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header d-flex justify-content-between align-items-center">
                    <h4 class="page-title">Gestion des Voyages Reccurents</h4>
                    <Link :href="route('voyage-reccurent.create')" class="btn btn-primary">
                        <Plus size="16" class="me-1" /> Nouveau Voyage
                    </Link>
                </div>
            </div>
        </div>

        <!-- 🔍 Recherche -->
        <div class="row mb-3">
            <div class="col-md-6">
                <input
                    type="text"
                    v-model="filters.search"
                    class="form-control"
                    placeholder="Rechercher par nom..."
                />
            </div>
        </div>

        <!-- 📋 Tableau des voyages -->
        <div class="row">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Nom</th>
                                        <th>Train</th>
                                        <th>Gare Départ</th>
                                        <th>Gare Arrivée</th>
                                        <th>Date Départ</th>
                                        <th>Date Arrivée</th>
                                        <th>Tarif (FCFA)</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(voyage, index) in voyages.data"
                                        :key="voyage.id"
                                        :class="{
                                            'table-info fw-bold': voyage.jours !== null
                                        }"
                                    >
                                        <td>{{ index + 1 }}</td>
                                        <td>
                                            <span
                                                v-if="voyage.jours"
                                                class="badge bg-info text-white me-1"
                                            >
                                                Récurrent ({{ voyage.jours }})
                                            </span>
                                            {{ voyage.name }}
                                        </td>
                                        <td>{{ voyage.train?.numero || '-' }}</td>
                                        <td>{{ voyage.gare_depart?.nom || '-' }}</td>
                                        <td>{{ voyage.gare_arrivee?.nom || '-' }}</td>
                                        <td>{{ voyage.date_depart ?? '-' }}</td>
                                        <td>{{ voyage.date_arrivee ?? '-' }}</td>
                                        <td>{{ voyage.prix }}</td>
                                        <td>{{ voyage.statut }}</td>
                                        <td>
                                            <div class="btn-group">
                                                <button
                                                    class="btn btn-warning btn-sm"
                                                    @click="editVoyage(voyage.id)"
                                                >
                                                    <Pencil size="16" />
                                                </button>
                                                <button
                                                    class="btn btn-danger btn-sm"
                                                    @click="deleteVoyage(voyage.id)"
                                                >
                                                    <Trash size="16" />
                                                </button>
                                            </div>
                                        </td>
                                    </tr>

                                    <tr v-if="voyages.data.length === 0">
                                        <td colspan="10" class="text-center text-muted py-4">
                                            Aucun voyage trouvé.
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 📄 Pagination -->
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <p class="text-muted mb-0">
                                Affichage de {{ voyages.from }} à {{ voyages.to }} sur {{ voyages.total }} voyages
                            </p>
                            <nav>
                                <ul class="pagination mb-0">
                                    <li
                                        v-for="link in voyages.links"
                                        :key="link.label"
                                        :class="['page-item', { active: link.active, disabled: !link.url }]"
                                    >
                                        <Link
                                            v-if="link.url"
                                            class="page-link"
                                            :href="link.url"
                                            v-html="link.label"
                                        />
                                        <span v-else class="page-link" v-html="link.label"></span>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
