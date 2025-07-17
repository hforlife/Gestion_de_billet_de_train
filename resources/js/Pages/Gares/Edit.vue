<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import { defineProps } from 'vue';
import Swal from "sweetalert2";

const props = defineProps({
    gare: Object,
});
// Initialisation du formulaire
const form = useForm({
    nom: props.gare?.nom ?? '',
    adresse: props.gare?.adresse ?? '',
});

const { errors } = form;

// Fonction d'envoi du formulaire
const submit = () => {
    if (!props.gare?.id) {
        alert("Erreur", "ID de la gare introuvable.", "error");
        return;
    }

    form.put(route("gare.update", props.gare.id), {
        onSuccess: () => {
            Swal.fire("Succès", "Gare modifiée avec succès.", "success");
        },
    });
};
</script>
<template>
    <AppLayout>
       <!-- 🧭 Titre -->
       <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Modifier Information Gare</h4>
                </div>
            </div>
        </div>

        <!-- Fromulaire -->
        <div class="row flex-grow">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Formulaire de Modification Gare</h4>

                        <form class="forms-sample" @submit.prevent="submit">
                            <div class="form-group">
                                <label for="nom">Nom de la gare</label>
                                <input
                                    type="text"
                                    class="form-control"
                                    v-model="form.nom"
                                    placeholder="Entrer Nom..."
                                    required
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
                                    v-model="form.adresse"
                                    placeholder="Entrer Adresse..."
                                    required
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
