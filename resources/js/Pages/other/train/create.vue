<script setup>
import AppLayout from "@/layouts/AppLayout.vue";
import { ref } from 'vue';
import { useForm } from '@inertiajs/vue3';

// Initialisation du formulaire
const form = useForm({
  nom: '',
  capacite: '',
  etat: '',
});

// Fonction d'envoi du formulaire
const submit = () => {
  form.post(route('train.store'), {
    onSuccess: () => {
      alert('Train ajoutée avec succès !');
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
                            <h4 class="page-title">Nouveau Train</h4>
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
                        <h4 class="card-title">Formulaire de d'ajout de train</h4>
                        <!-- <p class="card-description"> Basic form layout </p> -->
                        <form class="forms-sample" @submit.prevent="submit">
                            <!-- Nom -->
                          <div class="form-group">
                            <label for="nom">Nom du train</label>
                            <input type="text" class="form-control" id="" v-model="form.nom" placeholder="Entrer Nom">
                          </div>
                          <!-- Capacité -->
                          <div class="form-group">
                            <label for="capacite">Capacité du train</label>
                            <input type="number" class="form-control" id="" v-model="form.capacite" placeholder="Entrer Capacité">
                          </div>
                          <!-- Etat -->
                          <div class="form-group">
                            <label for="exampleInputPassword1">Etat du train</label>
                            <select class="form-control" v-model="form.etat">
                                <option value=""> -- Choisissez un etat -- </option>
                                <option value='actif'>Actif</option>
                                <option value='en_maintenance'>Maintenance</option>
                            </select>
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
