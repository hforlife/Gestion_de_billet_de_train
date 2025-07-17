<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import { computed } from "vue";
import Swal from "sweetalert2";

const props = defineProps({
    gares: Array,
    trains: Array,
    joursSemaine: Array // Ajout des jours depuis le contrôleur
});

const form = useForm({
    name: "",
    train_id: "",
    gare_depart_id: "",
    gare_arrivee_id: "",
    jours: [], // Note: changé de 'jour' à 'jours' pour cohérence avec le pluriel
    heure_depart: "",
    prix: "",
    statut: "actif",
});

// Jours de la semaine
const joursSemaine = [
                     { id: 1, nom:'Lundi' },
                     { id: 2, nom:'Mardi' },
                     { id: 3, nom:'Mercredi' },
                     { id: 4, nom:'Jeudi' },
                     { id: 5, nom:'Vendredi' },
                     { id: 6, nom:'Samedi' },
                     { id: 7, nom:'Dimanche' }
                    ];

// Filtre les gares d'arrivée disponibles
const garesArriveeDisponibles = computed(() => {
    return props.gares.filter(gare => gare.id !== form.gare_depart_id);
});

const submit = () => {
    form.post(route("voyage-reccurent.store"), {
        preserveScroll: true,
        onSuccess: () => {
            Swal.fire({
                toast: true,
                position: 'top-end',
                icon: 'success',
                title: 'Voyages récurrents créés avec succès',
                showConfirmButton: false,
                timer: 3000
            });
            form.reset();
        },
        onError: () => {
            Swal.fire({
                icon: 'error',
                title: 'Erreur',
                text: 'Veuillez vérifier les erreurs dans le formulaire',
            });
        },
    });
};
</script>

<template>
    <AppLayout>
        <div class="container py-4">
            <div class="row justify-content-center">
                <div class="col-md-10">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h3 class="mb-0">Créer un Voyage Récurrent</h3>
                        </div>

                        <div class="card-body">
                            <form @submit.prevent="submit">
                                <!-- Nom du voyage -->
                                <div class="mb-3">
                                    <label class="form-label">Nom du Voyage <span class="text-danger">*</span></label>
                                    <input
                                        v-model="form.name"
                                        type="text"
                                        class="form-control"
                                        :class="{ 'is-invalid': form.errors.name }"
                                        placeholder="Ex: Bamako-Kayes (Lundi)"
                                    >
                                    <div v-if="form.errors.name" class="invalid-feedback">
                                        {{ form.errors.name }}
                                    </div>
                                </div>

                                <!-- Train -->
                                <div class="mb-3">
                                    <label class="form-label">Train <span class="text-danger">*</span></label>
                                    <select
                                        v-model="form.train_id"
                                        class="form-control"
                                        :class="{ 'is-invalid': form.errors.train_id }"
                                    >
                                        <option value="" disabled>-- Sélectionner un train --</option>
                                        <option v-for="train in trains" :key="train.id" :value="train.id">
                                            Train N°{{ train.numero }}
                                        </option>
                                    </select>
                                    <div v-if="form.errors.train_id" class="invalid-feedback">
                                        {{ form.errors.train_id }}
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Gare de départ -->
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Gare de départ <span class="text-danger">*</span></label>
                                        <select
                                            v-model="form.gare_depart_id"
                                            class="form-control"
                                            :class="{ 'is-invalid': form.errors.gare_depart_id }"
                                        >
                                            <option value="" disabled>-- Sélectionner une gare --</option>
                                            <option v-for="gare in gares" :key="gare.id" :value="gare.id">
                                                {{ gare.nom }}
                                            </option>
                                        </select>
                                        <div v-if="form.errors.gare_depart_id" class="invalid-feedback">
                                            {{ form.errors.gare_depart_id }}
                                    </div>
                                    </div>

                                    <!-- Gare d'arrivée -->
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Gare d'arrivée <span class="text-danger">*</span></label>
                                        <select
                                            v-model="form.gare_arrivee_id"
                                            class="form-control"
                                            :class="{ 'is-invalid': form.errors.gare_arrivee_id }"
                                            :disabled="!form.gare_depart_id"
                                        >
                                            <option value="" disabled>-- Sélectionner une gare --</option>
                                            <option
                                                v-for="gare in garesArriveeDisponibles"
                                                :key="gare.id"
                                                :value="gare.id"
                                            >
                                                {{ gare.nom }}
                                            </option>
                                        </select>
                                        <div v-if="form.errors.gare_arrivee_id" class="invalid-feedback">
                                            {{ form.errors.gare_arrivee_id }}
                                        </div>
                                    </div>
                                </div>

                                  <!-- Jours de circulation -->
                                <div class="mb-3">
                                    <label class="form-label">Jours de circulation <span class="text-danger">*</span></label>
                                    <div class="d-flex flex-wrap gap-3">
                                        <div v-for="jour in props.joursSemaine" :key="jour.id" class="form-check">
                                            <input
                                                :id="`jour-${jour.id}`"
                                                v-model="form.jours"
                                                type="checkbox"
                                                class="form-check-input"
                                                :value="jour.id"
                                                :class="{ 'is-invalid': form.errors.jours }"
                                            >
                                            <label :for="`jour-${jour.id}`" class="form-check-label">
                                                {{ jour.nom }}
                                            </label>
                                        </div>
                                    </div>
                                    <div v-if="form.errors.jours" class="invalid-feedback d-block">
                                        {{ form.errors.jours }}
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Heure de départ -->
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Heure de départ <span class="text-danger">*</span></label>
                                        <input
                                            v-model="form.heure_depart"
                                            type="time"
                                            class="form-control"
                                            :class="{ 'is-invalid': form.errors.heure_depart }"
                                        >
                                        <div v-if="form.errors.heure_depart" class="invalid-feedback">
                                            {{ form.errors.heure_depart }}
                                        </div>
                                    </div>

                                    <!-- Prix -->
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Prix du billet <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <input
                                                v-model="form.prix"
                                                type="number"
                                                class="form-control"
                                                :class="{ 'is-invalid': form.errors.prix }"
                                                placeholder="Ex: 5000"
                                            >
                                            <span class="input-group-text">FCFA</span>
                                        </div>
                                        <div v-if="form.errors.prix" class="invalid-feedback">
                                            {{ form.errors.prix }}
                                        </div>
                                    </div>
                                </div>

                                <!-- Bouton de soumission -->
                                <div class="d-flex justify-content-end mt-4">
                                    <button
                                        type="submit"
                                        class="btn btn-primary"
                                        :disabled="form.processing"
                                    >
                                        <span v-if="form.processing" class="spinner-border spinner-border-sm me-2"></span>
                                        {{ form.processing ? 'Création en cours...' : 'Créer les voyages' }}
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
.form-check {
    min-width: 100px;
}

.card-header {
    padding: 1rem 1.5rem;
}

.invalid-feedback {
    display: none;
    width: 100%;
    margin-top: 0.25rem;
    font-size: 0.875em;
    color: #dc3545;
}

.is-invalid ~ .invalid-feedback,
.is-invalid ~ .invalid-feedback.d-block {
    display: block;
}
</style>
