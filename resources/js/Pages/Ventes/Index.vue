<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Pencil, Trash, Eye, Plus } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    ventes: Object,
    voyages: Array,
    filters: Object,
    flash: Object,
});

const filters = reactive({
    search: props.filters?.search || "",
    voyage_id: props.filters?.voyage_id || "",
});

const getResults = () => {
    router.get(route("vente.index"), filters, {
        preserveState: true,
        preserveScroll: true,
        replace: true,
    });
};

watch(filters, () => getResults(), { deep: true });

if (props.flash?.success) {
    Swal.fire({
        title: "Succès",
        text: props.flash.success,
        icon: "success",
        timer: 3000,
    });
}

const showVente = (id) => {
    router.visit(route("vente.show", id));
};

const deleteVente = (id) => {
    Swal.fire({
        title: "Confirmer la suppression",
        text: "Cette action est irréversible !",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d33",
        cancelButtonColor: "#3085d6",
        confirmButtonText: "Supprimer",
        cancelButtonText: "Annuler",
    }).then((result) => {
        if (result.isConfirmed) {
            router.delete(route("vente.destroy", id), {
                onSuccess: () => {
                    Swal.fire(
                        "Supprimé !",
                        "La vente a été supprimée.",
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
                    <h4 class="page-title">Gestion des Ventes</h4>
                    <div
                        class="quick-link-wrapper w-100 d-md-flex flex-md-wrap"
                    >
                        <ul class="quick-links ml-auto">
                            <li><a href="#">Tableau de bord</a></li>
                            <li><a href="#">Ventes</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- 🔍 Barre de recherche & Filtre -->
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="input-group">
                    <select v-model="filters.voyage_id" class="form-control">
                        <option value="">Tous les voyages</option>
                        <option
                            v-for="voyage in voyages"
                            :key="voyage.id"
                            :value="voyage.id"
                        >
                            {{ voyage.name }} ({{ voyage.date_depart }})
                        </option>
                    </select>
                </div>
            </div>
            <div class="col-md-6">
                <div class="input-group">
                    <input
                        type="text"
                        v-model="filters.search"
                        placeholder="Rechercher par client..."
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

        <!-- 📋 Tableau des Ventes -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div
                            class="d-flex justify-content-between align-items-center mb-4"
                        >
                            <h4 class="card-title mb-0">Liste des ventes</h4>
                            <Link
                                :href="route('vente.create')"
                                class="btn btn-primary btn-icon-text"
                            >
                                <Plus size="16" class="me-1" />
                                Nouvelle Vente
                            </Link>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Client</th>
                                        <th>Voyage</th>
                                        <th>Train</th>
                                        <th class="text-end">Prix</th>
                                        <th>Bagage</th>
                                        <th class="text-end">Quantité</th>
                                        <th class="text-end">Poids</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(vente, index) in ventes.data"
                                        :key="vente.id"
                                    >
                                        <td>{{ ventes.from + index }}</td>
                                        <td>{{ vente.client_nom || "---" }}</td>
                                        <td>
                                            <span v-if="vente.voyage">
                                                {{ vente.voyage.name }}
                                                <small
                                                    class="text-muted d-block"
                                                    >{{
                                                        vente.voyage.date_depart
                                                    }}</small
                                                >
                                            </span>
                                            <span v-else>---</span>
                                        </td>
                                        <td>
                                            {{ vente.train?.numero || "---" }}
                                        </td>
                                        <td class="text-end">
                                            {{
                                                vente.prix
                                                    ? `${vente.prix.toLocaleString()} FCFA`
                                                    : "---"
                                            }}
                                        </td>
                                        <td class="text-end">
                                            {{
                                                vente.quantite
                                                    ? `${vente.quantite} Billets`
                                                    : "---"
                                            }}
                                        </td>
                                        <td>
                                            <span
                                                :class="{
                                                    'badge bg-success':
                                                        vente.bagage,
                                                    'badge bg-secondary':
                                                        !vente.bagage,
                                                }"
                                            >
                                                {{
                                                    vente.bagage ? "Oui" : "Non"
                                                }}
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            {{
                                                vente.poids_bagage
                                                    ? `${vente.poids_bagage} kg`
                                                    : "---"
                                            }}
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group">
                                                <button
                                                    @click="showVente(vente.id)"
                                                    class="btn btn-info btn-sm"
                                                    title="Voir détails"
                                                >
                                                    <Eye size="16" />
                                                </button>
                                                <Link
                                                    :href="
                                                        route(
                                                            'vente.edit',
                                                            vente.id
                                                        )
                                                    "
                                                    class="btn btn-warning btn-sm"
                                                    title="Modifier"
                                                >
                                                    <Pencil size="16" />
                                                </Link>
                                                <button
                                                    @click="
                                                        deleteVente(vente.id)
                                                    "
                                                    class="btn btn-danger btn-sm"
                                                    title="Supprimer"
                                                >
                                                    <Trash size="16" />
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr v-if="ventes.data.length === 0">
                                        <td
                                            colspan="8"
                                            class="text-center py-4 text-muted"
                                        >
                                            Aucune vente trouvée
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <p class="text-muted">
                                    Affichage de {{ ventes.from }} à
                                    {{ ventes.to }} sur
                                    {{ ventes.total }} ventes
                                </p>
                            </div>
                            <div class="col-md-6">
                                <nav class="float-end">
                                    <ul class="pagination">
                                        <li
                                            v-for="link in ventes.links"
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

<style scoped>
.table-hover tbody tr:hover {
    background-color: rgba(75, 73, 172, 0.05);
}
.badge {
    padding: 5px 10px;
    border-radius: 50px;
    font-weight: 500;
}
.btn-group {
    white-space: nowrap;
}
</style>
