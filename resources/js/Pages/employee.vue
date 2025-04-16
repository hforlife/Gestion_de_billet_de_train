<script setup>
import AppLayout from "@/layouts/AppLayout.vue";
import { defineProps } from "vue";
import { router } from "@inertiajs/vue3";
import { Link } from "@inertiajs/vue3";
import { Trash } from "lucide-vue-next";
import { Pencil } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    employees: Array,
});

if (props.flash && props.flash.success) {
  Swal.fire(
    'Succès',
    props.flash.success,
    'success'
  )
}

// Fonction pour rediriger vers la page d’édition avec l'ID
const editEmployee = (id) => {
    router.visit(route('employee.edit', id));
};

const deleteEmployee = (id) => {
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
      router.delete(route('employee.destroy', id), {
        onSuccess: () => {
          Swal.fire(
            'Supprimé !',
            'L\'employé(e) a été supprimé(e) avec succès.',
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
                    <h4 class="page-title">Gestion des employées</h4>
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
                        <h4 class="card-title">Listes des employées</h4>
                        <!-- <p class="card-description">
                                    Add class <code>.table-striped</code>
                                </p> -->
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Nom</th>
                                    <th>Section</th>
                                    <th>Salaire</th>
                                    <th>Date de Debut</th>
                                    <th>Gare</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(employee, index) in employees"
                                    :key="employee.id"
                                >
                                    <td class="py-1">{{ index + 1 }}</td>
                                    <td>{{ employee.name }}</td>
                                    <td>{{ employee.section }}</td>
                                    <td>{{ employee.salaire }}</td>
                                    <td>{{ employee.date_de_debut }}</td>
                                    <td>{{ employee.gare_id }}</td>
                                    <td>
                                        <button
                                            @click="editEmployee(employee.id)"
                                            class="btn btn-warning toolbar-item m-2"
                                        >
                                            <Pencil />
                                        </button>
                                        <button
                                            @click="deleteEmployee(employee.id)"
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
            <Link
                type="button"
                :href="route('employee.create')"
                class="btn btn-primary toolbar-item"
                >Nouvel Employée</Link
            >
            <!-- Fin Tableau -->
        </div>
    </AppLayout>
</template>
