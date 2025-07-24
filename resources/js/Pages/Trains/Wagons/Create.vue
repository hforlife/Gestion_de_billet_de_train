<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { defineProps } from "vue";

const props = defineProps({
    trains: Array,
    classes: Array,
});

const form = useForm({
    train_id: "",
    classe_id: "",
    numero_wagon: "",
    nombre_sieges: "",
});

const isValidNumero = () => {
    const regex = /^2020\d{3}$/;
    return regex.test(form.numero_wagon);
};

const submit = () => {
    if (!isValidNumero()) {
        Swal.fire("Erreur", "Le numéro du wagon doit commencer par '2020' suivi de 3 chiffres.", "error");
        return;
    }
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
                            <!-- Train -->
                            <div class="form-group">
                                <label for="train_id">Train</label>
                                <select
                                    class="form-control"
                                    v-model="form.train_id"
                                    id="train_id"
                                >
                                    <option value="" disabled>
                                        -- Choisir un train --
                                    </option>
                                    <option
                                        v-for="train in trains"
                                        :key="train.id"
                                        :value="train.id"
                                    >
                                        {{ train.numero }}
                                    </option>
                                </select>
                                <div
                                    v-if="form.errors.train_id"
                                    class="text-danger"
                                >
                                    {{ form.errors.train_id }}
                                </div>
                            </div>

                            <!-- Classe -->
                            <div class="form-group">
                                <label for="classe_id">Classe du wagon</label>
                                <select
                                    class="form-control"
                                    v-model="form.classe_id"
                                    id="classe_id"
                                >
                                    <option value="" disabled>
                                        -- Choisir une classe --
                                    </option>
                                    <option
                                        v-for="classe in classes"
                                        :key="classe.id"
                                        :value="classe.id"
                                    >
                                        {{ classe.classe }}
                                    </option>
                                </select>
                                <div
                                    v-if="form.errors.classe_id"
                                    class="text-danger"
                                >
                                    {{ form.errors.classe_id }}
                                </div>
                            </div>

                            <!-- Numéro du wagon -->
                            <div class="form-group">
                                <label for="numero_wagon"
                                    >Numéro du wagon</label
                                >
                                <input
                                    type="text"
                                    class="form-control"
                                    id="numero_wagon"
                                    v-model="form.numero_wagon"
                                    placeholder="Ex: 2020123"
                                    pattern="^2020\d{3}$"
                                    value="2020"
                                    title="Le numéro doit commencer par '2020' suivi de 3 chiffres"
                                    required
                                />
                                <div
                                    v-if="form.errors.numero_wagon"
                                    class="text-danger"
                                >
                                    {{ form.errors.numero_wagon }}
                                </div>
                            </div>

                            <!-- Nombre de sièges -->
                            <div class="form-group">
                                <label for="nombre_sieges"
                                    >Nombre de sièges</label
                                >
                                <input
                                    type="number"
                                    class="form-control"
                                    id="nombre_sieges"
                                    v-model="form.nombre_sieges"
                                    placeholder="Ex: 40"
                                />
                                <div
                                    v-if="form.errors.nombre_sieges"
                                    class="text-danger"
                                >
                                    {{ form.errors.nombre_sieges }}
                                </div>
                            </div>

                            <div class="d-flex justify-content-end">
                                <button
                                    type="submit"
                                    class="btn btn-primary"
                                    :disabled="form.processing"
                                >
                                    <span
                                        v-if="form.processing"
                                        class="spinner-border spinner-border-sm"
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
