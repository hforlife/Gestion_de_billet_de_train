<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { defineProps } from "vue";

const props = defineProps({
    trains: Array,
});

const form = useForm({
    train_id: "",
    nom: "",
    nombre_places: 0,
});

const submit = () => {
    form.post(route("wagon.store"), {
        onSuccess: () => {
            Swal.fire("Succès", "Wagon ajouté avec succès.", "success");
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
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Ajouter un wagon</h4>
                </div>
            </div>
        </div>

        <div class="row flex-grow">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <form class="forms-sample" @submit.prevent="submit">
                            <div class="form-group">
                                <label for="train_id">Train</label>
                                <select class="form-control" v-model="form.train_id" id="train_id">
                                    <option value="" disabled>-- Choisir un train --</option>
                                    <option v-for="train in trains" :key="train.id" :value="train.id">
                                        {{ train.numero }}
                                    </option>
                                </select>
                                <div v-if="form.errors.train_id" class="text-danger">{{ form.errors.train_id }}</div>
                            </div>

                            <div class="form-group">
                                <label for="nom">Nom du wagon</label>
                                <input
                                    type="text"
                                    class="form-control"
                                    id="nom"
                                    v-model="form.nom"
                                    placeholder="Nom du wagon"
                                />
                                <div v-if="form.errors.nom" class="text-danger">{{ form.errors.nom }}</div>
                            </div>

                            <div class="form-group">
                                <label for="nombre_places">Nombre de places</label>
                                <input
                                    type="number"
                                    class="form-control"
                                    id="nombre_places"
                                    v-model="form.nombre_places"
                                    placeholder="Nombre de places"
                                />
                                <div v-if="form.errors.nombre_places" class="text-danger">
                                    {{ form.errors.nombre_places }}
                                </div>
                            </div>

                            <div class="d-flex justify-content-end">
                                <button type="submit" class="btn btn-primary" :disabled="form.processing">
                                    <span v-if="form.processing" class="spinner-border spinner-border-sm"></span>
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
