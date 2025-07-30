<!-- Create.vue -->
<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";

const props = defineProps({
    voyages: Array,
    gares: Array,
    classes: Array,
});

const form = useForm({
    voyage_id: "",
    classe_wagon_id: "",
    prix: "",
    date_effet: new Date().toISOString().split("T")[0],
    date_expiration: "",
});

const { errors } = form;

const submit = () => {
    form.post(route("tarif.store"), {
        onSuccess: () => {
            Swal.fire("Succès", "Tarif ajouté avec succès.", "success");
        },
        onError: (errors) => {
            Swal.fire("Erreur", "Merci de vérifier le formulaire.", "errors");
        },
    });
};
</script>

<template>
    <AppLayout title="Créer un Tarif">
        <!-- Page Title Header Starts-->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Nouveau Tarif</h4>
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
                        <h4 class="card-title">Formulaire d'ajout de tarif</h4>
                        <!-- <p class="card-description"> Basic form layout </p> -->
                        <form class="forms-sample" @submit.prevent="submit">
                            <!-- Ligne (optionnel) -->
                            <div class="form-group">
                                <label>Voyages</label>
                                <select
                                    v-model="form.voyage_id"
                                    class="form-control"
                                >
                                    <option value="" disabled>
                                        -- Sélectionnez un voyage --
                                    </option>
                                    <option
                                        v-for="voyage in props.voyages"
                                        :key="voyage.id"
                                        :value="voyage.id"
                                    >
                                        {{ voyage.nom }}
                                    </option>
                                </select>
                                <span
                                    v-if="errors.voyage_id"
                                    class="text-danger"
                                    >{{ errors.voyage_id }}</span
                                >
                            </div>

                            <!-- Classe -->
                            <div class="form-group">
                                <label>Classe</label>
                                <select
                                    v-model="form.classe_wagon_id"
                                    class="form-control"
                                    required
                                >
                                    <option value="" disabled>
                                        Sélectionnez une classe
                                    </option>
                                    <option
                                        v-for="classe in classes"
                                        :key="classe.id"
                                        :value="classe.id"
                                    >
                                        {{ classe.classe }}
                                    </option>
                                </select>
                                <span
                                    v-if="errors.classe_wagon_id"
                                    class="text-danger"
                                    >{{ errors.classe_wagon_id }}</span
                                >
                            </div>

                            <!-- Date effet -->
                            <div>
                                <label
                                    class="block text-sm font-medium text-gray-700"
                                    >Date d'effet</label
                                >
                                <input
                                    v-model="form.date_effet"
                                    type="date"
                                    class="form-control"
                                    required
                                />
                                <span
                                    v-if="errors.date_effet"
                                    class="text-danger"
                                    >{{ errors.date_effet }}</span
                                >
                            </div>

                            <!-- Date expiration -->
                            <div>
                                <label>Date d'expiration (optionnel)</label>
                                <input
                                    v-model="form.date_expiration"
                                    type="date"
                                    class="form-control"
                                    :min="form.date_effet"
                                />
                                <span
                                    v-if="errors.date_expiration"
                                    class="text-danger"
                                    >{{ errors.date_expiration }}</span
                                >
                            </div>

                            <!-- Prix -->
                            <div class="form-group">
                                <label>Prix de base (FCFA)</label>
                                <input
                                    v-model="form.prix"
                                    type="number"
                                    min="0"
                                    step="0.01"
                                    class="form-control"
                                    required
                                />
                                <span v-if="errors.prix" class="text-danger">{{
                                    errors.prix
                                }}</span>
                            </div>

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
        <!-- Fin Formulaire -->
    </AppLayout>
</template>
