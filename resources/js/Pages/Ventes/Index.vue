<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Pencil, Trash, Eye } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    ventes: Object,
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
            route("gare.index"),
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
const editVente = (id) => {
    router.visit(route("vente.edit", id));
};
// suppression
const deleteVente = (id) => {
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
            router.delete(route("vente.destroy", id));
        }
    });
};
</script>

<template>
    <AppLayout>
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Gestion des Ventes</h4>
                </div>
            </div>
        </div>

        <div class="input-group filter mb-3">
            <select
                v-model="filters.voyage_id"
                @change="getResults"
                class="btn btn-outline-secondary dropdown-toggle"
                type="button"
                data-bs-toggle="dropdown"
                aria-expanded="false"
            >
                <option value="">Tous les voyages</option>
                <option
                    v-for="voyage in voyages"
                    :key="voyage.id"
                    :value="voyage.id"
                >
                    {{ voyage.name }}
                </option>
            </select>
            <input
                type="text"
                v-model="filters.search"
                @input="getResults"
                placeholder="Rechercher par nom..."
                class="form-control"
            />
        </div>

        <div class="row">
            <!-- table 3 -->
            <div class="col-lg-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <!-- Titre -->
                        <div class="d-flex justify-content-between">
                            <h4 class="card-title mb-0">
                                Listes des ventes effectuées
                            </h4>
                        </div>

                        <!-- Boutton -->
                        <div class="pt-4 pb-4">
                            <Link
                                type="button"
                                :href="route('vente.create')"
                                class="btn btn-primary toolbar-item"
                            >
                                Nouvelle Vente</Link
                            >
                        </div>

                        <!-- Formulaire -->
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Client</th>
                                        <th>Voyage</th>
                                        <th>Train</th>
                                        <th>Prix (FCFA)</th>
                                        <th>Bagage</th>
                                        <th>Poids</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(vente, index) in ventes.data"
                                        :key="vente.id"
                                    >
                                        <td>{{ index + 1 }}</td>
                                        <td>{{ vente.client_nom }}</td>
                                        <td>
                                            {{
                                                vente.voyage
                                                    ? vente.voyage.name
                                                    : "---"
                                            }}
                                        </td>
                                        <td>
                                            {{
                                                vente.train
                                                    ? vente.train.numero
                                                    : "---"
                                            }}
                                        </td>
                                        <td>
                                            {{
                                                vente.prix
                                                    ? vente.voyage.prix
                                                    : "---"
                                            }}
                                        </td>
                                        <td>
                                            {{ vente.bagage ? "Oui" : "Non" }}
                                        </td>
                                        <td>
                                            {{ vente.poids_bagage || "0" }} Kg
                                        </td>
                                        <td>
                                            <Link
                                                :href="
                                                    route(
                                                        'vente.edit',
                                                        vente.id
                                                    )
                                                "
                                                class="btn btn-warning btn-sm m-1"
                                            >
                                                <Pencil size="16" />
                                            </Link>
                                            <button
                                                @click="deleteVente(vente.id)"
                                                class="btn btn-danger btn-sm"
                                            >
                                                <Trash size="16" />
                                            </button>
                                            <!-- Modal -->
                                            <!-- button -->
                                            <button
                                                type="button"
                                                class="btn btn-primary btn-sm m-1"
                                                data-bs-toggle="modal"
                                                data-bs-target="#exampleModal"
                                                :data-bs-whatever="vente.id"
                                            >
                                                <Eye size="16" />
                                            </button>
                                            <!-- content -->
                                            <div
                                                class="modal fade"
                                                id="exampleModal"
                                                tabindex="-1"
                                                aria-labelledby="exampleModalLabel"
                                                aria-hidden="true"
                                            >
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div
                                                            class="modal-header"
                                                        >
                                                            <h5
                                                                class="modal-title"
                                                                id="exampleModalLabel"
                                                            >
                                                                Modal title
                                                            </h5>
                                                            <button
                                                                type="button"
                                                                class="btn-close"
                                                                data-bs-dismiss="modal"
                                                                aria-label="Close"
                                                            ></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            ...
                                                        </div>
                                                        <div
                                                            class="modal-footer"
                                                        >
                                                            <button
                                                                type="button"
                                                                class="btn btn-secondary"
                                                                data-bs-dismiss="modal"
                                                            >
                                                                Fermer
                                                            </button>
                                                            <button
                                                                type="button"
                                                                class="btn btn-primary"
                                                            >
                                                                Modifier
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="pagination mt-4">
                            <nav>
                                <ul class="pagination">
                                    <li
                                        v-for="link in ventes.links"
                                        :key="link.label"
                                        :class="{
                                            'page-item active': link.active,
                                            'page-item': !link.active,
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
    </AppLayout>
</template>
