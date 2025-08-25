<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { defineProps, watch } from "vue";
import { Link } from "@inertiajs/vue3";

const props = defineProps({
    categories: Array,
});

const form = useForm({
    categorie_id: "",
    poids_min: 0,
    poids_max: "",
    prix_par_kg: "",
});

watch(
    () => form.poids_max,
    (val) => {
        if (val < form.poids_min) {
            Swal.fire(
                "Attention",
                "Le poids maximum doit être supérieur au minimum",
                "warning"
            );
        }
    }
);
watch(
    () => form.poids_min,
    (val) => {
        if (val < 0) {
            Swal.fire(
                "Attention",
                "Le poids minimum ne peut pas être négatif",
                "warning"
            );
        }
    }
);

const submit = () => {
    form.post(route("setting.store"), {
        preserveScroll: true,
        onSuccess: () => {
            Swal.fire("Succès", "Paramètres système mis à jour.", "success");
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
        <div class="settings-header">
            <div class="header-content">
                <h1 class="page-title">Paramètres Catégorie Colis</h1>
                <p class="page-subtitle">
                    Gestion des configurations des Catégorie de Colis
                </p>
            </div>
        </div>

        <!-- Contenu principal -->
        <div class="settings-container">
            <!-- Section des cartes de paramètres -->
            <div class="settings-grid">
                <!-- Carte 1: Prix par catégorie -->
                <div class="settings-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-box-open icon"></i>
                            Tarification par catégorie
                        </h2>
                        <p class="card-description">
                            Définir les prix en fonction du poids des colis
                        </p>
                    </div>

                    <div class="card-body">
                        <form class="settings-form" @submit.prevent="submit">
                            <div class="form-group">
                                <label for="categorie_id" class="form-label"
                                    >Catégorie de colis</label
                                >
                                <select
                                    id="categorie_id"
                                    class="form-control select-input"
                                    v-model="form.categorie_id"
                                    required
                                >
                                    <option disabled value="">
                                        -- Sélectionner une catégorie --
                                    </option>
                                    <option
                                        v-for="cat in props.categories"
                                        :key="cat.id"
                                        :value="cat.id"
                                    >
                                        {{ cat.nom }}
                                    </option>
                                </select>
                                <div
                                    v-if="form.errors.categorie_id"
                                    class="error-message"
                                >
                                    <i class="fas fa-exclamation-circle"></i>
                                    {{ form.errors.categorie_id }}
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group half-width">
                                    <label for="poids_min" class="form-label"
                                        >Poids min (kg)</label
                                    >
                                    <input
                                        type="number"
                                        id="poids_min"
                                        v-model="form.poids_min"
                                        class="form-control number-input"
                                        placeholder="0.0"
                                        min="0"
                                        step="0.1"
                                        required
                                    />
                                    <div
                                        v-if="form.errors.poids_min"
                                        class="error-message"
                                    >
                                        <i
                                            class="fas fa-exclamation-circle"
                                        ></i>
                                        {{ form.errors.poids_min }}
                                    </div>
                                </div>

                                <div class="form-group half-width">
                                    <label for="poids_max" class="form-label"
                                        >Poids max (kg)</label
                                    >
                                    <input
                                        type="number"
                                        id="poids_max"
                                        v-model="form.poids_max"
                                        class="form-control number-input"
                                        placeholder="10.0"
                                        min="0"
                                        step="0.1"
                                        required
                                    />
                                    <div
                                        v-if="form.errors.poids_max"
                                        class="error-message"
                                    >
                                        <i
                                            class="fas fa-exclamation-circle"
                                        ></i>
                                        {{ form.errors.poids_max }}
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="prix_par_kg" class="form-label"
                                    >Prix au kg (FCFA)</label
                                >
                                <div class="input-with-unit">
                                    <input
                                        type="number"
                                        id="prix_par_kg"
                                        v-model="form.prix_par_kg"
                                        class="form-control number-input"
                                        placeholder="250"
                                        min="0"
                                        step="10"
                                        required
                                    />
                                    <!-- <span class="input-unit">FCFA</span> -->
                                </div>
                                <div
                                    v-if="form.errors.prix_par_kg"
                                    class="error-message"
                                >
                                    <i class="fas fa-exclamation-circle"></i>
                                    {{ form.errors.prix_par_kg }}
                                </div>
                            </div>

                            <div class="form-actions">
                                <button
                                    type="reset"
                                    class="btn btn-secondary"
                                    @click="form.reset()"
                                >
                                    <i class="fas fa-undo"></i> Réinitialiser
                                </button>
                                <button
                                    type="submit"
                                    class="btn btn-primary"
                                    :disabled="form.processing"
                                >
                                    <template v-if="form.processing">
                                        <i class="fas fa-spinner fa-spin"></i>
                                        Enregistrement...
                                    </template>
                                    <template v-else>
                                        <i class="fas fa-save"></i> Enregistrer
                                    </template>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
/* Style général */
.settings-header {
    background-color: #f8f9fa;
    padding: 1.5rem 2rem;
    border-bottom: 1px solid #e1e5eb;
    margin-bottom: 2rem;
}

.header-content {
    max-width: 1200px;
    margin: 0 auto;
}

.page-title {
    font-size: 1.8rem;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 0.5rem;
}

.page-subtitle {
    font-size: 1rem;
    color: #7a8a9b;
    margin-bottom: 0;
}

.settings-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 1rem;
}

.settings-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2rem;
}

/* Cartes de paramètres */
.settings-card {
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    border: 1px solid #e1e5eb;
    overflow: hidden;
    transition: transform 0.2s, box-shadow 0.2s;
}

.settings-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.card-header {
    padding: 1.25rem 1.5rem;
    border-bottom: 1px solid #f0f0f0;
    background-color: #f9fafb;
}

.card-title {
    font-size: 1.2rem;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 0.5rem;
    display: flex;
    align-items: center;
}

.card-title .icon {
    margin-right: 0.75rem;
    color: #4a6cf7;
}

.card-description {
    font-size: 0.85rem;
    color: #6c757d;
    margin-bottom: 0;
}

.card-body {
    padding: 1.5rem;
}

/* Formulaires */
.settings-form {
    display: flex;
    flex-direction: column;
    gap: 1.25rem;
}

.form-group {
    margin-bottom: 0;
}

.form-label {
    display: block;
    font-size: 0.9rem;
    font-weight: 500;
    color: #495057;
    margin-bottom: 0.5rem;
}

.form-control {
    width: 100%;
    padding: 0.6rem 0.75rem;
    font-size: 0.9rem;
    border: 1px solid #ced4da;
    border-radius: 4px;
    transition: border-color 0.15s, box-shadow 0.15s;
}

.form-control:focus {
    border-color: #4a6cf7;
    box-shadow: 0 0 0 0.2rem rgba(74, 108, 247, 0.25);
}

.select-input {
    appearance: none;
    background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
    background-repeat: no-repeat;
    background-position: right 0.75rem center;
    background-size: 1rem;
}

.number-input {
    text-align: right;
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

.form-row {
    display: flex;
    gap: 1rem;
}

.half-width {
    flex: 1;
}

/* Radio boutons */
.radio-group {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
}

.radio-option {
    display: flex;
    flex-direction: column;
    padding: 0.75rem;
    border: 1px solid #e1e5eb;
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.2s;
}

.radio-option:hover {
    border-color: #4a6cf7;
    background-color: #f8f9ff;
}

.radio-option input {
    margin-right: 0.5rem;
}

.radio-label {
    display: flex;
    align-items: center;
    font-weight: 500;
    color: #2c3e50;
}

.radio-label i {
    margin-right: 0.5rem;
    color: #4a6cf7;
}

.radio-description {
    font-size: 0.8rem;
    color: #6c757d;
    margin-left: 1.5rem;
    margin-top: 0.25rem;
}

/* Messages d'erreur */
.error-message {
    font-size: 0.8rem;
    color: #dc3545;
    margin-top: 0.25rem;
    display: flex;
    align-items: center;
}

.error-message i {
    margin-right: 0.25rem;
}

.form-hint {
    font-size: 0.75rem;
    color: #6c757d;
    margin-top: 0.25rem;
    font-style: italic;
}

/* Boutons */
.form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 0.75rem;
    margin-top: 1rem;
    padding-top: 1rem;
    border-top: 1px solid #f0f0f0;
}

.btn {
    padding: 0.5rem 1rem;
    font-size: 0.9rem;
    border-radius: 4px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    cursor: pointer;
    transition: all 0.2s;
}

.btn i {
    font-size: 0.9em;
}

.btn-secondary {
    background-color: #f8f9fa;
    border: 1px solid #e1e5eb;
    color: #495057;
}

.btn-secondary:hover {
    background-color: #e9ecef;
    border-color: #dae0e5;
}

.btn-primary {
    background-color: #4a6cf7;
    border: 1px solid #4a6cf7;
    color: white;
}

.btn-primary:hover {
    background-color: #3a5ce4;
    border-color: #3a5ce4;
}

.btn-primary:disabled {
    background-color: #a0b0f8;
    border-color: #a0b0f8;
    cursor: not-allowed;
    opacity: 0.8;
}
</style>
