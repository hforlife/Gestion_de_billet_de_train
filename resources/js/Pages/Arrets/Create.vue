<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps } from "vue";
import { useForm } from "@inertiajs/vue3";
import { Link } from "@inertiajs/vue3";
import Swal from "sweetalert2";

const props = defineProps({
    lignes: Array,
    gares: Array,
});

// Initialisation du formulaire
const form = useForm({
    ligne_id: "", // Corrigé: voyage_id -> ligne_id
    gare_id: "",
    distance_depart: "", // Ajouté
    ordre: "", // Ajouté (optionnel si calculé automatiquement)
});

// Fonction d'envoi du formulaire
const submit = () => {
    form.post(route("arret.store"), {
        onSuccess: () => {
            Swal.fire("Succès", "Arrêt ajouté avec succès.", "success");
            form.reset();
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
        <!-- Page Title Header Starts-->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Nouvel Arrêt</h4>
                </div>
            </div>
        </div>
        <!-- Page Title Header Ends-->

        <!-- Formulaire -->
        <div class="row flex-grow">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Formulaire Arrêts</h4>
                        <form class="forms-sample" @submit.prevent="submit">
                            <!-- Ligne -->
                            <div class="form-group">
                                <label for="ligne_id">Ligne</label>
                                <select
                                    v-model="form.ligne_id"
                                    class="form-control"
                                    required
                                >
                                    <option value="" disabled>
                                        -- Sélectionner une ligne --
                                    </option>
                                    <option
                                        v-for="ligne in lignes"
                                        :key="ligne.id"
                                        :value="ligne.id"
                                    >
                                        {{ ligne.nom }}
                                    </option>
                                </select>
                                <span
                                    v-if="form.errors.ligne_id"
                                    class="text-danger"
                                >
                                    {{ form.errors.ligne_id }}
                                </span>
                            </div>

                            <!-- Gare -->
                            <div class="form-group">
                                <label for="gare_id">Gare</label>
                                <select
                                    v-model="form.gare_id"
                                    class="form-control"
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
                                <span
                                    v-if="form.errors.gare_id"
                                    class="text-danger"
                                >
                                    {{ form.errors.gare_id }}
                                </span>
                            </div>

                            <!-- Distance départ -->
                            <div class="form-group">
                                <label for="distance_depart"
                                    >Distance Départ (km)</label
                                >
                                <input
                                    type="number"
                                    step="0.01"
                                    min="0"
                                    class="form-control"
                                    v-model="form.distance_depart"
                                    required
                                />
                                <span
                                    v-if="form.errors.distance_depart"
                                    class="text-danger"
                                >
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
                                    <label
                                        class="form-check-label"
                                        for="venteChefTrain"
                                    >
                                        Vente par le chef de train
                                    </label>
                                </div>
                                <span
                                    v-if="form.errors.vente_chef_train"
                                    class="text-danger"
                                >
                                    {{ form.errors.vente_chef_train }}
                                </span>
                            </div>

                            <!-- Champ ordre optionnel (peut être calculé automatiquement) -->
                            <div class="form-group" v-if="false">
                                <!-- Masqué car calculé automatiquement -->
                                <label for="ordre">Ordre</label>
                                <input
                                    type="number"
                                    min="1"
                                    class="form-control"
                                    v-model="form.ordre"
                                />
                                <span
                                    v-if="form.errors.ordre"
                                    class="text-danger"
                                >
                                    {{ form.errors.ordre }}
                                </span>
                            </div>

                            <!-- Boutons -->
                            <div class="d-flex justify-content-end mt-4">
                                <Link
                                :href="route('arret.index')"
                                class="btn-cancel"
                            >
                                Annuler
                            </Link>
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
                                    {{
                                        form.processing
                                            ? "En cours..."
                                            : "Valider"
                                    }}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
