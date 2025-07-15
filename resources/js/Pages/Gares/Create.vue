<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { ref } from "vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";

// Initialisation du formulaire
const form = useForm({
    nom: "",
    adresse: "",
});

const { errors } = form;

// Fonction d'envoi du formulaire
const submit = () => {
    form.post(route("gare.store"), {
        onSuccess: () => {
            Swal.fire("Succès", "Gare ajoutée avec succès.", "success");
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
                    <h4 class="page-title">Nouvelle Gare</h4>
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
                        <h4 class="card-title">Formulaire Gare</h4>
                        <!-- <p class="card-description"> Basic form layout </p> -->
                        <form class="forms-sample" @submit.prevent="submit">
                            <div class="form-group">
                                <label for="nom">Nom de la gare</label>
                                <input
                                    type="text"
                                    class="form-control"
                                    id="nom"
                                    v-model="form.nom"
                                    placeholder="Entrer Nom..."
                                />
                                <span
                                    v-if="form.errors.nom"
                                    class="text-red-500"
                                    >{{ form.errors.nom }}</span
                                >
                            </div>

                            <div class="form-group">
                                <label for="adresse">Adresse de la gare</label>
                                <input
                                    type="text"
                                    class="form-control"
                                    id="adresse"
                                    v-model="form.adresse"
                                    placeholder="Entrer Adresse..."
                                />
                                <span
                                    v-if="form.errors.adresse"
                                    class="text-red-500"
                                    >{{ form.errors.adresse }}</span
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
