<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import { defineProps } from "vue";

const props = defineProps({
    colis: Object,
});

// Initialisation du formulaire
const form = useForm({
    user1: props.colis?.user1 ?? '',
    user2: props.colis?.user2 ?? '',
    poids: props.colis?.poids ?? '',
    tarif: props.colis?.tarif ?? '',
    statut: props.colis?.statut ?? '',
});

const { errors } = form;

// Fonction d'envoi du formulaire
const submit = () => {
  form.put(route('bagage.update', props.colis.id), {
    onSuccess: () => {
      Swal.fire(
        'Success', 
        'Colis modifiée avec succès !', 
        'success'
    );
    }
  });
};
</script>
<template>
    <AppLayout>
        <!-- Titre -->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Modifier Info Colis</h4>
                </div>
            </div>
        </div>

        <!-- Fromulaire -->
        <div class="row flex-grow">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Formulaire de modification</h4>
                        <form class="forms-sample" @submit.prevent="submit">
                            <div class="form-group">
                                <label for="user1"
                                    >Nom de l'Expéditeur</label
                                >
                                <input
                                    type="text"
                                    id="user1"
                                    class="form-control"
                                    v-model="form.user1"
                                    placeholder="Entrer Nom Complet De l'Expéditeur..."
                                    required
                                />
                                <div v-if="errors.user1" class="text-danger">{{ errors.user1 }}</div>
                            </div>

                            <!-- Nom du destiantaire -->
                            <div class="form-group">
                                <label for="user2"
                                    >Nom du Destinataire</label
                                >
                                <input
                                    type="text"
                                    class="form-control"
                                    id="user2"
                                    v-model="form.user2"
                                    placeholder="Entrer Nom Complet Du Destinataire..."
                                    required
                                />
                                <div v-if="errors.user2" class="text-danger">{{ errors.user2 }}</div>
                            </div>

                            <!-- Poids du colis -->
                            <div class="form-group">
                                <label for="poids"
                                    >Poids du Colis</label
                                >
                                <input
                                    type="number"
                                    id="poids"
                                    class="form-control"
                                    v-model="form.poids"
                                    placeholder="Entrer Poids Du Colis..."
                                    required
                                />
                                <div v-if="errors.poids" class="text-danger">{{ errors.poids }}</div>
                            </div>

                            <!-- Prix d'envoi du colis -->
                            <div class="form-group">
                                <label for="tarif"
                                    >Prix d'Expédition du Colis</label
                                >
                                <input
                                    type="number"
                                    id="tarif"
                                    class="form-control"
                                    v-model="form.tarif"
                                    placeholder="Entrer Prix"
                                    required
                                />
                                <div v-if="errors.tarif" class="text-danger">{{ errors.tarif }}</div>
                            </div>

                            <!-- Etat du Colis -->
                            <div class="form-group">
                                <label for="statut"
                                    >Status</label
                                >
                                <select
                                    class="form-control"
                                    v-model="form.statut" id="statut"
                                >
                                    <option value="" disabled>
                                        -- Choisissez un status --
                                    </option>
                                    <option value="enregistré">
                                        Enregistré
                                    </option>
                                    <option value="perdu">Perdu</option>
                                    <option value="livré">Livré</option>
                                </select>
                                <div v-if="errors.statut" class="text-danger">{{ errors.statut }}</div>
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
