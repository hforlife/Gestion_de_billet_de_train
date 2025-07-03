<script setup>
import AppLayout from "@/layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { defineProps } from "vue";

// Props depuis le contrôleur
const props = defineProps({
  arret: Object,
  voyages: Array,
  gares: Array,
});

// Initialisation du formulaire avec les données de l’arrêt
const form = useForm({
  voyage_id: props.arret.voyage_id,
  gare_id: props.arret.gare_id,
  heure_arrivee: props.arret.heure_arrivee,
  heure_depart: props.arret.heure_depart,
});

// Fonction de mise à jour
const submit = () => {
  form.put(route("arret.update", props.arret.id), {
    onSuccess: () => {
      Swal.fire("Succès", "Arrêt modifié avec succès.", "success");
    },
    onError: () => {
      Swal.fire("Erreur", "Merci de vérifier les champs du formulaire.", "error");
    },
  });
};
</script>

<template>
  <AppLayout>
    <div class="row page-title-header">
      <div class="col-12">
        <div class="page-header">
          <h4 class="page-title">Modifier un Arrêt</h4>
        </div>
      </div>
    </div>

    <div class="row flex-grow">
      <div class="col-12">
        <div class="card">
          <div class="card-body">
            <h4 class="card-title">Formulaire Arrêt</h4>

            <form class="forms-sample" @submit.prevent="submit">
              <!-- Voyage -->
              <div class="form-group">
                <label for="voyage">Voyage</label>
                <select
                  v-model="form.voyage_id"
                  class="form-control"
                >
                  <option value="" disabled>-- Sélectionner un voyage --</option>
                  <option
                    v-for="voyage in voyages"
                    :key="voyage.id"
                    :value="voyage.id"
                  >
                    {{ voyage.name }}
                  </option>
                </select>
                <span v-if="form.errors.voyage_id" class="text-danger">
                  {{ form.errors.voyage_id }}
                </span>
              </div>

              <!-- Gare -->
              <div class="form-group">
                <label for="gare">Gare</label>
                <select
                  v-model="form.gare_id"
                  class="form-control"
                >
                  <option value="" disabled>-- Sélectionner une gare --</option>
                  <option
                    v-for="gare in gares"
                    :key="gare.id"
                    :value="gare.id"
                  >
                    {{ gare.nom }}
                  </option>
                </select>
                <span v-if="form.errors.gare_id" class="text-danger">
                  {{ form.errors.gare_id }}
                </span>
              </div>

              <!-- Heure d'arrivée -->
              <div class="form-group">
                <label for="heure_arrivee">Heure d’arrivée</label>
                <input
                  type="time"
                  class="form-control"
                  v-model="form.heure_arrivee"
                />
                <span v-if="form.errors.heure_arrivee" class="text-danger">
                  {{ form.errors.heure_arrivee }}
                </span>
              </div>

              <!-- Heure de départ -->
              <div class="form-group">
                <label for="heure_depart">Heure de départ</label>
                <input
                  type="time"
                  class="form-control"
                  v-model="form.heure_depart"
                />
                <span v-if="form.errors.heure_depart" class="text-danger">
                  {{ form.errors.heure_depart }}
                </span>
              </div>

              <!-- Boutons -->
              <div class="d-flex justify-content-end mt-4">
                <button
                  type="reset"
                  class="btn btn-light mr-2"
                  @click="form.reset()"
                >
                  Annuler
                </button>
                <button
                  type="submit"
                  class="btn btn-primary"
                  :disabled="form.processing"
                >
                  <span
                    v-if="form.processing"
                    class="spinner-border spinner-border-sm"
                    role="status"
                    aria-hidden="true"
                  ></span>
                  {{ form.processing ? "En cours..." : "Valider" }}
                </button>
              </div>
            </form>

          </div>
        </div>
      </div>
    </div>
  </AppLayout>
</template>
