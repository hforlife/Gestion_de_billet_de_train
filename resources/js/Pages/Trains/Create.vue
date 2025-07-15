<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { ref } from "vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";

// Initialisation du formulaire
const form = useForm({
    numero: "",
    etat: "",
});

const {errors} = form;

// Fonction d'envoi du formulaire
const submit = () => {
    form.post(route("train.store"), {
        onSuccess: () => {
            Swal.fire("Succès", "Train ajouté avec succès.", "success");
        },
        onError: (errors) => {
            Swal.fire("Erreur", "Merci de vérifier le formulaire.", "errors");
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
                    <h4 class="page-title">Nouveau Train</h4>
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
                        <h4 class="card-title">
                            Formulaire d'ajout de train
                        </h4>
                        <!-- <p class="card-description"> Basic form layout </p> -->
                        <form class="forms-sample" @submit.prevent="submit">
                            <!-- Nom -->
                            <div class="form-group">
                                <label for="numero">Numéro du train</label>
                                <input
                                    type="text"
                                    class="form-control"
                                    id="numero"
                                    v-model="form.numero"
                                    placeholder="Entrer Nom"
                                />
                                <span
                                    v-if="errors.numero"
                                    class="text-danger"
                                    >{{ errors.numero }}</span
                                >
                            </div>
                            <!-- Etat -->
                            <div class="form-group">
                                <label for="exampleInputPassword1"
                                    >Etat du train</label
                                >
                                <select
                                    class="form-control"
                                    v-model="form.etat"
                                >
                                    <option value="" disabled>
                                        -- Choisissez un etat --
                                    </option>
                                    <option value="actif">Actif</option>
                                    <option value="en_maintenance">
                                        Maintenance
                                    </option>
                                </select>
                                <span
                                    v-if="errors.etat"
                                    class="text-danger"
                                    >{{ errors.etat }}</span
                                >
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
