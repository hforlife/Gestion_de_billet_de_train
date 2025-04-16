<script setup>
import AppLayout from "@/layouts/AppLayout.vue";
import { ref } from 'vue';
import { useForm } from '@inertiajs/inertia-vue3';

// Initialisation du formulaire
const form = useForm({
  user1: '',
  user2: '',
  poids: '',
  tarif: '',
  statut: '',
});

// Fonction d'envoi du formulaire
const submit = () => {
  form.post('/bagage-store', {
    onSuccess: () => {
      alert('Colis ajoutée avec succès !');
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
                            <h4 class="page-title">Gestion des Colis</h4>
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
                        <h4 class="card-title">Formulaire Colis</h4>
                        <!-- <p class="card-description"> Basic form layout </p> -->
                        <form class="forms-sample" @submit.prevent="submit">
                          <div class="form-group">
                            <label for="exampleInputEmail1">Nom de l'expéditeur</label>
                            <input type="text" id="user1" class="form-control" v-model="form.user1" placeholder="Entrer Nom Expéditeur">
                          </div>
                          <div class="form-group">
                            <label for="exampleInputEmail1">Nom du destinataire</label>
                            <input type="text" class="form-control" id="user2" v-model="form.user2" placeholder="Entrer Destinataire">
                          </div>
                          <div class="form-group">
                            <label for="exampleInputPassword1">Poids du colis</label>
                            <input type="number" id="poids" class="form-control" v-model="form.poids" placeholder="Entrer Poids">
                          </div>
                          <div class="form-group">
                            <label for="exampleInputPassword1">Prix d'expédition</label>
                            <input type="number" id="tarif" class="form-control" v-model="form.tarif" placeholder="Entrer Prix">
                          </div>
                          <div class="form-group">
                            <label for="exampleInputPassword1">Status</label>
                            <select class="form-control" v-model="form.statut">
                                <option disable selected> -- Choisissez un status -- </option>
                                <option value='enregistré'>Enrégistrer</option>
                                <option value='perdu'>Perdu</option>
                                <option value='livré'>Livré</option>
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