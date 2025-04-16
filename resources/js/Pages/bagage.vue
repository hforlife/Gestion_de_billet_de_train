<script setup>
import AppLayout from "@/layouts/AppLayout.vue";
import { defineProps } from "vue";
import { Link } from '@inertiajs/vue3';
import { router } from "@inertiajs/vue3";
import { Trash } from "lucide-vue-next";
import { Pencil } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    bagages: Array,
});

if (props.flash && props.flash.success) {
  Swal.fire(
    'Succès',
    props.flash.success,
    'success'
  )
}

const editBagage = (id) => {
    router.visit(route('bagage.edit', id))
}

const deleteBagage = (id) => {
  Swal.fire({
    title: 'Êtes-vous sûr ?',
    text: "Cette action est irréversible !",
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Oui, supprimer !',
    cancelButtonText: 'Annuler'
  }).then((result) => {
    if (result.isConfirmed) {
      router.delete(route('bagage.destroy', id), {
        onSuccess: () => {
          Swal.fire(
            'Supprimé !',
            'Le Colis a été supprimé avec succès.',
            'success'
          )
        }
      })
    }
  })
}
</script>

<template>
    <AppLayout>
        <!-- Page Title Header Starts-->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Gestion des Colis</h4>
                </div>
            </div>
        </div>
        <!-- Page Title Header Ends-->
        <div></div>
        <!-- Tables -->
        <div class="row">
            <!-- table 3 -->
            <div class="col-lg-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Listes des colis</h4>
                        <!-- <p class="card-description">
                                    Add class <code>.table-striped</code>
                                </p> -->
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
                                    v-for="(bagage, index) in bagages"
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
                                            ><Pencil /></button>
                                        <button
                                            @click="deleteBagage(bagage.id)"
                                            class="btn btn-danger toolbar-item"
                                            ><Trash /></button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <Link
                type="button"
                :href="route('bagage.create')"
                class="btn btn-primary toolbar-item"
                >Nouveau Colis</Link
            >
            <!-- Fin Tableau -->
        </div>
    </AppLayout>
</template>
