<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Trash, Pencil } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    bagages: Object, // ✅ c’est un objet paginé, pas Array !
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
            route("bagage.index"),
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
const editBagage = (id) => {
    router.visit(route("bagage.edit", id));
};

// 🗑️ Suppression avec confirmation
const deleteBagage = (id) => {
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
            router.delete(route("bagage.destroy", id), {
                onSuccess: () => {
                    Swal.fire(
                        "Supprimé !",
                        "Le Colis a été supprimé avec succès.",
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
                    <h4 class="page-title">Gestion des Colis</h4>
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

        <!-- 📋 Tableau des bagages -->
        <div class="row">
            <div class="col-lg-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <!-- Titre -->
                        <div class="d-flex justify-content-between">
                            <h4 class="card-title mb-0">Liste des Colis</h4>
                        </div>

                        <!-- Message flash -->
                        <div
                            v-if="props.flash.success"
                            class="alert alert-success"
                        >
                            {{ props.flash.success }}
                        </div>

                        <!-- ➕ Bouton création -->
                        <div class="pt-4 pb-4">
                            <Link
                                type="button"
                                :href="route('bagage.create')"
                                class="btn btn-primary toolbar-item mt-3"
                            >
                                Nouveau Colis
                            </Link>
                        </div>

                        <!-- Formulaire -->
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Expéditeur</th>
                                        <th>Destinataire</th>
                                        <th>Poids</th>
                                        <th>Tarif</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(bagage, index) in bagages.data"
                                        :key="bagage.id"
                                    >
                                        <td class="py-1">{{ index + 1 }}</td>
                                        <td>{{ bagage.user1 }}</td>
                                        <td>{{ bagage.user2 }}</td>
                                        <td>{{ bagage.poids }}</td>
                                        <td>{{ bagage.tarif }}</td>
                                        <td>{{ bagage.statut }}</td>
                                        <td>
                                            <button
                                                @click="editBagage(bagage.id)"
                                                class="btn btn-warning toolbar-item m-2"
                                            >
                                                <Pencil size="16" />
                                            </button>
                                            <button
                                                @click="deleteBagage(bagage.id)"
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
                                    v-for="link in bagages.links"
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
