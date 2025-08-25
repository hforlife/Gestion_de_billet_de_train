<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { Link } from "@inertiajs/vue3";

const form = useForm({
    nom: "",
    adresse: "",
    type: "",
    distance_km: 0,
    internet: false,
    electricite: false,
    nombre_guichets: 0,
    controle_bagage: "physique",
});

const submit = () => {
    form.post(route("gare.store"), {
        preserveScroll: true,
        onSuccess: () => {
            Swal.fire({
                title: "Succès",
                text: "La gare a été créée avec succès",
                icon: "success",
                confirmButtonText: "OK",
            }).then(() => {
                form.reset();
            });
        },
        onError: () => {
            Swal.fire({
                title: "Erreur",
                text: "Veuillez corriger les erreurs dans le formulaire",
                icon: "error",
                confirmButtonText: "OK",
            });
        },
    });
};
</script>

<template>
    <AppLayout>
        <!-- En-tête modernisé -->
        <div class="form-header">
            <div class="header-content">
                <div class="header-title-wrapper">
                    <h1 class="page-title">Création d'une nouvelle gare</h1>
                    <Link
                        :href="route('gare.index')"
                        class="btn-back"
                    >
                        <ArrowLeft size="16" class="me-1" />
                        Retour à la liste
                    </Link>
                </div>
                <div class="breadcrumb-wrapper">
                    <ul class="breadcrumb">
                        <li class="breadcrumb-item">
                            <Link :href="route('dashboard')">Tableau de bord</Link>
                            <span class="breadcrumb-divider">/</span>
                        </li>
                        <li class="breadcrumb-item">
                            <Link :href="route('gare.index')">Gares</Link>
                            <span class="breadcrumb-divider">/</span>
                        </li>
                        <li class="breadcrumb-item active">Nouvelle gare</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Contenu principal -->
        <div class="form-container">
            <div class="form-card">
                <form class="creation-form" @submit.prevent="submit">
                    <!-- Section 1: Informations de base -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="mdi mdi-information-outline me-2"></i>
                            Informations de base
                        </h3>
                        <div class="form-group">
                            <label class="form-label required">Nom de la gare</label>
                            <input
                                type="text"
                                class="form-input"
                                v-model="form.nom"
                                placeholder="Ex: Gare de Bamako"
                                :class="{ 'is-invalid': form.errors.nom }"
                                required
                            />
                            <div v-if="form.errors.nom" class="form-error">
                                {{ form.errors.nom }}
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label required">Adresse</label>
                            <input
                                type="text"
                                class="form-input"
                                placeholder="Ex: Avenue de la Gare, Bamako"
                                v-model="form.adresse"
                                :class="{ 'is-invalid': form.errors.adresse }"
                                required
                            />
                            <div v-if="form.errors.adresse" class="form-error">
                                {{ form.errors.adresse }}
                            </div>
                        </div>
                    </div>

                    <!-- Section 2: Type et caractéristiques -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="mdi mdi-train-car me-2"></i>
                            Caractéristiques
                        </h3>
                        <div class="form-group">
                            <label class="form-label required">Type de gare</label>
                            <select
                                class="form-select"
                                v-model="form.type"
                                :class="{ 'is-invalid': form.errors.type }"
                                required
                            >
                                <option value="" disabled selected>Sélectionnez un type</option>
                                <option value="principale">Principale</option>
                                <option value="passage">Passage</option>
                                <option value="halte">Halte</option>
                                <option value="fermee">Fermée</option>
                            </select>
                            <div v-if="form.errors.type" class="form-error">
                                {{ form.errors.type }}
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label required">Distance depuis Bamako (km)</label>
                            <div class="input-with-unit">
                                <input
                                    type="number"
                                    step="0.01"
                                    class="form-input"
                                    v-model="form.distance_km"
                                    :class="{ 'is-invalid': form.errors.distance_km }"
                                    required
                                />
                                <span class="input-unit">km</span>
                            </div>
                            <div v-if="form.errors.distance_km" class="form-error">
                                {{ form.errors.distance_km }}
                            </div>
                        </div>
                    </div>

                    <!-- Section 3: Équipements -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="mdi mdi-wifi me-2"></i>
                            Équipements
                        </h3>
                        <div class="form-group">
                            <label class="form-label">Disponibilité</label>
                            <div class="switch-group">
                                <label class="switch">
                                    <input type="checkbox" v-model="form.internet" />
                                    <span class="slider round"></span>
                                    <span class="switch-text">Accès Internet</span>
                                </label>
                            </div>
                            <div class="switch-group">
                                <label class="switch">
                                    <input type="checkbox" v-model="form.electricite" />
                                    <span class="slider round"></span>
                                    <span class="switch-text">Électricité</span>
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Section 4: Services -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="mdi mdi-ticket-confirmation me-2"></i>
                            Services
                        </h3>
                        <div class="form-group">
                            <label class="form-label required">Nombre de guichets</label>
                            <input
                                type="number"
                                class="form-input"
                                v-model="form.nombre_guichets"
                                min="0"
                                :class="{ 'is-invalid': form.errors.nombre_guichets }"
                                required
                            />
                            <div v-if="form.errors.nombre_guichets" class="form-error">
                                {{ form.errors.nombre_guichets }}
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label required">Contrôle des bagages</label>
                            <select
                                class="form-select"
                                v-model="form.controle_bagage"
                                :class="{ 'is-invalid': form.errors.controle_bagage }"
                                required
                            >
                                <option value="" disabled selected>Sélectionnez une option</option>
                                <option value="physique">Physique</option>
                                <option value="electronique">Électronique</option>
                                <option value="aucun">Aucun</option>
                            </select>
                            <div v-if="form.errors.controle_bagage" class="form-error">
                                {{ form.errors.controle_bagage }}
                            </div>
                        </div>
                    </div>

                    <!-- Boutons d'action -->
                    <div class="form-actions">
                        <Link
                            :href="route('gare.index')"
                            class="btn-cancel"
                        >
                            Annuler
                        </Link>
                        <button
                            type="submit"
                            class="btn-submit"
                            :disabled="form.processing"
                        >
                            <span
                                v-if="form.processing"
                                class="spinner"
                            ></span>
                            {{ form.processing ? 'Enregistrement en cours...' : 'Enregistrer la gare' }}
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
    max-width: 1200px;
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
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 1.5rem;
}

