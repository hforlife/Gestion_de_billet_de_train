<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { defineProps } from "vue";

const props = defineProps({
    ClassesWagon: Object,
});

const form = useForm({
    classe: props.ClassesWagon.classe,
    prix_multiplier: props.ClassesWagon.prix_multiplier,
});

const { errors } = form;

const submit = () => {
    form.put(route("classe.update", props.ClassesWagon.id), {
        onSuccess: () => {
            Swal.fire(
                "Succès",
                "Classe de wagon mise à jour avec succès.",
                "success"
            );
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
                    <h4 class="page-title">Modifier Classe de Wagon</h4>
                </div>
            </div>
        </div>

        <div class="row flex-grow">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">
                            Formulaire d'édition de classe de wagon
                        </h4>
                        <form class="forms-sample" @submit.prevent="submit">
                            <!-- Classe -->
                            <div class="form-group">
                                <label for="classe">Classe</label>
                                <select
                                    id="classe"
                                    class="form-control"
                                    v-model="form.classe"
                                >
                                    <option value="" disabled>
                                        -- Choisir une classe --
                                    </option>
                                    <option value="premiere">Première</option>
                                    <option value="deuxieme">Deuxième</option>
                                </select>
                                <span
                                    v-if="errors.classe"
                                    class="text-danger"
                                    >{{ errors.classe }}</span
                                >
                            </div>

                            <!-- Prix Multiplier -->
                            <div class="form-group">
                                <label for="prix_multiplier"
                                    >Multiplicateur de prix</label
                                >
                                <input
                                    type="text"
                                    id="prix_multiplier"
                                    class="form-control"
                                    v-model="form.prix_multiplier"
                                />
                                <span
                                    v-if="errors.prix_multiplier"
                                    class="text-danger"
                                    >{{ errors.prix_multiplier }}</span
                                >
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
