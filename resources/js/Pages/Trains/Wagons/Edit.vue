<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { defineProps } from "vue";

const props = defineProps({
    wagon: Object,
    trains: Array,
    classes: Array,
});

const form = useForm({
    train_id: props.wagon.train_id,
    classe_id: props.wagon.classe_id,
    numero_wagon: props.wagon.numero_wagon,
    nombre_sieges: props.wagon.nombre_sieges,
});

const isValidNumero = () => {
    const regex = /^2020\d{3}$/;
    return regex.test(form.numero_wagon);
};

const submit = () => {
    if (!isValidNumero()) {
        Swal.fire(
            "Erreur",
            "Le numéro du wagon doit commencer par '2020' suivi de 3 chiffres.",
            "error"
        );
        return;
    }
    form.put(route("wagon.update", props.wagon.id), {
        onSuccess: () => {
            Swal.fire("Succès", "Wagon modifié avec succès.", "success");
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
        <!-- En-tête de page -->
        <div class="form-header">
            <div class="header-content">
                <div class="header-title-wrapper">
                    <h1 class="page-title">Nouveau Wagon</h1>
                    <!-- <nav class="breadcrumb-wrapper">
                        <ol class="breadcrumb">
                            <li>
                                <a href="#" class="breadcrumb-item">Accueil</a>
                                <span class="breadcrumb-divider">/</span>
                            </li>
                            <li>
                                <a href="#" class="breadcrumb-item">Wagons</a>
                                <span class="breadcrumb-divider">/</span>
                            </li>
                            <li>
                                <span class="breadcrumb-item active">Nouveau</span>
                            </li>
                        </ol>
                    </nav> -->
                </div>
            </div>
        </div>

        <div class="form-container">
            <div class="form-card">
                <div class="creation-form">
                    <h2 class="section-title">
                        <i class="mdi mdi-train"></i>
                        Formulaire d'ajout de wagon
                    </h2>
                    <form @submit.prevent="submit">
                        <!-- Train -->
                        <div class="form-group">
                            <label for="train_id" class="form-label required"
                                >Train</label
                            >
                            <select
                                class="form-select"
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
                            <label for="classe_id" class="form-label required"
                                >Classe du wagon</label
                            >
                            <select
                                class="form-select"
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
                            <label
                                for="numero_wagon"
                                class="form-label required"
                                >Numéro du wagon</label
                            >
                            <input
                                type="text"
                                class="form-input"
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
                            <label
                                for="nombre_sieges"
                                class="form-label required"
                                >Nombre de sièges</label
                            >
                            <input
                                type="number"
                                class="form-input"
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

                        <!-- Actions du formulaire -->
                        <div class="form-actions">
                            <Link
                                :href="route('wagon.index')"
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
                                {{
                                    form.processing ? "En cours..." : "Valider"
                                }}
                            </button>
                        </div>
                    </form>
                </div>
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

.section-title i {
    color: #4a6cf7;
}

/* Grille de formulaire */
.form-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 1.5rem;
}

/* Groupes de champs */
.form-group {
    margin-bottom: 1rem;
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
    right: 0.75rem;
    top: 50%;
    transform: translateY(-50%);
    font-size: 0.8rem;
    color: #6c757d;
    background-color: #f8f9fa;
    padding: 0 0.25rem;
    border-radius: 3px;
}

/* Select personnalisé */
.form-select {
    appearance: none;
    background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
    background-repeat: no-repeat;
    background-position: right 1rem center;
    background-size: 1em;
}

/* Messages d'erreur */
.form-error {
    color: #ff4d4f;
    font-size: 0.85rem;
    margin-top: 0.5rem;
}

/* Boutons */
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
    to {
        transform: rotate(360deg);
    }
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

    .btn-cancel,
    .btn-submit {
        width: 100%;
    }

    .creation-form {
        padding: 1.5rem;
    }

    .form-grid {
        grid-template-columns: 1fr;
    }
}
</style>
