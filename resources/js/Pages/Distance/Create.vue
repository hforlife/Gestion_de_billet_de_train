<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { Link, useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { defineProps, computed } from "vue";

const props = defineProps({
    gares: Array, // liste des gares
});

const form = useForm({
    gare_depart_id: "",
    gare_arrivee_id: "",
    distance_km: "",
});

// Prévenir sélection identique
const canSubmit = computed(() => {
    return (
        form.gare_depart_id &&
        form.gare_arrivee_id &&
        form.gare_depart_id !== form.gare_arrivee_id &&
        form.distance_km !== "" &&
        !form.processing
    );
});

const submit = () => {
    if (form.gare_depart_id === form.gare_arrivee_id) {
        Swal.fire({
            icon: "warning",
            title: "Erreur",
            text: "La gare de départ et d'arrivée doivent être différentes.",
        });
        return;
    }

    form.post(route("distance.store"), {
        preserveScroll: true,
        onSuccess: () => {
            Swal.fire({
                toast: true,
                position: "top-end",
                icon: "success",
                title: "Distance créée avec succès",
                showConfirmButton: false,
                timer: 3000,
            });
            form.reset();
        },
        onError: () => {
            Swal.fire({
                icon: "error",
                title: "Erreur",
                text: "Veuillez corriger les erreurs dans le formulaire",
            });
        },
    });
};
</script>

<template>
    <AppLayout>
        <div class="container py-4">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card">
                        <div
                            class="card-header bg-primary text-white d-flex justify-content-between align-items-center"
                        >
                            <h4 class="mb-0">Définir une distance</h4>
                            <Link
                                :href="route('distance.index')"
                                class="btn btn-light btn-sm"
                                >← Retour</Link
                            >
                        </div>

                        <div class="card-body">
                            <form @submit.prevent="submit">
                                <!-- Gare de départ -->
                                <div class="mb-3">
                                    <label class="form-label"
                                        >Gare de départ
                                        <span class="text-danger">*</span>
                                    </label>
                                    <select
                                        v-model="form.gare_depart_id"
                                        class="form-control"
                                        :class="{
                                            'is-invalid': form.errors.gare_depart_id,
                                        }"
                                        required
                                    >
                                        <option value="" disabled>
                                            -- Sélectionner une gare de départ --
                                        </option>
                                        <option
                                            v-for="gare in props.gares"
                                            :key="gare.id"
                                            :value="gare.id"
                                        >
                                            {{ gare.nom }}
                                        </option>
                                    </select>
                                    <div v-if="form.errors.gare_depart_id" class="invalid-feedback">
                                        {{ form.errors.gare_depart_id }}
                                    </div>
                                </div>

                                <!-- Gare d'arrivée -->
                                <div class="mb-3">
                                    <label class="form-label"
                                        >Gare d'arrivée
                                        <span class="text-danger">*</span>
                                    </label>
                                    <select
                                        v-model="form.gare_arrivee_id"
                                        class="form-control"
                                        :class="{
                                            'is-invalid': form.errors.gare_arrivee_id,
                                        }"
                                        required
                                    >
                                        <option value="" disabled>
                                            -- Sélectionner une gare d'arrivée --
                                        </option>
                                        <option
                                            v-for="gare in props.gares"
                                            :key="gare.id"
                                            :value="gare.id"
                                            :disabled="gare.id === form.gare_depart_id"
                                        >
                                            {{ gare.nom }}
                                        </option>
                                    </select>
                                    <div v-if="form.errors.gare_arrivee_id" class="invalid-feedback">
                                        {{ form.errors.gare_arrivee_id }}
                                    </div>
                                </div>

                                <!-- Distance en KM -->
                                <div class="mb-3">
                                    <label class="form-label" for="distance_km"
                                        >Distance (km)
                                        <span class="text-danger">*</span>
                                    </label>
                                    <input
                                        id="distance_km"
                                        type="number"
                                        v-model.number="form.distance_km"
                                        class="form-control"
                                        :class="{
                                            'is-invalid': form.errors.distance_km,
                                        }"
                                        placeholder="492"
                                        min="0"
                                        step="1"
                                        required
                                    />
                                    <div v-if="form.errors.distance_km" class="invalid-feedback">
                                        {{ form.errors.distance_km }}
                                    </div>
                                </div>

                                <!-- Bouton -->
                                <div class="d-flex justify-content-end">
                                    <button
                                        type="submit"
                                        class="btn btn-primary"
                                        :disabled="!canSubmit"
                                    >
                                        <span
                                            v-if="form.processing"
                                            class="spinner-border spinner-border-sm me-2"
                                        ></span>
                                        {{ form.processing ? "Création en cours..." : "Créer" }}
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
