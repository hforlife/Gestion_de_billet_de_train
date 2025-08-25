<!-- Create.vue -->
<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import { Link } from "@inertiajs/vue3";

const props = defineProps({
    voyages: Array,
    gares: Array,
    classes: Array,
});

const form = useForm({
    voyage_id: "",
    classe_wagon_id: "",
    prix: "",
    date_effet: new Date().toISOString().split("T")[0],
    date_expiration: "",
});

const { errors } = form;

const submit = () => {
    form.post(route("tarif.store"), {
        onSuccess: () => {
            Swal.fire("Succès", "Tarif ajouté avec succès.", "success");
        },
        onError: (errors) => {
            Swal.fire("Erreur", "Merci de vérifier le formulaire.", "errors");
        },
    });
};
</script>

<template>
    <AppLayout title="Créer un Tarif">
        <!-- Page Header -->
        <div class="form-header">
            <div class="header-content">
                <div class="header-title-wrapper">
                    <h1 class="page-title">Nouveau Tarif</h1>
                </div>
                <div class="breadcrumb-wrapper">
                    <ul class="breadcrumb">
                        <li class="breadcrumb-item">
                            <Link href="#">Administration</Link>
                            <span class="breadcrumb-divider">/</span>
                        </li>
                        <li class="breadcrumb-item">
                            <Link :href="route('tarif.index')">Tarifs</Link>
                            <span class="breadcrumb-divider">/</span>
                        </li>
                        <li class="breadcrumb-item active">Création</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Form Container -->
        <div class="form-container">
            <div class="form-card">
                <form class="creation-form" @submit.prevent="submit">
                    <!-- Section Informations -->
                    <div class="form-section">
                        <h2 class="section-title">Informations du tarif</h2>

                        <!-- Voyage -->
                        <div class="form-group">
                            <label class="form-label required">Voyage</label>
                            <select
                                v-model="form.voyage_id"
                                class="form-select"
                                :class="{ 'is-invalid': errors.voyage_id }"
                            >
                                <option value="" disabled>
                                    -- Sélectionnez un voyage --
                                </option>
                                <option
                                    v-for="voyage in props.voyages"
                                    :key="voyage.id"
                                    :value="voyage.id"
                                >
                                    {{ voyage.nom }}
                                </option>
                            </select>
                            <p v-if="errors.voyage_id" class="form-error">
                                {{ errors.voyage_id }}
                            </p>
                        </div>

                        <!-- Classe -->
                        <div class="form-group">
                            <label class="form-label required">Classe</label>
                            <select
                                v-model="form.classe_wagon_id"
                                class="form-select"
                                :class="{ 'is-invalid': errors.classe_wagon_id }"
                            >
                                <option value="" disabled>
                                    Sélectionnez une classe
                                </option>
                                <option
                                    v-for="classe in classes"
                                    :key="classe.id"
                                    :value="classe.id"
                                >
                                    {{ classe.classe }}
                                </option>
                            </select>
                            <p
                                v-if="errors.classe_wagon_id"
                                class="form-error"
                            >
                                {{ errors.classe_wagon_id }}
                            </p>
                        </div>
                    </div>

                    <!-- Section Dates -->
                    <div class="form-section">
                        <h2 class="section-title">Période de validité</h2>

                        <!-- Date effet -->
                        <div class="form-group">
                            <label class="form-label required">Date d'effet</label>
                            <input
                                v-model="form.date_effet"
                                type="date"
                                class="form-input"
                                :class="{ 'is-invalid': errors.date_effet }"
                            />
                            <p v-if="errors.date_effet" class="form-error">
                                {{ errors.date_effet }}
                            </p>
                        </div>

                        <!-- Date expiration -->
                        <div class="form-group">
                            <label class="form-label">Date d'expiration</label>
                            <input
                                v-model="form.date_expiration"
                                type="date"
                                class="form-input"
                                :min="form.date_effet"
                                :class="{ 'is-invalid': errors.date_expiration }"
                            />
                            <p
                                v-if="errors.date_expiration"
                                class="form-error"
                            >
                                {{ errors.date_expiration }}
                            </p>
                        </div>
                    </div>

                    <!-- Section Prix -->
                    <div class="form-section">
                        <h2 class="section-title">Tarification</h2>
                        <div class="form-group input-with-unit">
                            <label class="form-label required">Prix de base</label>
                            <input
                                v-model="form.prix"
                                type="number"
                                min="0"
                                step="0.01"
                                class="form-input"
                                :class="{ 'is-invalid': errors.prix }"
                            />
                            <span class="input-unit">FCFA</span>
                            <p v-if="errors.prix" class="form-error">
                                {{ errors.prix }}
                            </p>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="form-actions">
                        <Link :href="route('tarif.index')" class="btn-cancel">
                            Annuler
                        </Link>
                        <button
                            type="submit"
                            class="btn-submit"
                            :disabled="form.processing"
                        >
                            <span v-if="form.processing" class="spinner"></span>
                            {{ form.processing ? "En cours..." : "Valider" }}
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