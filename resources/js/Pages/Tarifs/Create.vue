<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";

const props = defineProps({
    lignes: Array,
    classes: Array,
});

// Initialisation du formulaire
const form = useForm({
    ligne_id: "",
    classe_wagon_id: "",
    prix_base: "",
    date_effet: new Date().toISOString().split("T")[0],
    date_expiration: "",
});

const { errors } = form;

// Soumission avec alertes
const submit = () => {
    form.post(route("tarif.store"), {
        onSuccess: () => {
            Swal.fire("Succès", "Tarif créé avec succès.", "success");
        },
        onError: () => {
            Swal.fire("Erreur", "Merci de vérifier le formulaire.", "error");
        },
    });
};
</script>

<template>
    <AppLayout>
        <!-- Page Title Header -->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Nouveau Tarif</h4>
                </div>
            </div>
        </div>

        <!-- Formulaire -->
        <div class="row flex-grow">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Formulaire de création de tarif</h4>

                        <form class="forms-sample" @submit.prevent="submit">
                            <!-- Ligne -->
                            <div class="form-group">
                                <label for="ligne">Ligne</label>
                                <select
                                    class="form-control"
                                    v-model="form.ligne_id"
                                    id="ligne"
                                >
                                    <option value="" disabled>-- Sélectionnez une ligne --</option>
                                    <option
                                        v-for="ligne in props.lignes"
                                        :key="ligne.id"
                                        :value="ligne.id"
                                    >
                                        {{ ligne.nom }}
                                    </option>
                                </select>
                                <span v-if="errors.ligne_id" class="text-danger">{{ errors.ligne_id }}</span>
                            </div>

                            <!-- Classe -->
                            <div class="form-group">
                                <label for="classe">Classe</label>
                                <select
                                    class="form-control"
                                    v-model="form.classe_wagon_id"
                                    id="classe"
                                >
                                    <option value="" disabled>-- Sélectionnez une classe --</option>
                                    <option
                                        v-for="classe in props.classes"
                                        :key="classe.id"
                                        :value="classe.id"
                                    >
                                        {{ classe.classe }}
                                    </option>
                                </select>
                                <span v-if="errors.classe_wagon_id" class="text-danger">{{ errors.classe_wagon_id }}</span>
                            </div>

                            <!-- Prix -->
                            <div class="form-group">
                                <label for="prix">Prix de base (FCFA)</label>
                                <input
                                    type="number"
                                    class="form-control"
                                    id="prix"
                                    v-model="form.prix_base"
                                    placeholder="Ex: 5000"
                                    min="0"
                                    step="0.01"
                                />
                                <span v-if="errors.prix_base" class="text-danger">{{ errors.prix_base }}</span>
                            </div>

                            <!-- Date d'effet -->
                            <div class="form-group">
                                <label for="effet">Date d'effet</label>
                                <input
                                    type="date"
                                    class="form-control"
                                    id="effet"
                                    v-model="form.date_effet"
                                />
                                <span v-if="errors.date_effet" class="text-danger">{{ errors.date_effet }}</span>
                            </div>

                            <!-- Date expiration -->
                            <div class="form-group">
                                <label for="expiration">Date d'expiration (optionnel)</label>
                                <input
                                    type="date"
                                    class="form-control"
                                    id="expiration"
                                    v-model="form.date_expiration"
                                    :min="form.date_effet"
                                />
                                <span v-if="errors.date_expiration" class="text-danger">{{ errors.date_expiration }}</span>
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
        <!-- Fin formulaire -->
    </AppLayout>
</template>
