<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { defineProps } from "vue";

const props = defineProps({
  categorie: Object,
});

// Initialisation du formulaire avec les données existantes
const form = useForm({
  nom: props.categorie?.nom ?? '',
  description: props.categorie?.description ?? '',
});

// Soumission du formulaire
const submit = () => {
  form.put(route('categories-colis.update', props.categorie.id), {
    onSuccess: () => {
      Swal.fire(
        'Succès', 
        'Catégorie modifiée avec succès !', 
        'success'
      );
    },
    onError: () => {
      Swal.fire('Erreur', 'Veuillez vérifier les champs du formulaire.', 'error');
    }
  });
};
</script>

<template>
  <AppLayout>
    <!-- Titre -->
    <div class="row page-title-header">
      <div class="col-12">
        <div class="page-header">
          <h4 class="page-title">Modifier une Catégorie de Colis</h4>
        </div>
      </div>
    </div>

    <!-- Formulaire -->
    <div class="row flex-grow">
      <div class="col-12">
        <div class="card">
          <div class="card-body">
            <h4 class="card-title">Formulaire de modification</h4>
            <form class="forms-sample" @submit.prevent="submit">
              <!-- Nom -->
              <div class="form-group">
                <label for="nom">Nom de la catégorie</label>
                <input
                  type="text"
                  id="nom"
                  class="form-control"
                  v-model="form.nom"
                  placeholder="Ex : Documents, Marchandises, etc."
                  required
                />
                <div v-if="form.errors.nom" class="text-danger">
                  {{ form.errors.nom }}
                </div>
              </div>

              <!-- Description -->
              <div class="form-group">
                <label for="description">Description</label>
                <textarea
                  id="description"
                  class="form-control"
                  v-model="form.description"
                  placeholder="Description courte de la catégorie"
                  rows="3"
                  required
                ></textarea>
                <div v-if="form.errors.description" class="text-danger">
                  {{ form.errors.description }}
                </div>
              </div>

              <!-- Boutons -->
              <div class="d-flex justify-content-end mt-4">
                <button type="reset" class="btn btn-light mr-2" @click="form.reset()">
                  Annuler
                </button>
                <button type="submit" class="btn btn-primary" :disabled="form.processing">
                  <span
                    v-if="form.processing"
                    class="spinner-border spinner-border-sm"
                    role="status"
                    aria-hidden="true"
                  ></span>
                  {{ form.processing ? 'En cours...' : 'Valider' }}
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </AppLayout>
</template>
