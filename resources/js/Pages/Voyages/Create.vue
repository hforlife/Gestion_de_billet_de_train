<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import { defineProps, computed } from "vue";
import Swal from "sweetalert2";

const props = defineProps({
    gares: Array,
    trains: Array,
    joursSemaine: Array,
});

const form = useForm({
    name: "",
    train_id: "",
    gare_depart_id: "",
    gare_arrivee_id: "",
    date_depart: "",
    date_arrivee: "",
    prix: "",
    statut: "",
});

const garesArriveeDisponibles = computed(() => {
    return props.gares.filter((gare) => gare.id !== form.gare_depart_id);
});

const submit = () => {
    form.post(route("voyage.store"), {
        onSuccess: () => {
            Swal.fire("Succès", "Voyage ajouté avec succès.", "success");
            form.reset();
        },
        onError: () => {
            Swal.fire("Erreur", "Merci de vérifier le formulaire.", "error");
        },
    });
};
</script>

<template>
    <AppLayout>
        <div class="page-header">
            <h4 class="page-title">Ajout de Voyage</h4>
        </div>
        <div class="container py-4">
            <div class="row justify-content-center">
                <div class="col-md-10">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h3 class="mb-0">Créer un Voyage</h3>
                        </div>

                        <div class="card-body">
                            <form @submit.prevent="submit">
                                <!-- Nom du voyage -->
                                <div class="mb-3">
                                    <label class="form-label"
                                        >Nom du Voyage
                                        <span class="text-danger"
                                            >*</span
                                        ></label
                                    >
                                    <input
                                        v-model="form.name"
                                        type="text"
                                        class="form-control"
                                        :class="{
                                            'is-invalid': form.errors.name,
                                        }"
                                        placeholder="Ex: Bamako-Kayes (Lundi)"
                                        required
                                    />
                                    <div
                                        v-if="form.errors.name"
                                        class="invalid-feedback"
                                    >
                                        {{ form.errors.name }}
                                    </div>
                                </div>

                                <!-- Train -->
                                <div class="mb-3">
                                    <label class="form-label"
                                        >Train
                                        <span class="text-danger"
                                            >*</span
                                        ></label
                                    >
                                    <select
                                        v-model="form.train_id"
                                        class="form-control"
                                        :class="{
                                            'is-invalid': form.errors.train_id,
                                        }"
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
                                    <div
                                        v-if="form.errors.train_id"
                                        class="invalid-feedback"
                                    >
                                        {{ form.errors.train_id }}
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Gare de départ -->
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label"
                                            >Gare de départ
                                            <span class="text-danger"
                                                >*</span
                                            ></label
                                        >
                                        <select
                                            v-model="form.gare_depart_id"
                                            class="form-control"
                                            :class="{
                                                'is-invalid':
                                                    form.errors.gare_depart_id,
                                            }"
                                            required
                                        >
                                            <option value="" disabled>
                                                -- Sélectionner une gare --
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
                                            v-if="form.errors.gare_depart_id"
                                            class="invalid-feedback"
                                        >
                                            {{ form.errors.gare_depart_id }}
                                        </div>
                                    </div>

                                    <!-- Gare d'arrivée -->
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label"
                                            >Gare d'arrivée
                                            <span class="text-danger"
                                                >*</span
                                            ></label
                                        >
                                        <select
                                            v-model="form.gare_arrivee_id"
                                            class="form-control"
                                            :class="{
                                                'is-invalid':
                                                    form.errors.gare_arrivee_id,
                                            }"
                                            :disabled="!form.gare_depart_id"
                                            required
                                        >
                                            <option value="" disabled>
                                                -- Sélectionner une gare --
                                            </option>
                                            <option
                                                v-for="gare in garesArriveeDisponibles"
                                                :key="gare.id"
                                                :value="gare.id"
                                            >
                                                {{ gare.nom }}
                                            </option>
                                        </select>
                                        <div
                                            v-if="form.errors.gare_arrivee_id"
                                            class="invalid-feedback"
                                        >
                                            {{ form.errors.gare_arrivee_id }}
                                        </div>
                                    </div>
                                </div>

                                <!-- Date et heure de départ -->
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label"
                                            >Date de départ
                                            <span class="text-danger"
                                                >*</span
                                            ></label
                                        >
                                        <input
                                            v-model="form.date_depart"
                                            type="datetime-local"
                                            class="form-control"
                                            :class="{
                                                'is-invalid':
                                                    form.errors.date_depart,
                                            }"
                                            required
                                        />
                                        <div
                                            v-if="form.errors.date_depart"
                                            class="invalid-feedback"
                                        >
                                            {{ form.errors.date_depart }}
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label"
                                            >Date d'arrivée</label
                                        >
                                        <input
                                            v-model="form.date_arrivee"
                                            type="datetime-local"
                                            class="form-control"
                                            :class="{
                                                'is-invalid':
                                                    form.errors.date_arrivee,
                                            }"
                                        />
                                        <div
                                            v-if="form.errors.date_arrivee"
                                            class="invalid-feedback"
                                        >
                                            {{ form.errors.date_arrivee }}
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Prix -->
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label"
                                            >Prix du billet
                                            <span class="text-danger"
                                                >*</span
                                            ></label
                                        >
                                        <div class="input-group">
                                            <input
                                                v-model="form.prix"
                                                type="number"
                                                class="form-control"
                                                :class="{
                                                    'is-invalid':
                                                        form.errors.prix,
                                                }"
                                                placeholder="Ex: 5000"
                                                required
                                            />
                                            <span class="input-group-text"
                                                >FCFA</span
                                            >
                                        </div>
                                        <div
                                            v-if="form.errors.prix"
                                            class="invalid-feedback"
                                        >
                                            {{ form.errors.prix }}
                                        </div>
                                    </div>

                                    <!-- Statut -->
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label"
                                            >Statut
                                            <span class="text-danger"
                                                >*</span
                                            ></label
                                        >
                                        <select
                                            v-model="form.statut"
                                            class="form-control"
                                            :class="{
                                                'is-invalid':
                                                    form.errors.statut,
                                            }"
                                            required
                                        >
                                            <option value="" disabled>
                                                -- Sélectionner un statut --
                                            </option>
                                            <option value="programmé">
                                                Programmé
                                            </option>
                                            <option value="en_cours">
                                                En Cours
                                            </option>
                                            <option value="terminé">
                                                Terminé
                                            </option>
                                            <option value="annulé">
                                                Annulé
                                            </option>
                                        </select>
                                        <div
                                            v-if="form.errors.statut"
                                            class="invalid-feedback"
                                        >
                                            {{ form.errors.statut }}
                                        </div>
                                    </div>
                                </div>

                                <!-- Bouton de soumission -->
                                <div class="d-flex justify-content-end mt-4">
                                    <button
                                        type="reset"
                                        class="btn btn-light me-2"
                                        :disabled="form.processing"
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
                                            class="spinner-border spinner-border-sm me-2"
                                        ></span>
                                        {{
                                            form.processing
                                                ? "Création en cours..."
                                                : "Créer les voyages"
                                        }}
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
