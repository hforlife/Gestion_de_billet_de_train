<script setup>
import AppLayout from "@/layouts/AppLayout.vue";
import { ref } from 'vue';
import { useForm } from '@inertiajs/vue3';

// Initialisation du formulaire
const form = useForm({
  name: '',
  description: '',
});

// Fonction d'envoi du formulaire
const submit = () => {
  form.post(route('section.store'), {
    onSuccess: () => {
      alert('Section ajoutée avec succès !');
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
                            <h4 class="page-title">Nouvelle Section</h4>
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
                          <div class="form-group">
                            <label for="name">Nom de la section</label>
                            <input type="text" class="form-control" id="" v-model="form.name" placeholder="Entrer Nom">
                          </div>
                          <div class="form-group">
                            <label for="description">Description de la section</label>
                            <textarea id="" class="form-control" v-model="form.description" placeholder="Entrer Description"></textarea>
                          </div>
                          <button type="submit" class="btn btn-success mr-2">Ajouter</button>
                          <button class="btn btn-light" type="reset">Annuler</button>
                        </form>
                      </div>
                    </div>
                  </div>
                </div>
                 <!-- Fin Formulaire -->
    </AppLayout>
</template>