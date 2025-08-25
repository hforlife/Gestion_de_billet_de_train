<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm, router } from "@inertiajs/vue3";
import { computed, watch } from "vue";
import { ArrowLeft } from "lucide-vue-next";
import { Link } from "@inertiajs/vue3";
import Swal from "sweetalert2";

const props = defineProps({
    trains: Array,
    lignes: Array,
    gares: Array,
});

const form = useForm({
    nom: "",
    train_id: "",
    gare_depart_id: "",
    gare_arrivee_id: "",
    ligne_id: "",
    numero_voyage: "",
    date_depart: "",
    date_arrivee: "",
    statut: "programme",
});

const generateNum = async () => {
    try {
        const res = await fetch(route("voyage.next-number")); // tu as besoin d'un helper route ou URL complète
        const data = await res.json();
        form.numero_voyage = data.numero;
    } catch (e) {
        Swal.fire("Erreur", "Impossible de générer le numéro", "error");
    }
};

// const tarifsDisponibles = computed(() => {
//     if (!form.ligne_id) return [];
//     return props.tarifs.filter((t) => t.ligne_id == form.ligne_id);
// });

// watch(() => form.ligne_id, () => {
//     form.tarif_ids = [];
// });

const submit = () => {
    form.post(route("voyage.store"), {
        onSuccess: () => {
            Swal.fire("Succès", "Voyage créé avec succès", "success");
            form.reset();
        },
        onError: () => {
            Swal.fire("Erreur", "Veuillez vérifier le formulaire", "error");
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
                    <h1 class="page-title">Nouveau Voyage</h1>
                    <Link :href="route('voyage.index')" class="btn-back">
                        <ArrowLeft size="16" class="me-1" />
                        Retour à la liste
                    </Link>
                </div>
                <div class="breadcrumb-wrapper">
                    <ul class="breadcrumb">
                        <li class="breadcrumb-item">
                            <Link :href="route('dashboard')"
                                >Tableau de bord</Link
                            >
                            <span class="breadcrumb-divider">/</span>
                        </li>
                        <li class="breadcrumb-item">
                            <Link :href="route('voyage.index')">Voyages</Link>
                            <span class="breadcrumb-divider">/</span>
                        </li>
                        <li class="breadcrumb-item active">Nouveau</li>
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
                            Informations générales
                        </h3>

                        <div class="form-grid">
                            <!-- Nom du voyage -->
                            <div class="form-group">
                                <label class="form-label required"
                                    >Nom du voyage</label
                                >
                                <input
                                    v-model="form.nom"
                                    type="text"
                                    class="form-input"
                                    :class="{ 'is-invalid': form.errors.nom }"
                                    placeholder="Ex: Bamako-Kayes Express"
                                    required
                                />
                                <div v-if="form.errors.nom" class="form-error">
                                    {{ form.errors.nom }}
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label required"
                                    >Numero du voyage</label
                                >
                                <input
                                    v-model="form.numero_voyage"
                                    type="text"
                                    class="form-input"
                                    :class="{
                                        'is-invalid': form.errors.numero_voyage,
                                    }"
                                    placeholder="Ex: VOY????"
                                    disabled
                                    required
                                />
                                <button
                                    class="btn btn-primary mt-2"
                                    @click="generateNum"
                                >
                                    Générer Numero
                                </button>
                                <div
                                    v-if="form.errors.numero_voyage"
                                    class="form-error"
                                >
                                    {{ form.errors.numero_voyage }}
                                </div>
                            </div>

                            <!-- Train -->
                            <div class="form-group">
                                <label class="form-label required">Train</label>
                                <select
                                    v-model="form.train_id"
                                    class="form-select"
                                    :class="{
                                        'is-invalid': form.errors.train_id,
                                    }"
                                    required
                                >
                                    <option value="" disabled selected>
                                        Sélectionnez un train
                                    </option>
                                    <option
                                        v-for="train in trains"
                                        :key="train.id"
                                        :value="train.id"
                                    >
                                        Train {{ train.numero }}
                                    </option>
                                </select>
                                <div
                                    v-if="form.errors.train_id"
                                    class="form-error"
                                >
                                    {{ form.errors.train_id }}
                                </div>
                            </div>

                            <!-- Ligne -->
                            <div class="form-group">
                                <label class="form-label required">Ligne</label>
                                <select
                                    v-model="form.ligne_id"
                                    class="form-select"
                                    :class="{
                                        'is-invalid': form.errors.ligne_id,
                                    }"
                                    required
                                >
                                    <option value="" disabled selected>
                                        Sélectionnez une ligne
                                    </option>
                                    <option
                                        v-for="ligne in lignes"
                                        :key="ligne.id"
                                        :value="ligne.id"
                                    >
                                        {{ ligne.nom }}
                                    </option>
                                </select>
                                <div
                                    v-if="form.errors.ligne_id"
                                    class="form-error"
                                >
                                    {{ form.errors.ligne_id }}
                                </div>
                            </div>

                            <!-- Gare de Depart -->
                            <div class="form-group">
                                <label class="form-label required"
                                    >Gare de Depart</label
                                >
                                <select
                                    v-model="form.gare_depart_id"
                                    class="form-select"
                                    :class="{
                                        'is-invalid':
                                            form.errors.gare_depart_id,
                                    }"
                                    required
                                >
                                    <option value="" disabled selected>
                                        Sélectionnez une gare
                                    </option>
                                    <option
                                        v-for="gare in gares"
                                        :key="gare.id"
                                        :value="gare.id"
                                    >
                                        {{ gare.nom }}
                                    </option>
                                </select>
                                <div
                                    v-if="form.errors.gare_depart_id"
                                    class="form-error"
                                >
                                    {{ form.errors.gare_depart_id }}
                                </div>
                            </div>

                            <!-- Gare d'arrivée -->
                            <div class="form-group">
                                <label class="form-label required"
                                    >Gare d'Arrivée</label
                                >
                                <select
                                    v-model="form.gare_arrivee_id"
                                    class="form-select"
                                    :class="{
                                        'is-invalid':
                                            form.errors.gare_arrivee_id,
                                    }"
                                    required
                                >
                                    <option value="" disabled selected>
                                        Sélectionnez une gare
                                    </option>
                                    <option
                                        v-for="gare in gares"
                                        :key="gare.id"
                                        :value="gare.id"
                                    >
                                        {{ gare.nom }}
                                    </option>
                                </select>
                                <div
                                    v-if="form.errors.gare_arrivee_id"
                                    class="form-error"
                                >
                                    {{ form.errors.gare_arrivee_id }}
                                </div>
                            </div>

                            <!-- Statut -->
                            <div class="form-group">
                                <label class="form-label required"
                                    >Statut</label
                                >
                                <select
                                    v-model="form.statut"
                                    class="form-select"
                                    :class="{
                                        'is-invalid': form.errors.statut,
                                    }"
                                    required
                                >
                                    <option value="programme">Programmé</option>
                                    <option value="en_cours">En cours</option>
                                    <option value="terminé">Terminé</option>
                                    <option value="annulé">Annulé</option>
                                </select>
                                <div
                                    v-if="form.errors.statut"
                                    class="form-error"
                                >
                                    {{ form.errors.statut }}
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Section 2: Dates -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="mdi mdi-calendar-clock me-2"></i>
                            Horaires
                        </h3>

                        <div class="form-grid">
                            <!-- Date de départ -->
                            <div class="form-group">
                                <label class="form-label required"
                                    >Date de départ</label
                                >
                                <div class="datetime-input">
                                    <input
                                        v-model="form.date_depart"
                                        type="datetime-local"
                                        class="form-input"
                                        :class="{
                                            'is-invalid':
                                                form.errors.date_depart,
                                        }"
                                        required
                                    />
                                    <i class="mdi mdi-calendar"></i>
                                </div>
                                <div
                                    v-if="form.errors.date_depart"
                                    class="form-error"
                                >
                                    {{ form.errors.date_depart }}
                                </div>
                            </div>

                            <!-- Date d'arrivée -->
                            <div class="form-group">
                                <label class="form-label required"
                                    >Date d'arrivée</label
                                >
                                <div class="datetime-input">
                                    <input
                                        v-model="form.date_arrivee"
                                        type="datetime-local"
                                        class="form-input"
                                        :class="{
                                            'is-invalid':
                                                form.errors.date_arrivee,
                                        }"
                                        required
                                    />
                                    <i class="mdi mdi-calendar"></i>
                                </div>
                                <div
                                    v-if="form.errors.date_arrivee"
                                    class="form-error"
                                >
                                    {{ form.errors.date_arrivee }}
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Boutons d'action -->
                    <div class="form-actions">
                        <Link :href="route('voyage.index')" class="btn-cancel">
                            Annuler
                        </Link>
                        <button
                            type="submit"
                            class="btn-submit"
                            :disabled="form.processing"
                        >
                            <span v-if="form.processing" class="spinner"></span>
                            {{
                                form.processing
                                    ? "Création en cours..."
                                    : "Créer le voyage"
                            }}
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
/* Champ datetime personnalisé */
.datetime-input {
    position: relative;
}

.datetime-input i {
    position: absolute;
    right: 1rem;
    top: 50%;
    transform: translateY(-50%);
    color: #6c757d;
    pointer-events: none;
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
