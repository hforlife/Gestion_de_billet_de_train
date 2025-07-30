<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import { defineProps } from 'vue';
import Swal from "sweetalert2";

const props = defineProps({
    trains: Object,
    errors: Object,
});

// Initialisation du formulaire
const form = useForm({
    numero: props.trains?.numero || '',
    sens: props.trains?.sens || '',
    etat: props.trains?.etat || '',
    nombre_agents: props.trains?.nombre_agents || 0, // Ajout d'un champ pour le nombre d'agents
});

// Fonction d'envoi du formulaire
const submit = () => {
  form.put(route('train.update', props.trains.id), {
    onSuccess: () => {
            Swal.fire({
                title: "Succès",
                text: "Information du train modifié(e) avec succès.",
                icon: "success",
                confirmButtonText: "OK",
            });
            form.reset();
        },
        onError: (errors) => {
            Swal.fire({
                title: "Erreur",
                text: "Veuillez corriger les erreurs dans le formulaire.",
                icon: "error",
                confirmButtonText: "OK",
            });
        },
  });
};
</script>
<template>
    <AppLayout>
        <!-- Page Title Header Starts-->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Modifier Train</h4>
                </div>
            </div>
        </div>
        <!-- Page Title Header Ends-->
        <div></div>
        <!-- Fromulaire -->
        <div class="row flex-grow">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">
                            Formulaire de modification de train
                        </h4>
                        <!-- <p class="card-description"> Basic form layout </p> -->
                        <form class="forms-sample" @submit.prevent="submit">
                            <!-- Nom -->
                            <div class="form-group">
                                <label for="numero">Numéro du train</label>
                                <input
                                    type="text"
                                    class="form-control"
                                    v-model="form.numero"
                                     :class="{ 'is-invalid': form.errors.numero }"
                                    placeholder="Entrer Nom"
                                    required
                                />
                                <div
                                    v-if="form.errors.numero"
                                    class="invalid-feedback"
                                >
                                    {{ form.errors.numero }}
                                </div>
                            </div>

                             <!-- Sens -->
                            <div class="form-group">
                                <label for="sens"
                                    >Sens du train</label
                                >
                                <select
                                    class="form-control"
                                    v-model="form.sens"
                                    :class="{ 'is-invalid': form.errors.sens }"
                                    >
                                    <option value="" disabled>
                                        -- Choisissez un sens --
                                    </option>
                                    <option value="Bamako-Kayes">Bamako-Kayes</option>
                                    <option value="Kayes-Bamako">Kayes-Bamako</option>
                                </select>
                                <div
                                v-if="form.errors.sens"
                                class="invalid-feedback"
                                >
                                {{ form.errors.sens }}
                            </div>
                        </div>

                            <!-- Etat -->
                            <div class="form-group">
                                <label for="etat"
                                    >Etat du train</label
                                >
                                <select
                                    class="form-control"
                                    v-model="form.etat"
                                    :class="{ 'is-invalid': form.errors.etat }"
                                    >
                                    <option value="" disabled>
                                        -- Choisissez un etat --
                                    </option>
                                    <option value="actif">Actif</option>
                                    <option value="en_maintenance">
                                        Maintenance
                                    </option>
                                </select>
                                <div
                                v-if="form.errors.etat"
                                class="invalid-feedback"
                                >
                                {{ form.errors.etat }}
                            </div>
                        </div>

                        <!-- Nombre d'agents -->
                        <div class="form-group">
                            <label for="numero">Nombre d'agents</label>
                            <input
                                type="text"
                                class="form-control"
                                v-model="form.nombre_agents"
                                 :class="{ 'is-invalid': form.errors.nombre_agents }"
                                placeholder="Entrer Nom"
                                required
                            />
                            <div
                                v-if="form.errors.nombre_agents"
                                class="invalid-feedback"
                            >
                                {{ form.errors.nombre_agents }}
                            </div>
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
