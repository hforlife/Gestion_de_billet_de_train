<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import { defineProps, ref } from "vue";
import Swal from "sweetalert2";

const props = defineProps({
    ventes: Object,
    voyages: Object,
    trains: Object,
});

const form = useForm({
    client_nom: props.ventes?.client_nom || '',
    voyage_id: props.ventes?.voyage_id || '',
    train_id: props.ventes?.train_id || '',
    prix: props.ventes?.prix || '',
    bagage: props.ventes?.bagage || '',
    poids_bagage: props.ventes?.poids_bagage || '',
});

const updatePrix = () => {
  const voyage = props.voyages.find(v => v.id === form.voyage_id);
  form.prix = voyage ? voyage.prix : '';
};

const submit = () => {
    form.put(route("vente.update", props.ventes.id), {
        onSuccess: () => {
            Swal.fire({
                icon: 'success',
                title: 'Modification éffectué avec succès !',
                showConfirmButton: false,
                timer: 2000
            });
        },
    });
};
</script>

<template>
    <AppLayout>
        <div class="page-header">
            <h4 class="page-title">Vente de Billet</h4>
        </div>

        <div class="card">
            <div class="card-body">
                <form @submit.prevent="submit">

                    <!-- Client -->
                    <div class="form-group">
                        <label>Nom du client</label>
                        <input type="text" v-model="form.client_nom" class="form-control" placeholder="Nom du client">
                    </div>

                    <!-- Voyage -->
                    <div class="form-group">
                        <label>Voyage</label>
                        <select v-model="form.voyage_id" @change="updatePrix" class="form-control">
                            <option disabled value="">-- Choisir un voyage --</option>
                            <option v-for="voyage in props.voyages" :key="voyage.id" :value="voyage.id">
                                {{ voyage.name }}
                            </option>
                        </select>

                    </div>

                    <!-- Train -->
                    <div class="form-group">
                        <label>Train</label>
                        <select v-model="form.train_id"  class="form-control">
                            <option value="" disabled>-- Sélectionner un train --</option>
                            <option v-for="train in props.trains" :key="train.id" :value="train.id">{{ train.numero }}</option>
                        </select>
                    </div>

                    <!-- Prix -->
                    <div class="form-group">
                        <label>Prix du billet</label>
                        <input type="number" v-model="form.prix" :message="form.errors.prix" readonly class="form-control" />
                    </div>

                    <!-- Bagages -->
                    <div class="form-group">
                        <label>
                            <input type="checkbox" v-model="form.bagage"> Bagages ?
                        </label>
                    </div>

                    <!-- Poids du bagage -->
                    <div v-if="form.bagage" class="form-group">
                        <label>Poids du bagage (Kg)</label>
                        <input type="number" v-model="form.poids_bagage" class="form-control" placeholder="Poids du bagage">
                    </div>

                    <!-- Boutons -->
                    <button type="submit" class="btn btn-primary">Valider</button>
                    <button type="reset" class="btn btn-light ml-2">Annuler</button>

                </form>
            </div>
        </div>
    </AppLayout>
</template>
