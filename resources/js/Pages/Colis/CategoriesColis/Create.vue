<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";

// Initialisation du formulaire
const form = useForm({
    nom: "",
    description: "",
});

// Soumission
const submit = () => {
    form.post(route("categories-colis.store"), {
        preserveScroll: true,
        onSuccess: () => {
            Swal.fire("Succès", "Catégorie ajoutée avec succès.", "success");
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
        <!-- Titre -->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Ajouter une Catégorie de Colis</h4>
                </div>
            </div>
        </div>
        <!-- Fin Titre -->

        <!-- Formulaire -->
        <div class="row flex-grow">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Formulaire</h4>
                        <form class="forms-sample" @submit.prevent="submit">
                            <!-- Nom -->
                            <div class="form-group">
                                <label for="nom">Nom de la catégorie</label>
                                <input
                                    type="text"
                                    id="nom"
                                    class="form-control"
                                    v-model="form.nom"
                                    placeholder="Ex: Petit colis, Volumineux..."
                                />
                                <div
                                    v-if="form.errors.nom"
                                    class="text-danger"
                                    v-text="form.errors.nom"
                                />
                            </div>

                            <!-- Description -->
                            <div class="form-group">
                                <label for="description">Description</label>
                                <textarea
                                    id="description"
                                    class="form-control"
                                    v-model="form.description"
                                    placeholder="Description facultative"
                                ></textarea>
                                <div
                                    v-if="form.errors.description"
                                    class="text-danger"
                                    v-text="form.errors.description"
                                />
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
    </AppLayout>
</template>
