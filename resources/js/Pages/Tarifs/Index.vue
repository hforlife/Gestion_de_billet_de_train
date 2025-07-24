<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Plus, Pencil, Trash } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    tarifs: Object,
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
    (val) => {
        router.get(
            route("tarif.index"),
            { search: val },
            { preserveState: true, replace: true }
        );
    }
);

// ⚡ Notification flash
if (props.flash?.success) {
    Swal.fire("Succès", props.flash.success, "success");
}

// ✏️ Redirection vers édition
const editTarif = (id) => {
    router.visit(route("tarif.edit", id));
};

// 🗑️ Suppression avec confirmation
const deleteTarif = (id) => {
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
            router.delete(route("tarif.destroy", id), {
                onSuccess: () =>
                    Swal.fire("Supprimé", "Le tarif a été supprimé.", "success"),
            });
        }
    });
};
</script>

<template>
    <AppLayout>
        <!-- 🧭 Titre et liens -->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Gestion des Tarifs</h4>
                    <div class="quick-link-wrapper w-100 d-md-flex flex-md-wrap">
                        <ul class="quick-links ml-auto">
                            <li><Link :href="route('dashboard')">Tableau de bord</Link></li>
                            <li><a href="#">Tarifs</a></li>
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
                    placeholder="Rechercher un tarif..."
                    class="form-control"
                />
            </div>
        </div>

        <!-- 📋 Tableau des tarifs -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <!-- 🔼 Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="card-title mb-0">Liste des Tarifs</h4>
                            <Link :href="route('tarif.create')" class="btn btn-primary btn-icon-text">
                                <Plus size="16" class="me-1" />
                                Nouveau Tarif
                            </Link>
                        </div>

                        <!-- ✅ Message flash -->
                        <div v-if="props.flash.success" class="alert alert-success">
                            {{ props.flash.success }}
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>Ligne</th>
                                        <th>Classe</th>
                                        <th>Prix</th>
                                        <th>Période</th>
                                        <th class="text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(tarif, index) in tarifs.data" :key="tarif.id">
                                        <td>{{ tarif.ligne.nom }}</td>
                                        <td>{{ tarif.classe_wagon.classe }}</td>
                                        <td>{{ tarif.prix_base }} FCFA</td>
                                        <td>
                                            {{ new Date(tarif.date_effet).toLocaleDateString() }} -
                                            {{
                                                tarif.date_expiration
                                                    ? new Date(tarif.date_expiration).toLocaleDateString()
                                                    : "∞"
                                            }}
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group">
                                                <button class="btn btn-warning btn-sm" @click="editTarif(tarif.id)">
                                                    <Pencil size="16" />
                                                </button>
                                                <button class="btn btn-danger btn-sm" @click="deleteTarif(tarif.id)">
                                                    <Trash size="16" />
                                                </button>
                                            </div>
                                        </td>
                                    </tr>

                                    <tr v-if="tarifs.data.length === 0">
                                        <td colspan="5" class="text-center py-4 text-muted">
                                            Aucun tarif trouvé.
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 📄 Pagination -->
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <p class="text-muted">
                                    Affichage de {{ tarifs.from }} à {{ tarifs.to }} sur {{ tarifs.total }} tarifs
                                </p>
                            </div>
                            <div class="col-md-6">
                                <nav class="float-end">
                                    <ul class="pagination">
                                        <li
                                            v-for="link in tarifs.links"
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
                                            <span v-else class="page-link" v-html="link.label"></span>
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
