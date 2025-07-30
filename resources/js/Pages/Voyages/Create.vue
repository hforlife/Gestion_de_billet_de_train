<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm, router } from "@inertiajs/vue3";
import { computed, watch } from "vue";
import Swal from "sweetalert2";

const props = defineProps({
    trains: Array,
    lignes: Array,
    tarifs: Array,
});

const form = useForm({
    nom: "",
    train_id: "",
    ligne_id: "",
    // tarif_ids: [],
    date_depart: "",
    date_arrivee: "",
    statut: "programme",
});

// const tarifsDisponibles = computed(() => {
//     if (!form.ligne_id) return [];
//     return props.tarifs.filter((t) => t.ligne_id == form.ligne_id);
// });

// watch(() => form.ligne_id, () => {
//     form.tarif_ids = [];
// });

const submit = () => {
    form.post(route("voyage.store"), {
        onSuccess: () => {
            Swal.fire("Succès", "Voyage créé avec succès", "success");
            form.reset();
        },
        onError: () => {
            Swal.fire("Erreur", "Veuillez vérifier le formulaire", "error");
        },
    });
};
</script>

<template>
    <AppLayout>
        <div class="page-header">
            <h4 class="page-title">Nouveau Voyage</h4>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h3 class="card-title">Création d'un voyage</h3>
                    </div>

                    <div class="card-body">
                        <form @submit.prevent="submit">
                            <div class="row">

                                <!-- Nom du voyage -->
                                <div class="col-md-6 mb-3">
                                    <label class="form-label"
                                        >Nom du voyage
                                        <span class="text-danger"
                                            >*</span
                                        ></label
                                    >
                                    <input
                                        v-model="form.nom"
                                        type="text"
                                        class="form-control"
                                        :class="{
                                            'is-invalid': form.errors.nom,
                                        }"
                                        placeholder="Ex: Bamako-Kayes Express"
                                        required
                                    />
                                    <div
                                        v-if="form.errors.nom"
                                        class="invalid-feedback"
                                    >
                                        {{ form.errors.nom }}
                                    </div>
                                </div>

                                <!-- Train -->
                                <div class="col-md-6 mb-3">
                                    <label class="form-label"
                                        >Train
                                        <span class="text-danger"
                                            >*</span
                                        ></label
                                    >
                                    <select
                                        v-model="form.train_id"
                                        class="form-control"
                                        :class="{
                                            'is-invalid': form.errors.train_id,
                                        }"
                                        required
                                    >
                                        <option value="" disabled>
                                            Sélectionnez un train
                                        </option>
                                        <option
                                            v-for="train in trains"
                                            :key="train.id"
                                            :value="train.id"
                                        >
                                            Train {{ train.numero }}
                                        </option>
                                    </select>
                                    <div
                                        v-if="form.errors.train_id"
                                        class="invalid-feedback"
                                    >
                                        {{ form.errors.train_id }}
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <!-- Ligne -->
                                <div class="col-md-6 mb-3">
                                    <label class="form-label"
                                        >Ligne
                                        <span class="text-danger"
                                            >*</span
                                        ></label
                                    >
                                    <select
                                        v-model="form.ligne_id"
                                        class="form-control"
                                        :class="{
                                            'is-invalid': form.errors.ligne_id,
                                        }"
                                        required
                                    >
                                        <option value="" disabled>
                                            Sélectionnez une ligne
                                        </option>
                                        <option
                                            v-for="ligne in lignes"
                                            :key="ligne.id"
                                            :value="ligne.id"
                                        >
                                            {{ ligne.nom }}
                                        </option>
                                    </select>
                                    <div
                                        v-if="form.errors.ligne_id"
                                        class="invalid-feedback"
                                    >
                                        {{ form.errors.ligne_id }}
                                    </div>
                                </div>

                                <!-- Tarifs -->
                                <!-- <div class="col-md-12 mb-3">
                                    <label class="form-label"
                                        >Tarifs applicables
                                        <span class="text-danger"
                                            >*</span
                                        ></label
                                    >

                                    <div v-if="tarifsDisponibles.length">
                                        <div
                                            v-for="tarif in tarifsDisponibles"
                                            :key="tarif.id"
                                            class="form-check"
                                        >
                                            <input
                                                class="form-check-input"
                                                type="checkbox"
                                                :id="'tarif_' + tarif.id"
                                                :value="tarif.id"
                                                v-model="form.tarif_ids"
                                            />
                                            <label
                                                class="form-check-label"
                                                :for="'tarif_' + tarif.id"
                                            >
                                                {{ tarif.gare_depart.nom }} →
                                                {{ tarif.gare_arrivee.nom }} |
                                                {{ tarif.classe_wagon.nom }} :
                                                {{ tarif.prix }} FCFA
                                            </label>
                                        </div>
                                    </div>
                                    <div v-else class="text-muted small">
                                        Aucun tarif disponible pour cette ligne.
                                    </div>

                                    <div
                                        v-if="form.errors.tarif_ids"
                                        class="invalid-feedback d-block"
                                    >
                                        {{ form.errors.tarif_ids }}
                                    </div>
                                </div>-->
                            </div>

                            <div class="row">
                                <!-- Date de départ -->
                                <div class="col-md-6 mb-3">
                                    <label class="form-label"
                                        >Date de départ
                                        <span class="text-danger"
                                            >*</span
                                        ></label
                                    >
                                    <input
                                        v-model="form.date_depart"
                                        type="datetime-local"
                                        class="form-control"
                                        :class="{
                                            'is-invalid':
                                                form.errors.date_depart,
                                        }"
                                        required
                                    />
                                    <div
                                        v-if="form.errors.date_depart"
                                        class="invalid-feedback"
                                    >
                                        {{ form.errors.date_depart }}
                                    </div>
                                </div>

                                <!-- Date d'arrivée -->
                                <div class="col-md-6 mb-3">
                                    <label class="form-label"
                                        >Date d'arrivée
                                        <span class="text-danger"
                                            >*</span
                                        ></label
                                    >
                                    <input
                                        v-model="form.date_arrivee"
                                        type="datetime-local"
                                        class="form-control"
                                        :class="{
                                            'is-invalid':
                                                form.errors.date_arrivee,
                                        }"
                                        required
                                    />
                                    <div
                                        v-if="form.errors.date_arrivee"
                                        class="invalid-feedback"
                                    >
                                        {{ form.errors.date_arrivee }}
                                    </div>
                                </div>
                            </div>

                            <!-- Statut -->
                            <div class="mb-3">
                                <label class="form-label"
                                    >Statut
                                    <span class="text-danger">*</span></label
                                >
                                <select
                                    v-model="form.statut"
                                    class="form-control"
                                    :class="{
                                        'is-invalid': form.errors.statut,
                                    }"
                                    required
                                >
                                    <option value="programme">Programmé</option>
                                    <option value="en_cours">En cours</option>
                                    <option value="terminé">Terminé</option>
                                    <option value="annulé">Annulé</option>
                                </select>
                                <div
                                    v-if="form.errors.statut"
                                    class="invalid-feedback"
                                >
                                    {{ form.errors.statut }}
                                </div>
                            </div>

                            <div class="d-flex justify-content-end mt-4">
                                <Link
                                    :href="route('voyage.index')"
                                    class="btn btn-light me-2"
                                >
                                    Annuler
                                </Link>
                                <button
                                    type="submit"
                                    class="btn btn-primary"
                                    :disabled="form.processing"
                                >
                                    <span
                                        v-if="form.processing"
                                        class="spinner-border spinner-border-sm me-2"
                                    ></span>
                                    {{
                                        form.processing
                                            ? "Création en cours..."
                                            : "Créer le voyage"
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
