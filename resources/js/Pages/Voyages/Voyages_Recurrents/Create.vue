<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { defineProps } from "vue";

// Props venant du contrôleur
const props = defineProps({
    gares: Array,
    trains: Array,
});

// Formulaire pour créer un voyage récurrent
const form = useForm({
    name: "",
    train_id: "",
    gare_depart_id: "",
    gare_arrivee_id: "",
    jours: [], // tableau de jours sélectionnés
    heure_depart: "",
    prix: "",
    statut: "actif",
});

// Soumission
const submit = () => {
    form.post(route("voyage-reccurent.store"), {
        preserveScroll: true,
        onSuccess: () => {
            Swal.fire("Succès", "Voyages récurrents créés avec succès.", "success");
            form.reset();
        },
        onError: () => {
            Swal.fire("Erreur", "Veuillez vérifier le formulaire.", "error");
        },
    });
};
</script>

<template>
    <AppLayout>
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Créer un Voyage Récurrent</h4>
                </div>
            </div>
        </div>

        <div class="row flex-grow">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <form @submit.prevent="submit">
                            <div class="form-group">
                                <label>Nom du Voyage</label>
                                <input v-model="form.name" class="form-control" placeholder="Ex: Bamako-Kayes (Lundi)" />
                                <div class="text-danger" v-if="form.errors.name">{{ form.errors.name }}</div>
                            </div>

                            <div class="form-group">
                                <label>Train</label>
                                <select v-model="form.train_id" class="form-control">
                                    <option value="" disabled>-- Sélectionner un train --</option>
                                    <option v-for="train in props.trains" :key="train.id" :value="train.id">
                                        Train N°{{ train.numero }}
                                    </option>
                                </select>
                                <div class="text-danger" v-if="form.errors.train_id">{{ form.errors.train_id }}</div>
                            </div>

                            <div class="form-group">
                                <label>Gare de départ</label>
                                <select v-model="form.gare_depart_id" class="form-control">
                                    <option value="" disabled>-- Sélectionner une gare --</option>
                                    <option v-for="gare in props.gares" :key="gare.id" :value="gare.id">{{ gare.nom }}</option>
                                </select>
                                <div class="text-danger" v-if="form.errors.gare_depart_id">{{ form.errors.gare_depart_id }}</div>
                            </div>

                            <div class="form-group">
                                <label>Gare d'arrivée</label>
                                <select v-model="form.gare_arrivee_id" class="form-control">
                                    <option value="" disabled>-- Sélectionner une gare --</option>
                                    <option v-for="gare in props.gares" :key="gare.id" :value="gare.id">{{ gare.nom }}</option>
                                </select>
                                <div class="text-danger" v-if="form.errors.gare_arrivee_id">{{ form.errors.gare_arrivee_id }}</div>
                            </div>

                            <div class="form-group">
                                <label>Jours de départ</label><br />
                                <div class="form-check form-check-inline" v-for="jour in ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche']" :key="jour">
                                    <input class="form-check-input" type="checkbox" :id="jour" :value="jour" v-model="form.jours" />
                                    <label class="form-check-label" :for="jour">{{ jour }}</label>
                                </div>
                                <div class="text-danger" v-if="form.errors.jours">{{ form.errors.jours }}</div>
                            </div>

                            <div class="form-group">
                                <label>Heure de départ</label>
                                <input type="time" v-model="form.heure_depart" class="form-control" />
                                <div class="text-danger" v-if="form.errors.heure_depart">{{ form.errors.heure_depart }}</div>
                            </div>

                            <div class="form-group">
                                <label>Prix du billet</label>
                                <input type="number" v-model="form.prix" class="form-control" placeholder="Ex: 5000" />
                                <div class="text-danger" v-if="form.errors.prix">{{ form.errors.prix }}</div>
                            </div>

                            <div class="form-group mt-4 d-flex justify-content-end">
                                <button type="submit" class="btn btn-primary" :disabled="form.processing">
                                    <span v-if="form.processing" class="spinner-border spinner-border-sm"></span>
                                    {{ form.processing ? 'En cours...' : 'Valider' }}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
