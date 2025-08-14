<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";

const props = defineProps({
  arret: Object,
  lignes: Array,
  gares: Array,
});

// Initialisation du formulaire avec les données existantes
const form = useForm({
  ligne_id: props.arret.ligne_id,
  gare_id: props.arret.gare_id,
  distance_depart: props.arret.distance_depart,
  vente_chef_train: props.arret.vente_chef_train,
  ordre: props.arret.ordre,
});

// Fonction de mise à jour
const update = () => {
  form.put(route("arret.update", props.arret.id), {
    onSuccess: () => {
      Swal.fire("Succès", "Arrêt modifié avec succès.", "success");
    },
    onError: () => {
      Swal.fire(
        "Erreur",
        "Merci de vérifier les champs du formulaire.",
        "error"
      );
    },
  });
};
</script>

<template>
  <AppLayout>
    <!-- En-tête -->
    <div class="row page-title-header">
      <div class="col-12">
        <div class="page-header">
          <h4 class="page-title">Modifier Arrêt</h4>
        </div>
      </div>
    </div>

    <!-- Formulaire -->
    <div class="row flex-grow">
      <div class="col-12">
        <div class="card">
          <div class="card-body">
            <h4 class="card-title">Formulaire de modification</h4>

            <form class="forms-sample" @submit.prevent="update">
              <!-- Ligne -->
              <div class="form-group">
                <label>Ligne</label>
                <select
                  v-model="form.ligne_id"
                  class="form-control"
                  required
                >
                  <option
                    v-for="ligne in lignes"
                    :key="ligne.id"
                    :value="ligne.id"
                    :selected="ligne.id === arret.ligne_id"
                  >
                    {{ ligne.nom }}
                  </option>
                </select>
                <span v-if="form.errors.ligne_id" class="text-danger">
                  {{ form.errors.ligne_id }}
                </span>
              </div>

              <!-- Gare -->
              <div class="form-group">
                <label>Gare</label>
                <select
                  v-model="form.gare_id"
                  class="form-control"
                  required
                >
                  <option
                    v-for="gare in gares"
                    :key="gare.id"
                    :value="gare.id"
                    :selected="gare.id === arret.gare_id"
                  >
                    {{ gare.nom }}
                  </option>
                </select>
                <span v-if="form.errors.gare_id" class="text-danger">
                  {{ form.errors.gare_id }}
                </span>
              </div>

              <!-- Distance départ -->
              <div class="form-group">
                <label>Distance Départ (km)</label>
                <input
                  type="number"
                  step="0.01"
                  min="0"
                  class="form-control"
                  v-model="form.distance_depart"
                  required
                />
                <span v-if="form.errors.distance_depart" class="text-danger">
                  {{ form.errors.distance_depart }}
                </span>
              </div>

              <!-- Vente chef de train -->
              <div class="form-group">
                <div class="form-check">
                  <input
                    type="checkbox"
                    class="form-check-input"
                    v-model="form.vente_chef_train"
                    id="venteChefTrain"
                  />
                  <label class="form-check-label" for="venteChefTrain">
                    Vente par le chef de train
                  </label>
                </div>
                <span v-if="form.errors.vente_chef_train" class="text-danger">
                  {{ form.errors.vente_chef_train }}
                </span>
              </div>

              <!-- Ordre -->
              <div class="form-group">
                <label>Ordre</label>
                <input
                  type="number"
                  min="1"
                  class="form-control"
                  v-model="form.ordre"
                  required
                />
                <span v-if="form.errors.ordre" class="text-danger">
                  {{ form.errors.ordre }}
                </span>
              </div>

              <!-- Boutons -->
              <div class="d-flex justify-content-end mt-4">
                <a
                  :href="route('arret.index')"
                  class="btn btn-light mr-2"
                >
                  Retour
                </a>
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
                  {{ form.processing ? "Enregistrement..." : "Mettre à jour" }}
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </AppLayout>
</template>