/* Carte du formulaire */
.form-card {
    background-color: white;
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    border: 1px solid #e1e5eb;
    overflow: hidden;
    margin-bottom: 2rem;
}

.creation-form {
    padding: 2rem;
}

/* Sections du formulaire */
.form-section {
    margin-bottom: 2.5rem;
    padding-bottom: 1.5rem;
    border-bottom: 1px solid #f0f0f0;
}

.form-section:last-child {
    border-bottom: none;
    margin-bottom: 1.5rem;
}

.section-title {
    font-size: 1.2rem;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
}

/* Groupes de champs */
.form-group {
    margin-bottom: 1.5rem;
}

.form-label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
    color: #495057;
    font-size: 0.95rem;
}

.form-label.required::after {
    content: " *";
    color: #ff4d4f;
}

/* Champs de formulaire */
.form-input,
.form-select {
    width: 100%;
    padding: 0.75rem 1rem;
    border: 1px solid #e1e5eb;
    border-radius: 8px;
    font-size: 1rem;
    transition: all 0.2s;
    background-color: white;
}

.form-input:focus,
.form-select:focus {
    border-color: #4a6cf7;
    box-shadow: 0 0 0 0.2rem rgba(74, 108, 247, 0.15);
    outline: none;
}

.form-input.is-invalid,
.form-select.is-invalid {
    border-color: #ff4d4f;
}

.form-input.is-invalid:focus,
.form-select.is-invalid:focus {
    box-shadow: 0 0 0 0.2rem rgba(255, 77, 79, 0.15);
}

.input-with-unit {
    position: relative;
}

.input-with-unit .input-unit {
    position: absolute;
    right: 1rem;
    top: 50%;
    transform: translateY(-50%);
    color: #6c757d;
    font-size: 0.9rem;
}

/* Select personnalisé */
.form-select {
    appearance: none;
    background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
    background-repeat: no-repeat;
    background-position: right 1rem center;
    background-size: 1em;
}

/* Switch personnalisé */
.switch-group {
    margin-bottom: 0.75rem;
}

.switch {
    position: relative;
    display: flex;
    align-items: center;
    gap: 0.75rem;
    cursor: pointer;
    user-select: none;
}

.switch input {
    opacity: 0;
    width: 0;
    height: 0;
}

.slider {
    position: relative;
    display: inline-block;
    width: 50px;
    height: 24px;
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

.switch-text {
    font-size: 0.95rem;
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
    border-radius: 8px;
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
    border-radius: 8px;
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
    border-radius: 8px;
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
