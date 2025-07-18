<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { defineProps, computed } from "vue";

const props = defineProps({
    voyage: Object,
    gares: Array,
    trains: Array,
    joursSemaine: Array, // Ajoutez cette prop
});

// Convertir les jours existants en noms pour le template
const joursSelectionnes = computed(() => {
    return props.voyage.jours?.map((jour) => jour.nom) || [];
});

const form = useForm({
    name: props.voyage.name || "",
    train_id: props.voyage.train_id || "",
    gare_depart_id: props.voyage.gare_depart_id || "",
    gare_arrivee_id: props.voyage.gare_arrivee_id || "",
    jours: props.voyage.jours?.map((jour) => jour.id) || [], // Stocker les IDs
    heure_depart: props.voyage.heure_depart || "",
    prix: props.voyage.prix || "",
    statut: props.voyage.statut || "actif",
});

const toggleJour = (jourId) => {
    form.jours = form.jours.includes(jourId)
        ? form.jours.filter((id) => id !== jourId)
        : [...form.jours, jourId];
};

const submit = () => {
    form.put(route("voyage-reccurent.update", props.voyage.id), {
        preserveScroll: true,
        onSuccess: () => {
            Swal.fire(
                "Succès",
                "Voyage récurrent mis à jour avec succès.",
                "success"
            );
        },
        onError: () => {
            Swal.fire(
                "Erreur",
                "Une erreur est survenue, veuillez vérifier le formulaire.",
                "error"
            );
        },
    });
};
</script>

<template>
    <AppLayout>
        <div class="page-header">
            <h4 class="page-title">Modifier un Voyage Récurrent</h4>
        </div>

        <div class="card">
            <div class="card-body p-4">
                <form @submit.prevent="submit">
                    <!-- Nom -->
                    <div class="form-group mb-3">
                        <label>Nom du Voyage</label>
                        <input
                            v-model="form.name"
                            class="form-control"
                            required
                        />
                        <div class="text-danger" v-if="form.errors.name">
                            {{ form.errors.name }}
                        </div>
                    </div>

                    <!-- Train -->
                    <div class="form-group mb-3">
                        <label>Train</label>
                        <select
                            v-model="form.train_id"
                            class="form-control"
                            required
                        >
                            <option value="" disabled>
                                -- Sélectionner un train --
                            </option>
                            <option
                                v-for="train in trains"
                                :key="train.id"
                                :value="train.id"
                            >
                                Train N°{{ train.numero }}
                            </option>
                        </select>
                        <div class="text-danger" v-if="form.errors.train_id">
                            {{ form.errors.train_id }}
                        </div>
                    </div>

                    <!-- Gares -->
                    <div class="form-group mb-3">
                        <label>Gare de départ</label>
                        <select
                            v-model="form.gare_depart_id"
                            class="form-control"
                            required
                        >
                            <option value="" disabled>
                                -- Sélectionner --
                            </option>
                            <option
                                v-for="gare in gares"
                                :key="gare.id"
                                :value="gare.id"
                            >
                                {{ gare.nom }}
                            </option>
                        </select>
                        <div
                            class="text-danger"
                            v-if="form.errors.gare_depart_id"
                        >
                            {{ form.errors.gare_depart_id }}
                        </div>
                    </div>

                    <div class="form-group mb-3">
                        <label>Gare d'arrivée</label>
                        <select
                            v-model="form.gare_arrivee_id"
                            class="form-control"
                            required
                        >
                            <option value="" disabled>
                                -- Sélectionner --
                            </option>
                            <option
                                v-for="gare in gares"
                                :key="gare.id"
                                :value="gare.id"
                            >
                                {{ gare.nom }}
                            </option>
                        </select>
                        <div
                            class="text-danger"
                            v-if="form.errors.gare_arrivee_id"
                        >
                            {{ form.errors.gare_arrivee_id }}
                        </div>
                    </div>

                    <!-- Jours de départ - version corrigée -->
                    <div class="form-group mb-3">
                        <label>Jours de départ</label>
                        <div class="d-flex flex-wrap gap-2">
                            <button
                                v-for="jour in joursSemaine"
                                :key="jour.id"
                                type="button"
                                class="btn"
                                :class="{
                                    'btn-outline-primary': !form.jours.includes(
                                        jour.id
                                    ),
                                    'btn-primary': form.jours.includes(jour.id),
                                }"
                                @click="toggleJour(jour.id)"
                            >
                                {{ jour.nom }}
                            </button>
                        </div>
                        <div class="text-danger" v-if="form.errors.jours">
                            {{ form.errors.jours }}
                        </div>
                    </div>

                    <!-- Heure -->
                    <div class="form-group mb-3">
                        <label>Heure de départ</label>
                        <input
                            type="time"
                            v-model="form.heure_depart"
                            class="form-control"
                            required
                        />
                        <div
                            class="text-danger"
                            v-if="form.errors.heure_depart"
                        >
                            {{ form.errors.heure_depart }}
                        </div>
                    </div>

                    <!-- Prix -->
                    <div class="form-group mb-3">
                        <label>Prix du billet</label>
                        <input
                            type="number"
                            v-model="form.prix"
                            class="form-control"
                            required
                        />
                        <div class="text-danger" v-if="form.errors.prix">
                            {{ form.errors.prix }}
                        </div>
                    </div>

                    <!-- Statut -->
                    <div class="form-group mb-3">
                        <label>Statut</label>
                        <select
                            v-model="form.statut"
                            class="form-control"
                            required
                        >
                            <option value="actif">Actif</option>
                            <option value="inactif">Inactif</option>
                        </select>
                        <div class="text-danger" v-if="form.errors.statut">
                            {{ form.errors.statut }}
                        </div>
                    </div>

                    <!-- Bouton -->
                    <div class="d-flex justify-content-end mt-4">
                        <button
                            type="submit"
                            class="btn btn-primary"
                            :disabled="form.processing"
                        >
                            <span
                                v-if="form.processing"
                                class="spinner-border spinner-border-sm"
                            ></span>
                            {{ form.processing ? "En cours..." : "Valider" }}
                        </button>
                    </div>
                </form>
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
.btn {
    min-width: 80px;
    margin: 2px;
    padding: 0.375rem 0.75rem;
}

.btn-outline-primary {
    border: 1px solid #4b49ac;
    color: #4b49ac;
    background-color: white;
}

.btn-primary {
    background-color: #4b49ac;
    border-color: #4b49ac;
    color: white;
}
</style>
