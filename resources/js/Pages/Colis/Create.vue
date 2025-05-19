<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import { defineProps } from "vue";
import Swal from "sweetalert2";


// Initialisation du formulaire
const form = useForm({
    user1: "",
    user2: "",
    poids: "",
    tarif: "",
    statut: "",
});

defineProps({
    errors: Object,
});

// Soumission
const submit = () => {
    form.post(route("bagage.store"), {
        preserveScroll: true,
        onSuccess: () => {
            Swal.fire("Succès", "Colis ajouté avec succès.", "success");
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
                    <h4 class="page-title">Gestion des Colis</h4>
                </div>
            </div>
        </div>
        <!-- Fin Titre -->

        <!-- Formulaire -->
        <div class="row flex-grow">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Formulaire Colis</h4>
                        <form class="forms-sample" @submit.prevent="submit">
                            <div class="form-group">
                                <label for="user1">Nom de l'expéditeur</label>
                                <input
                                    type="text"
                                    id="user1"
                                    class="form-control"
                                    v-model="form.user1"
                                    placeholder="Entrer Nom de l'Expéditeur"
                                />
                                <div
                                    v-if="form.errors.user1"
                                    v-text="form.errors.user1"
                                    class="text-danger"
                                ></div>
                            </div>

                            <div class="form-group">
                                <label for="user2">Nom du destinataire</label>
                                <input
                                    type="text"
                                    id="user2"
                                    class="form-control"
                                    v-model="form.user2"
                                    placeholder="Entrer Nom du Destinataire"
                                />
                                <div
                                    v-if="form.errors.user2"
                                    v-text="form.errors.user2"
                                    class="text-danger"
                                ></div>
                            </div>

                            <div class="form-group">
                                <label for="poids">Poids du colis (Kg)</label>
                                <input
                                    type="number"
                                    id="poids"
                                    class="form-control"
                                    v-model="form.poids"
                                    placeholder="Entrer Poids"
                                />
                                <div
                                    v-if="form.errors.poids"
                                    v-text="form.errors.poids"
                                    class="text-danger"
                                ></div>
                            </div>

                            <div class="form-group">
                                <label for="tarif"
                                    >Prix d'expédition (FCFA)</label
                                >
                                <input
                                    type="number"
                                    id="tarif"
                                    class="form-control"
                                    v-model="form.tarif"
                                    placeholder="Entrer Prix"
                                />
                                <div
                                    v-if="form.errors.tarif"
                                    v-text="form.errors.tarif"
                                    class="text-danger"
                                ></div>
                            </div>

                            <div class="form-group">
                                <label for="statut">Statut</label>
                                <select
                                    class="form-control"
                                    v-model="form.statut"
                                >
                                    <option value="" disabled>
                                        -- Choisissez un statut --
                                    </option>
                                    <option value="enregistré">
                                        Enregistré
                                    </option>
                                    <option value="perdu">Perdu</option>
                                    <option value="livré">Livré</option>
                                </select>
                                <div
                                    v-if="form.errors.statut"
                                    v-text="form.errors.statut"
                                    class="text-danger"
                                ></div>
                            </div>

                            <button type="submit" class="btn btn-primary">
                                Valider
                            </button>
                            <button type="reset" class="btn btn-light ml-2">
                                Annuler
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
