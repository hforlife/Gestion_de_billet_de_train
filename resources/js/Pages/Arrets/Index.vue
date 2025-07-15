<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Pencil, Trash, Eye, Plus } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    arrets: Object, // ✅ c’est un objet paginé, pas Array !
    filters: Object,
    flash: Object, // ✅ pour les messages flash
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
            route("arret.index"),
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
const editArret = (id) => {
    router.visit(route("arret.edit", id));
};

// 🗑️ Suppression avec confirmation
const deleteArret = (id) => {
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
            router.delete(route("arret.destroy", id), {
                onSuccess: () => {
                    Swal.fire(
                        "Supprimé !",
                        "L'arret a été supprimé avec succès.",
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
                    <h4 class="page-title">Gestion des Arrets</h4>
                    <div
                        class="quick-link-wrapper w-100 d-md-flex flex-md-wrap"
                    >
                        <ul class="quick-links ml-auto">
                            <li><Link :href="route('dashboard')">Tableau de bord</Link></li>
                            <li><a href="#">Arrets</a></li>
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
                        placeholder="Rechercher par nom expediteur ou destinataire..."
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

        <!-- 📋 Tableau des bagages -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <!-- Titre -->
                        <div
                            class="d-flex justify-content-between align-items-center mb-4"
                        >
                            <h4 class="card-title mb-0">Liste des Arrets</h4>
                            <!-- ➕ Bouton création -->
                            <Link
                                :href="route('arret.create')"
                                class="btn btn-primary btn-icon-text"
                            >
                                <Plus size="16" class="me-1" />
                                Nouvel Arret
                            </Link>
                        </div>

                        <!-- Message flash -->
                        <div
                            v-if="props.flash.success"
                            class="alert alert-success"
                        >
                            {{ props.flash.success }}
                        </div>

                        <!-- Formulaire -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Voyage</th>
                                        <th>Gare</th>
                                        <th>Heure de D'arrivée</th>
                                        <th>Heure de Depart</th>
                                        <th>Ordre</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(arret, index) in arrets.data"
                                        :key="arret.id"
                                    >
                                        <td class="py-1">{{ index + 1 }}</td>
                                        <td>{{ arret.voyage.name }}</td>
                                        <td>{{ arret.gare.nom }}</td>
                                        <td>{{ arret.heure_arrivee }}</td>
                                        <td>{{ arret.heure_depart }}</td>
                                        <td>{{ arret.ordre }}</td>
                                        <td>{{ arret.statut }}</td>
                                        <td>
                                            <div class="btn-group">
                                                <button
                                                    @click="
                                                        editArret(arret.id)
                                                    "
                                                    class="btn btn-warning btn-sm"
                                                >
                                                    <Pencil size="16" />
                                                </button>
                                                <button
                                                    @click="
                                                        deleteArret(arret.id)
                                                    "
                                                    class="btn btn-danger btn-sm"
                                                >
                                                    <Trash size="16" />
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr v-if="arrets.data.length === 0">
                                        <td
                                            colspan="8"
                                            class="text-center py-4 text-muted"
                                        >
                                            Aucun arrets trouvé
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 📄 Pagination -->
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <p class="text-muted">
                                    Affichage de {{ arrets.from }} à
                                    {{ arrets.to }} sur
                                    {{ arrets.total }} arrets
                                </p>
                            </div>
                            <div class="col-md-6">
                                <nav class="float-end">
                                    <ul class="pagination">
                                        <li
                                            v-for="link in arrets.links"
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
                        <!-- End Pagination -->
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
