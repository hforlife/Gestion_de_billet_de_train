<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";

const props = defineProps({
    errors: Object,
    users: Object,
    roles: Array,
});

const form = useForm({
    name: props.users.name || "",
    username: props.users.username || "",
    email: props.users.email || "",
    password: props.users.password || "",
    password_confirmation: "",
    roles: [],
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
        <!-- Page Header -->
        <div class="form-header">
            <div class="header-content">
                <div class="header-title-wrapper">
                    <h1 class="page-title">Nouvel Utilisateur</h1>
                </div>
                <div class="breadcrumb-wrapper">
                    <ul class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="#">Administration</a>
                            <span class="breadcrumb-divider">/</span>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="#">Utilisateurs</a>
                            <span class="breadcrumb-divider">/</span>
                        </li>
                        <li class="breadcrumb-item active">Création</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="form-container">
            <div class="form-card">
                <form class="creation-form" @submit.prevent="submit">
                    <!-- Informations de base -->
                    <div class="form-section">
                        <h2 class="section-title">Informations de l'utilisateur</h2>
                        
                        <!-- Nom -->
                        <div class="form-group">
                            <label for="name" class="form-label required">Nom complet</label>
                            <input
                                type="text"
                                class="form-control"
                                id="name"
                                v-model="form.name"
                                placeholder="Entrer le nom complet..."
                                :class="{ 'is-invalid': form.errors.name }"
                            />
                            <p v-if="form.errors.name" class="form-error">
                                {{ form.errors.name }}
                            </p>
                        </div>

                        <!-- Nom D'utilisateur -->
                        <div class="form-group">
                            <label for="username" class="form-label required">Surnom/Nom d'utilisateur (Username)</label>
                            <input
                                type="text"
                                class="form-control"
                                id="name"
                                v-model="form.username"
                                placeholder="Entrer le nom d'utilisateur..."
                                :class="{ 'is-invalid': form.errors.username }"
                            />
                            <p v-if="form.errors.username" class="form-error">
                                {{ form.errors.username }}
                            </p>
                        </div>

                        <!-- Email -->
                        <div class="form-group">
                            <label for="email" class="form-label required">Adresse email</label>
                            <input
                                type="email"
                                class="form-control"
                                id="email"
                                v-model="form.email"
                                placeholder="Entrer l'adresse email..."
                                :class="{ 'is-invalid': form.errors.email }"
                            />
                            <p v-if="form.errors.email" class="form-error">
                                {{ form.errors.email }}
                            </p>
                        </div>
                    </div>

                    <!-- Sécurité -->
                    <div class="form-section">
                        <h2 class="section-title">Sécurité</h2>
                        
                        <!-- Mot de passe -->
                        <div class="form-group">
                            <label for="password" class="form-label required">Mot de passe</label>
                            <input
                                type="password"
                                class="form-control"
                                id="password"
                                v-model="form.password"
                                placeholder="Entrer le mot de passe..."
                                :class="{ 'is-invalid': form.errors.password }"
                            />
                            <p v-if="form.errors.password" class="form-error">
                                {{ form.errors.password }}
                            </p>
                        </div>

                        <!-- Confirmation mot de passe -->
                        <div class="form-group">
                            <label for="password_confirmation" class="form-label required">Confirmation</label>
                            <input
                                type="password"
                                class="form-control"
                                id="password_confirmation"
                                v-model="form.password_confirmation"
                                placeholder="Confirmer le mot de passe..."
                                :class="{ 'is-invalid': form.errors.password_confirmation }"
                            />
                            <p v-if="form.errors.password_confirmation" class="form-error">
                                {{ form.errors.password_confirmation }}
                            </p>
                        </div>
                    </div>
                                
                    <!-- Rôle -->
                    <div class="form-section">
                        <h2 class="section-title">Rôle</h2>
                        
                        <div class="form-group">
                            <label for="roles" class="form-label required">Rôle utilisateur</label>
                            <select
                                class="form-select"
                                id="roles"
                                v-model="form.roles"
                                :class="{ 'is-invalid': form.errors.roles }"
                            >
                                <option value="" disabled selected>-- Sélectionnez un rôle --</option>
                                <option v-for="role in roles" :key="role" :value="role">
                                    {{ role }}
                                </option>
                            </select>
                            <p v-if="form.errors.roles" class="form-error">
                                {{ form.errors.roles }}
                            </p>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button
                            type="button"
                            class="btn-cancel"
                            @click="form.reset()"
                        >
                            Annuler
                        </button>
                        <button
                            type="submit"
                            class="btn-submit"
                            :disabled="form.processing"
                        >
                            <span v-if="form.processing" class="spinner"></span>
                            {{ form.processing ? 'Enregistrement...' : 'Enregistrer' }}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
/* Style général */
.form-header {
    background-color: #f8f9fa;
    padding: 1.5rem 2rem;
    border-bottom: 1px solid #e1e5eb;
    margin-bottom: 1.5rem;
}

.header-content {
    max-width: 1400px;
    margin: 0 auto;
}

.header-title-wrapper {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
}

.page-title {
    font-size: 1.8rem;
    font-weight: 600;
    color: #2c3e50;
    margin: 0;
}

.breadcrumb-wrapper {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 1rem;
}

.breadcrumb {
    display: flex;
    align-items: center;
    padding: 0;
    margin: 0;
    list-style: none;
    font-size: 0.9rem;
}

.breadcrumb-item {
    color: #6c757d;
    text-decoration: none;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.breadcrumb-item:hover {
    color: #4a6cf7;
}

.breadcrumb-item.active {
    color: #4a6cf7;
    font-weight: 500;
}

.breadcrumb-divider {
    color: #adb5bd;
    margin: 0 0.5rem;
}

.form-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 1.5rem;
}

/* Carte du formulaire */
.form-card {
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    border: 1px solid #e1e5eb;
    overflow: hidden;
    margin-bottom: 2rem;
}

.creation-form {
    padding: 2rem;
}

/* Sections du formulaire */
.form-section {
    margin-bottom: 2rem;
    padding-bottom: 1.5rem;
    border-bottom: 1px solid #f0f0f0;
}

.section-title {
    font-size: 1.2rem;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
}

.section-title::before {
    content: "";
    display: inline-block;
    width: 4px;
    height: 1.2rem;
    background-color: #4a6cf7;
    margin-right: 0.75rem;
    border-radius: 2px;
}

/* Groupes de champs */
.form-group {
    margin-bottom: 1.5rem;
    max-width: 600px;
}

.form-label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
    color: #495057;
}

.form-label.required::after {
    content: " *";
    color: #ff4d4f;
}

/* Champs de formulaire */
.form-select {
    width: 100%;
    padding: 0.75rem 1rem;
    border: 1px solid #e1e5eb;
    border-radius: 6px;
    font-size: 1rem;
    transition: all 0.2s;
    background-color: white;
    appearance: none;
    background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
    background-repeat: no-repeat;
    background-position: right 1rem center;
    background-size: 1em;
}

.form-select:focus {
    border-color: #4a6cf7;
    box-shadow: 0 0 0 0.2rem rgba(74, 108, 247, 0.25);
    outline: none;
}

.form-select.is-invalid {
    border-color: #ff4d4f;
}

.form-select.is-invalid:focus {
    box-shadow: 0 0 0 0.2rem rgba(255, 77, 79, 0.25);
}

/* Switch personnalisé */
.switch-group {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
}

.switch-container {
    display: flex;
    align-items: center;
    gap: 1rem;
}

.switch {
    position: relative;
    display: inline-block;
    width: 50px;
    height: 24px;
}

.switch input {
    opacity: 0;
    width: 0;
    height: 0;
}

.slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #ccc;
    transition: .4s;
    border-radius: 34px;
}

