<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import { defineProps, ref } from "vue";
import Swal from "sweetalert2";

const props = defineProps({
    gares: Array,
    trains: Array,
});

const form = useForm({
    name: '',
    train_id: '',
    gare_depart_id: '',
    gare_arrivee_id: '',
    date_depart:'',
    date_arrivee:'',
    prix: '',
    statut:'',
});

// Fonction d'envoi du formulaire
const submit = () => {
    form.post(route("voyage.store"), {
        onSuccess: () => {
            Swal.fire("Succès", "Train ajouté avec succès.", "success");
        },
        onError: (errors) => {
            Swal.fire("Erreur", "Merci de vérifier le formulaire.", "error");
        },
    });
};
</script>

<template>
    <AppLayout>
        <div class="page-header">
            <h4 class="page-title">Ajout de Voyage</h4>
        </div>

        <div class="card">
            <div class="card-body">
                <form @submit.prevent="submit">
                     <!-- Nom du voyage -->
                     <div class="form-group">
                        <label>Nom du Voyage</label>
                        <input type="string" v-model="form.name" class="form-control" placeholder="Bamako - Dakar" required>
                        <span v-if="form.errors.name" class="text-red-500">{{ form.errors.name }}</span>
                    </div>

                    <!-- N°Train -->
                    <div class="form-group">
                        <label>N°Train</label>
                        <select v-model="form.train_id" class="form-control">
                            <option value="" disabled>-- Sélectionner un train --</option>
                            <option v-for="train in props.trains" :key="train.id" :value="train.id">{{ train.numero }}</option>
                        </select>
                        <span v-if="form.errors.name" class="text-red-500">{{ form.errors.name }}</span>
                    </div>
                    

                    <!-- Gare de départ -->
                    <div class="form-group">
                        <label>Gare de départ</label>
                        <select v-model="form.gare_depart_id" class="form-control">
                            <option value="" disabled>-- Sélectionner une gare de depart --</option>
                            <option v-for="gare in props.gares" :key="gare.id" :value="gare.id">{{ gare.nom }}</option>
                        </select>
                        <span v-if="form.errors.name" class="text-red-500">{{ form.errors.name }}</span>
                    </div>

                    <!-- Gare d'arrivée -->
                    <div class="form-group">
                        <label>Gare d'arrivée</label>
                        <select v-model="form.gare_arrivee_id" class="form-control">
                            <option value="" disabled>-- Sélectionner une gare d'arrivée --</option>
                            <option v-for="gare in props.gares" :key="gare.id" :value="gare.id">{{ gare.nom }}</option>
                        </select>
                        <span v-if="form.errors.name" class="text-red-500">{{ form.errors.name }}</span>
                    </div>

                    <!-- Date de départ -->
                    <div class="form-group">
                        <label>Date de  départ</label>
                        <input type="datetime-local" v-model="form.date_depart" class="form-control" required>
                        <span v-if="form.errors.name" class="text-red-500">{{ form.errors.name }}</span>
                    </div>

                    <!-- Date d'arrivée -->
                    <div class="form-group">
                        <label>Date d'arrivée</label>
                        <input type="datetime-local" v-model="form.date_arrivee" class="form-control" required>
                        <span v-if="form.errors.name" class="text-red-500">{{ form.errors.name }}</span>
                    </div>

                    <!-- Prix du voyage -->
                    <div class="form-group">
                        <label>Prix du voyage(FCFA)</label>
                        <input type="number" v-model="form.prix" class="form-control" placeholder="00.000" required>
                        <span v-if="form.errors.name" class="text-red-500">{{ form.errors.name }}</span>
                    </div>

                    <!-- statut -->
                    <div class="form-group">
                        <label>statut</label>
                        <select v-model="form.statut" class="form-control">
                            <option value="" disabled>-- Sélectionner un statut --</option>
                            <option value="programmé">Programmé</option>
                            <option value="en_cours">En Cours</option>
                            <option value="terminé">Terminé</option>
                            <option value="annulé">Annulé</option>
                        </select>
                        <span v-if="form.errors.name" class="text-red-500">{{ form.errors.name }}</span>
                    </div>

                    <!-- Boutons -->
                    <button type="submit" class="btn btn-primary">Valider</button>
                    <button type="reset" class="btn btn-light ml-2">Annuler</button>

                </form>
            </div>
        </div>
    </AppLayout>
</template>
