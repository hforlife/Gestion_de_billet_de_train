<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import { ref, computed, watch } from "vue";
import Swal from "sweetalert2";
import { defineProps } from "vue";

// Props
const props = defineProps({
    categories: Array,
    tarifs: Array, // les paramètres de tarif
});

// Formulaire
const form = useForm({
    user1: "",
    user2: "",
    categorie_colis_id: "",
    poids: "",
    tarif: "",
    statut: "",
});

// Calcul automatique du tarif
watch(() => form.poids, calculateTarif);
watch(() => form.categorie_colis_id, calculateTarif);



function calculateTarif() {
    const poids = parseFloat(form.poids);
    const cat = props.categories.find(c => c.id === form.categorie_colis_id);
    if (!poids || poids <= 0 || !cat) {
        form.tarif = '';
        return;
    }

    const tarifRange = cat.tarifs.find(t => poids >= t.poids_min && poids <= t.poids_max);
    if (tarifRange) {
        form.tarif = poids * tarifRange.prix_par_kg;
    } else {
        form.tarif = '';
    }
}


// Soumission
const submit = () => {
    form.post(route("colis.store"), {
        preserveScroll: true,
        onSuccess: () => {
            Swal.fire("Succès", "Colis enregistré avec succès.", "success");
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

                            <!-- Catégorie de colis -->
                            <div class="form-group">
                                <label for="categorie">Catégorie</label>
                                <select
                                    v-model="form.categorie_colis_id"
                                    class="form-control"
                                >
                                    <option value="" disabled>
                                        -- Sélectionner une catégorie --
                                    </option>
                                    <option
                                        v-for="cat in categories"
                                        :key="cat.id"
                                        :value="cat.id"
                                    >
                                        {{ cat.nom }}
                                    </option>
                                </select>
                                <div
                                    v-if="form.errors.categorie_colis_id"
                                    class="text-danger"
                                >
                                    {{ form.errors.categorie_colis_id }}
                                </div>
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
                                <label for="tarif">Tarif (FCFA)</label>
                                <input
                                    type="number"
                                    id="tarif"
                                    class="form-control"
                                    v-model="form.tarif"
                                    placeholder="Calcul automatique"
                                    disabled
                                />
                                <div
                                    v-if="form.errors.tarif"
                                    class="text-danger"
                                >
                                    {{ form.errors.tarif }}
                                </div>
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
    </AppLayout>
</template>
