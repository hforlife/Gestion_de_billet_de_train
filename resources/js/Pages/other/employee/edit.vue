<script setup>
import AppLayout from "@/layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import { defineProps } from "vue";
import Swal from "sweetalert2";

// Props reçues depuis le contrôleur
const props = defineProps({
    employee: Object,
    gares: Object,
    sections: Object, 
});

// Initialisation du formulaire avec les valeurs existantes
const form = useForm({
    name: props.employee?.name || '',
    section: props.employee?.section || '',
    salaire: props.employee?.salaire || '',
    date_de_debut: props.employee?.date_de_debut || '',
    gare_id: props.employee?.gare_id || '',
});

// Fonction d'envoi du formulaire
const submit = () => {
  form.put(route('employee.update', props.employee.id), {
    onSuccess: () => {
      Swal.fire(
        'Succès',
        'Employé(e) modifié(e) avec succès.',
        'success'
      )
    },
    onError: (errors) => {
      Swal.fire(
        'Erreur',
        'Merci de vérifier le formulaire.',
        'error'
      )
    }
  });
};
</script>

<template>
    <AppLayout>
        <!-- Page Title Header Starts-->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Modifier Employée</h4>
                </div>
            </div>
        </div>
        <!-- Page Title Header Ends-->
        <div></div>
        <!-- Fromulaire -->
        <div class="row flex-grow">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Formulaire de Section</h4>
                        <!-- <p class="card-description"> Basic form layout </p> -->
                        <form class="forms-sample" @submit.prevent="submit">
                            <!-- Name -->
                            <div class="form-group">
                                <label for="exampleInputEmail1"
                                    >Nom de l'employée</label
                                >
                                <input
                                    type="text"
                                    id="name"
                                    class="form-control"
                                    v-model="form.name"
                                    placeholder="Entrer Nom Employee"
                                />
                            </div>
                            <!-- Section -->
                            <div class="form-group">
                                <label for="exampleInputPassword1"
                                    >Section</label
                                >
                                <select
                                    class="form-control"
                                    v-model="form.section"
                                >
                                    <option value="" disabled>
                                        -- Choisissez une section --
                                    </option>
                                    <option
                                        v-for="section in sections"
                                        :key="section.id"
                                        :value="section.id"
                                    >
                                        {{ section.name }}
                                    </option>
                                </select>
                            </div>
                            <!-- Salaire -->
                            <div class="form-group">
                                <label for="exampleInputEmail1"
                                    >Salaire de l'employée</label
                                >
                                <input
                                    type="number"
                                    class="form-control"
                                    v-model="form.salaire"
                                    placeholder="Entrer Salaire Employée"
                                />
                            </div>
                            <!-- Date de debut -->
                            <div class="form-group">
                                <label for="exampleInputPassword1"
                                    >Date de Début d'emploi</label
                                >
                                <input
                                    type="date"
                                    class="form-control"
                                    v-model="form.date_de_debut"
                                />
                            </div>
                            <!-- Gare -->
                            <div class="form-group">
                                <label for="exampleInputPassword1">Gare</label>
                                <select
                                    class="form-control"
                                    v-model="form.gare_id"
                                >
                                    <option value="" disabled>
                                        -- Choisissez une gare --
                                    </option>
                                    <option
                                        v-for="gare in gares"
                                        :key="gare.id"
                                        :value="gare.id"
                                    >
                                        {{ gare.nom }}
                                    </option>
                                </select>
                            </div>
                            <!-- Btn -->
                            <button type="submit" class="btn btn-success mr-2">
                                Modifier
                            </button>
                            <button class="btn btn-light" type="reset">
                                Annuler
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <!-- Fin Formulaire -->
    </AppLayout>
</template>
