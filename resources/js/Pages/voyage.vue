<script setup>
import AppLayout from "@/layouts/AppLayout.vue";
import { defineProps } from "vue";
import { router } from "@inertiajs/vue3";
import { Trash } from "lucide-vue-next";
import { Pencil } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    voyages: Array,
});

if (props.flash && props.flash.success) {
  Swal.fire(
    'Succès',
    props.flash.success,
    'success'
  )
}

// Fonction pour rediriger vers la page d’édition avec l'ID
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
                        "Le Voyage a été supprimée avec succès.",
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
        <div class="main-panel">
            <div class="content-wrapper">
                <!-- Page Title Header Starts-->
                <div class="row page-title-header">
                    <div class="col-12">
                        <div class="page-header">
                            <h4 class="page-title">Gestion des Voyages</h4>
                        </div>
                    </div>
                </div>
                <!-- Page Title Header Ends-->
                <div class="row">
                    <div class="col-lg-12 grid-margin stretch-card">
                        <div class="card">
                            <div class="card-body">
                                <h4 class="card-title">Liste des Voyages</h4>
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Train</th>
                                            <th>Gare de Depart</th>
                                            <th>Gare d'Arrivée</th>
                                            <th>Date Depart</th>
                                            <th>Date Arrivée</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr
                                            v-for="(voyage, index) in voyages"
                                            :key="voyage.id"
                                        >
                                            <td class="py-1">
                                                {{ index + 1 }}
                                            </td>
                                            <td>{{ voyage.train_id }}</td>
                                            <td>{{ voyage.gare_depart }}</td>
                                            <td>{{ voyage.gare_arrivee }}</td>
                                            <td>{{ voyage.date_depart }}</td>
                                            <td>{{ voyage.date_arrivee }}</td>
                                            <td>{{ voyage.status }}</td>
                                            <td>
                                                <button
                                                    @click="
                                                        editVoyage(voyage.id)
                                                    "
                                                    class="btn btn-warning toolbar-item m-2"
                                                >
                                                    <Pencil />
                                                </button>
                                                <button
                                                    @click="
                                                        deleteVoyage(voyage.id)
                                                    "
                                                    class="btn btn-danger toolbar-item"
                                                >
                                                    <Trash />
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <Link
                    type="button"
                    :href="route('voyage.create')"
                    class="btn btn-primary toolbar-item"
                    >Nouveau Voyage</Link
                >
            </div>
        </div>
    </AppLayout>
</template>