.slider:before {
    position: absolute;
    content: "";
    height: 16px;
    width: 16px;
    left: 4px;
    bottom: 4px;
    background-color: white;
    transition: .4s;
    border-radius: 50%;
}

input:checked + .slider {
    background-color: #4a6cf7;
}

input:focus + .slider {
    box-shadow: 0 0 1px #4a6cf7;
}

input:checked + .slider:before {
    transform: translateX(26px);
}

.switch-label {
    font-weight: 500;
    color: #495057;
}

/* Messages d'erreur */
.form-error {
    color: #ff4d4f;
    font-size: 0.85rem;
    margin-top: 0.5rem;
}

/* Boutons */
.btn-back {
    background-color: white;
    border: 1px solid #e1e5eb;
    color: #495057;
    padding: 0.5rem 1.25rem;
    border-radius: 6px;
    font-size: 0.95rem;
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    text-decoration: none;
}

.btn-back:hover {
    background-color: #f8f9fa;
    border-color: #dae0e5;
}

.form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 1rem;
    margin-top: 2rem;
    padding-top: 1.5rem;
    border-top: 1px solid #f0f0f0;
}

.btn-cancel {
    background-color: white;
    border: 1px solid #e1e5eb;
    color: #495057;
    padding: 0.75rem 1.5rem;
    border-radius: 6px;
    font-size: 1rem;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
}

.btn-cancel:hover {
    background-color: #f8f9fa;
    border-color: #dae0e5;
}

.btn-submit {
    background-color: #4a6cf7;
    border: none;
    color: white;
    padding: 0.75rem 1.5rem;
    border-radius: 6px;
    font-size: 1rem;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.btn-submit:hover:not(:disabled) {
    background-color: #3a5ce4;
    transform: translateY(-1px);
}

.btn-submit:disabled {
    opacity: 0.7;
    cursor: not-allowed;
}

.spinner {
    width: 1rem;
    height: 1rem;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-radius: 50%;
    border-top-color: white;
    animation: spin 1s ease-in-out infinite;
    display: inline-block;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

/* Responsive */
@media (max-width: 768px) {
    .header-title-wrapper {
        flex-direction: column;
        align-items: flex-start;
        gap: 1rem;
    }

    .form-actions {
        flex-direction: column;
    }

    .btn-cancel, .btn-submit {
        width: 100%;
    }

    .creation-form {
        padding: 1.5rem;
    }
}
</style>