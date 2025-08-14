<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import { computed, watch } from "vue";
import Swal from "sweetalert2";

const props = defineProps({
    voyage: Object,
    trains: Array,
    lignes: Array,
    // tarifs: Array,
    gares: Array,
});

const form = useForm({
    name: props.voyage.name,
    train_id: props.voyage.train_id,
    ligne_id: props.voyage.ligne_id,
    tarif_id: props.voyage.tarif_id,
    date_depart: props.voyage.date_depart,
    date_arrivee: props.voyage.date_arrivee,
    statut: props.voyage.statut,
});

const tarifsDisponibles = computed(() => {
    return props.tarifs.filter(t => t.ligne_id == form.ligne_id);
});

watch(() => form.ligne_id, (newLigneId) => {
    if (newLigneId && tarifsDisponibles.value.length) {
        form.tarif_id = tarifsDisponibles.value[0].id;
    }
});

const submit = () => {
    form.put(route('voyage.update', props.voyage.id), {
        onSuccess: () => {
            Swal.fire("Succès", "Voyage modifié avec succès", "success");
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
            <h4 class="page-title">Modification de Voyage</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <Link :href="route('dashboard')">Tableau de bord</Link>
                    </li>
                    <li class="breadcrumb-item">
                        <Link :href="route('voyage.index')">Voyages</Link>
                    </li>
                    <li class="breadcrumb-item active">Modification</li>
                </ol>
            </nav>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h3 class="card-title">Modification du voyage #{{ voyage.id }}</h3>
                    </div>

                    <div class="card-body">
                        <form @submit.prevent="submit">
                            <div class="row">
                                <!-- Nom du voyage -->
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Nom du voyage</label>
                                    <input
                                        v-model="form.name"
                                        type="text"
                                        class="form-control"
                                        :class="{ 'is-invalid': form.errors.name }"
                                        required
                                    />
                                    <div v-if="form.errors.name" class="invalid-feedback">
                                        {{ form.errors.name }}
                                    </div>
                                </div>

                                <!-- Train -->
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Train</label>
                                    <select
                                        v-model="form.train_id"
                                        class="form-control"
                                        :class="{ 'is-invalid': form.errors.train_id }"
                                        required
                                    >
                                        <option value="" disabled>Sélectionnez un train</option>
                                        <option v-for="train in trains" :key="train.id" :value="train.id">
                                            Train N°{{ train.numero }}
                                        </option>
                                    </select>
                                    <div v-if="form.errors.train_id" class="invalid-feedback">
                                        {{ form.errors.train_id }}
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <!-- Ligne -->
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Ligne</label>
                                    <select
                                        v-model="form.ligne_id"
                                        class="form-control"
                                        :class="{ 'is-invalid': form.errors.ligne_id }"
                                        required
                                    >
                                        <option value="" disabled>Sélectionnez une ligne</option>
                                        <option v-for="ligne in lignes" :key="ligne.id" :value="ligne.id">
                                            {{ ligne.nom }} ({{ ligne.gare_depart.nom }} → {{ ligne.gare_arrivee.nom }})
                                        </option>
                                    </select>
                                    <div v-if="form.errors.ligne_id" class="invalid-feedback">
                                        {{ form.errors.ligne_id }}
                                    </div>
                                </div>

                                <!-- Tarif -->
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Tarif appliqué</label>
                                    <select
                                        v-model="form.tarif_id"
                                        class="form-control"
                                        :class="{ 'is-invalid': form.errors.tarif_id }"
                                        :disabled="!form.ligne_id"
                                        required
                                    >
                                        <option value="" disabled>Sélectionnez un tarif</option>
                                        <option v-for="tarif in tarifsDisponibles" :key="tarif.id" :value="tarif.id">
                                            {{ tarif.classe_wagon.nom }} - {{ tarif.prix_base }} FCFA
                                        </option>
                                    </select>
                                    <div v-if="form.errors.tarif_id" class="invalid-feedback">
                                        {{ form.errors.tarif_id }}
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <!-- Date de départ -->
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Date de départ</label>
                                    <input
                                        v-model="form.date_depart"
                                        type="datetime-local"
                                        class="form-control"
                                        :class="{ 'is-invalid': form.errors.date_depart }"
                                        required
                                    />
                                    <div v-if="form.errors.date_depart" class="invalid-feedback">
                                        {{ form.errors.date_depart }}
                                    </div>
                                </div>

                                <!-- Date d'arrivée -->
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Date d'arrivée</label>
                                    <input
                                        v-model="form.date_arrivee"
                                        type="datetime-local"
                                        class="form-control"
                                        :class="{ 'is-invalid': form.errors.date_arrivee }"
                                        required
                                    />
                                    <div v-if="form.errors.date_arrivee" class="invalid-feedback">
                                        {{ form.errors.date_arrivee }}
                                    </div>
                                </div>
                            </div>

                            <!-- Statut -->
                            <div class="mb-3">
                                <label class="form-label">Statut</label>
                                <select
                                    v-model="form.statut"
                                    class="form-control"
                                    :class="{ 'is-invalid': form.errors.statut }"
                                    required
                                >
                                    <option value="programmé">Programmé</option>
                                    <option value="en_cours">En cours</option>
                                    <option value="terminé">Terminé</option>
                                    <option value="annulé">Annulé</option>
                                </select>
                                <div v-if="form.errors.statut" class="invalid-feedback">
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
                                    <span v-if="form.processing" class="spinner-border spinner-border-sm me-2"></span>
                                    {{ form.processing ? 'Enregistrement...' : 'Enregistrer' }}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
