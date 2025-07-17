<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";

const props = defineProps({
    errors: Object,
    roles: Array, // Changé de Object à Array pour plus de clarté
});

const form = useForm({
    name: "",
    email: "",
    password: "",
    password_confirmation: "",
    roles: "", // Changé à string pour single select
});

const submit = () => {
    form.post(route("user.store"), {
        onSuccess: () => {
            Swal.fire({
                title: "Succès",
                text: "Utilisateur ajouté avec succès.",
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
                    <h4 class="page-title">Nouvel Utilisateur</h4>
                </div>
            </div>
        </div>
        <!-- Page Title Header Ends-->

        <!-- Formulaire -->
        <div class="row flex-grow">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">
                            Formulaire d'Ajout d'Utilisateur
                        </h4>
                        <form class="forms-sample" @submit.prevent="submit">
                            <!-- Nom -->
                            <div class="form-group mb-4">
                                <label for="name">Nom de l'utilisateur</label>
                                <input
                                    type="text"
                                    class="form-control"
                                    id="name"
                                    v-model="form.name"
                                    placeholder="Entrer le nom..."
                                    :class="{ 'is-invalid': form.errors.name }"
                                />
                                <div
                                    v-if="form.errors.name"
                                    class="invalid-feedback"
                                >
                                    {{ form.errors.name }}
                                </div>
                            </div>

                            <!-- Email -->
                            <div class="form-group mb-4">
                                <label for="email">Email</label>
                                <input
                                    type="email"
                                    class="form-control"
                                    id="email"
                                    v-model="form.email"
                                    placeholder="Entrer l'email..."
                                    :class="{ 'is-invalid': form.errors.email }"
                                />
                                <div
                                    v-if="form.errors.email"
                                    class="invalid-feedback"
                                >
                                    {{ form.errors.email }}
                                </div>
                            </div>

                            <!-- Mot de passe -->
                            <div class="form-group mb-4">
                                <label for="password">Mot de passe</label>
                                <input
                                    type="password"
                                    class="form-control"
                                    id="password"
                                    v-model="form.password"
                                    placeholder="Entrer le mot de passe..."
                                    :class="{
                                        'is-invalid': form.errors.password,
                                    }"
                                />
                                <div
                                    v-if="form.errors.password"
                                    class="invalid-feedback"
                                >
                                    {{ form.errors.password }}
                                </div>
                            </div>

                            <!-- Confirmation mot de passe -->
                            <div class="form-group mb-4">
                                <label for="password_confirmation"
                                    >Confirmer le mot de passe</label
                                >
                                <input
                                    type="password"
                                    class="form-control"
                                    id="password_confirmation"
                                    v-model="form.password_confirmation"
                                    placeholder="Confirmer le mot de passe..."
                                    :class="{
                                        'is-invalid':
                                            form.errors.password_confirmation,
                                    }"
                                />
                                <div
                                    v-if="form.errors.password_confirmation"
                                    class="invalid-feedback"
                                >
                                    {{ form.errors.password_confirmation }}
                                </div>
                            </div>

                            <!-- Rôle -->
                            <div class="form-group mb-4">
                                <label for="roles">Rôles</label>
                                <select
                                    class="form-control"
                                    id="roles"
                                    v-model="form.roles"
                                    multiple
                                    :class="{ 'is-invalid': form.errors.roles }"
                                >
                                    <option
                                        v-for="role in roles"
                                        :key="role"
                                        :value="role"
                                    >
                                        {{ role }}
                                    </option>
                                </select>
                                <div
                                    v-if="form.errors.roles"
                                    class="invalid-feedback"
                                >
                                    {{ form.errors.roles }}
                                </div>
                            </div>

                            <div class="d-flex justify-content-end mt-4">
                                <button
                                    type="reset"
                                    class="btn btn-light me-2"
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
