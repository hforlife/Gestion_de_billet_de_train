<script setup>
import { defineProps, ref, computed } from 'vue'
import { useForm } from '@inertiajs/vue3'
import Swal from 'sweetalert2'
import AppLayout from "@/Layouts/AppLayout.vue";

const props = defineProps({
    voyages: Array,
    trains: Array // Ajout des trains disponibles
})

const form = useForm({
  client_nom: '',
  voyage_id: null,
  train_id: null,
  prix: 0,
  quantite: 1,
  bagage: false,
  poids_bagage: 0
})

const panier = ref([])
const selectedVoyage = ref(null)

// Calcul du total
const total = computed(() => {
  if (!selectedVoyage.value) return 0
  return selectedVoyage.value.prix * form.quantite
})

// Sélection d'un voyage
const selectVoyage = (voyage) => {
  selectedVoyage.value = voyage
  form.voyage_id = voyage.id
  form.prix = voyage.prix
  form.quantite = 1
  form.train_id = null // Réinitialiser la sélection du train
}

// Soumission du formulaire
const submit = async () => {
  // Validation
  if (!selectedVoyage.value) {
    await Swal.fire('Voyage non sélectionné', 'Veuillez sélectionner un voyage', 'warning')
    return
  }

  if (!form.train_id) {
    await Swal.fire('Train non sélectionné', 'Veuillez sélectionner un train', 'warning')
    return
  }

  if (form.bagage && !form.poids_bagage) {
    await Swal.fire('Poids manquant', 'Veuillez saisir le poids du bagage', 'warning')
    return
  }

  try {
    await form.post(route('vente.store'), {
      preserveScroll: true,
      onSuccess: () => {
        Swal.fire({
          title: 'Succès',
          text: 'Billet vendu avec succès',
          icon: 'success',
          showCancelButton: true,
          confirmButtonText: 'Voir les ventes',
          cancelButtonText: 'Fermer'
        }).then((result) => {
          if (result.isConfirmed) {
            window.location.href = route('vente.index')
          }
        })
        form.reset()
        selectedVoyage.value = null
      },
      onError: (errors) => {
        let message = 'Une erreur est survenue'
        if (errors.train_id) message = errors.train_id
        else if (errors.voyage_id) message = 'Problème avec le voyage sélectionné'
        Swal.fire('Erreur', message, 'error')
      }
    })
  } catch (error) {
    console.error('Erreur:', error)
    Swal.fire('Erreur', 'Problème de connexion au serveur', 'error')
  }
}
</script>

<template>
    <AppLayout>
      <div class="container-fluid">
        <div class="row">
          <!-- Colonne Gauche : Sélection du voyage -->
          <div class="col-md-6 p-4">
            <h4 class="mb-4">Sélection du Voyage</h4>

            <div class="row">
              <div
                v-for="voyage in voyages"
                :key="voyage.id"
                class="col-md-6 mb-3"
              >
                <div
                  class="card h-100"
                  :class="{ 'border-primary': selectedVoyage?.id === voyage.id }"
                  @click="selectVoyage(voyage)"
                  style="cursor: pointer"
                >
                  <div class="card-body">
                    <h5>{{ voyage.name }}</h5>
                    <p class="text-muted">
                      <i class="fas fa-train"></i> {{ voyage.gare_depart.name }} →
                      {{ voyage.gare_arrivee.name }}
                    </p>
                    <p class="h5 text-primary">
                      {{ voyage.prix.toLocaleString() }} FCFA
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Colonne Droite : Formulaire de vente -->
          <div class="col-md-6 p-4 bg-light">
            <h4 class="mb-4">Détails de la Vente</h4>

            <div v-if="selectedVoyage" class="card mb-4">
              <div class="card-body">
                <h5>Voyage sélectionné</h5>
                <p><strong>{{ selectedVoyage.name }}</strong></p>
                <p>De {{ selectedVoyage.gare_depart.name }} à {{ selectedVoyage.gare_arrivee.name }}</p>
                <p class="h5">Prix unitaire: {{ selectedVoyage.prix.toLocaleString() }} FCFA</p>
              </div>
            </div>

            <div class="card">
              <div class="card-body">
                <form @submit.prevent="submit">
                  <div class="mb-3">
                    <label class="form-label">Nom du client</label>
                    <input
                      v-model="form.client_nom"
                      class="form-control"
                      required
                    />
                  </div>

                  <div class="mb-3">
                    <label class="form-label">Train</label>
                    <select
                      v-model="form.train_id"
                      class="form-control"
                      required
                    >
                      <option value="">Sélectionnez un train</option>
                      <option
                        v-for="train in trains"
                        :key="train.id"
                        :value="train.id"
                      >
                        {{ train.name }} {{ train.numero }}
                      </option>
                    </select>
                  </div>

                  <div class="mb-3">
                    <label class="form-label">Quantité</label>
                    <input
                      type="number"
                      v-model.number="form.quantite"
                      min="1"
                      class="form-control"
                      required
                    />
                  </div>

                  <div class="mb-3 form-check">
                    <input
                      type="checkbox"
                      v-model="form.bagage"
                      class="form-check-input"
                      id="bagageCheck"
                    />
                    <label class="form-check-label" for="bagageCheck">Avec bagage</label>
                  </div>

                  <div v-if="form.bagage" class="mb-3">
                    <label class="form-label">Poids du bagage (kg)</label>
                    <input
                      type="number"
                      v-model.number="form.poids_bagage"
                      min="0"
                      step="0.1"
                      class="form-control"
                      :required="form.bagage"
                    />
                  </div>

                  <div class="mb-3 p-3 bg-white rounded">
                    <h5>Total: {{ total.toLocaleString() }} FCFA</h5>
                  </div>

                  <button
                    type="submit"
                    class="btn btn-primary w-100 py-2"
                    :disabled="form.processing || !selectedVoyage"
                  >
                    <span v-if="form.processing">
                      <span class="spinner-border spinner-border-sm" role="status"></span>
                      Enregistrement...
                    </span>
                    <span v-else>
                      Valider la vente
                    </span>
                  </button>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </AppLayout>
</template>
