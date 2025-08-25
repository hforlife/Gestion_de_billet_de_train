<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { Link } from "@inertiajs/vue3";

const props = defineProps({
    ligne: Object,
    gares: Array,
});

const form = useForm({
    nom: props.ligne ? props.ligne.nom : "",
    gare_depart_id: props.ligne ? props.ligne.gare_depart_id : "",
    gare_arrivee_id: props.ligne ? props.ligne.gare_arrivee_id : "",
    distance_totale: props.ligne ? props.ligne.distance_totale : 0,
    // arrets: [], // 👈 tableau d’objets { gare_id, distance }
});

// const ajouterArret = () => {
//     form.arrets.push({ gare_id: "", distance: 0 });
// };

// const supprimerArret = (index) => {
//     form.arrets.splice(index, 1);
// };

const submit = () => {
    form.put(route("ligne.update", props.ligne.id), {
        preserveScroll: true,
        onSuccess: () => {
            Swal.fire({
                title: "Succès",
                text: "La ligne a été modifiée avec succès",
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
                    <h1 class="page-title">Création d'une nouvelle ligne</h1>
                    <Link :href="route('ligne.index')" class="btn-back">
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
                            <Link :href="route('ligne.index')">Lignes</Link>
                            <span class="breadcrumb-divider">/</span>
                        </li>
                        <li class="breadcrumb-item active">
                            Modification ligne
                        </li>
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

                        <div class="form-group">
                            <label class="form-label required"
                                >Nom de la ligne</label
                            >
                            <input
                                type="text"
                                class="form-input"
                                v-model="form.nom"
                                placeholder="Ex: Bamako-Kayes"
                                :class="{ 'is-invalid': form.errors.nom }"
                                required
                            />
                            <div v-if="form.errors.nom" class="form-error">
                                {{ form.errors.nom }}
                            </div>
                        </div>
                    </div>

                    <!-- Section 2: Gares principales -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="mdi mdi-railroad-light me-2"></i>
                            Gares principales
                        </h3>

                        <div class="form-grid">
                            <!-- Gare de départ -->
                            <div class="form-group">
                                <label class="form-label required"
                                    >Gare de départ</label
                                >
                                <select
                                    class="form-select"
                                    v-model="form.gare_depart_id"
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
                                    >Gare d'arrivée</label
                                >
                                <select
                                    class="form-select"
                                    v-model="form.gare_arrivee_id"
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
                                        :disabled="
                                            gare.id === form.gare_depart_id
                                        "
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
                        </div>
                    </div>

                    <!-- Section 3: Distance -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="mdi mdi-map-marker-distance me-2"></i>
                            Distance
                        </h3>

                        <div class="form-group">
                            <label class="form-label required"
                                >Distance totale</label
                            >
                            <div class="input-with-unit">
                                <input
                                    type="number"
                                    step="0.1"
                                    min="1"
                                    class="form-input"
                                    v-model="form.distance_totale"
                                    placeholder="Ex: 350.5"
                                    :class="{
                                        'is-invalid':
                                            form.errors.distance_totale,
                                    }"
                                    required
                                />
                                <span class="input-unit">km</span>
                            </div>
                            <div
                                v-if="form.errors.distance_totale"
                                class="form-error"
                            >
                                {{ form.errors.distance_totale }}
                            </div>
                        </div>
                    </div>

                    <!-- Section 4: Arrêts intermédiaires
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="mdi mdi-train-station me-2"></i>
                            Arrêts intermédiaires
                        </h3>

                        <div class="intermediate-stops">
                            <div
                                v-for="(arret, index) in form.arrets"
                                :key="index"
                                class="stop-item"
                            >
                                <div class="stop-select">
                                    <select
                                        v-model="arret.gare_id"
                                        class="form-select"
                                        required
                                    >
                                        <option value="" disabled selected>Sélectionner une gare</option>
                                        <option
                                            v-for="gare in gares"
                                            :key="gare.id"
                                            :value="gare.id"
                                            :disabled="[
                                                form.gare_depart_id,
                                                form.gare_arrivee_id,
                                            ].includes(gare.id)"
                                        >
                                            {{ gare.nom }}
                                        </option>
                                    </select>
                                </div>
                                <div class="stop-distance">
                                    <input
                                        type="number"
                                        v-model="arret.distance_depart"
                                        placeholder="Distance depuis départ"
                                        class="form-input"
                                        min="0"
                                        required
                                    />
                                    <span class="distance-unit">km</span>
                                </div>
                                <button
                                    type="button"
                                    class="btn-remove-stop"
                                    @click="supprimerArret(index)"
                                    title="Supprimer cet arrêt"
                                >
                                    <i class="mdi mdi-close"></i>
                                </button>
                            </div>

                            <button
                                type="button"
                                class="btn-add-stop"
                                @click="ajouterArret"
                            >
                                <i class="mdi mdi-plus"></i> Ajouter un arrêt
                            </button>
                        </div>
                    </div> -->

                    <!-- Boutons d'action -->
                    <div class="form-actions">
                        <Link :href="route('ligne.index')" class="btn-cancel">
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
                                    ? "Modification en cours..."
                                    : "Modifier la ligne"
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

/* Champ avec unité */
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

/* Arrêts intermédiaires */
.intermediate-stops {
    display: flex;
    flex-direction: column;
    gap: 1rem;
}

.stop-item {
    display: flex;
    gap: 1rem;
    align-items: center;
}

.stop-select {
    flex: 2;
}

.stop-distance {
    flex: 1;
    position: relative;
}

.stop-distance .distance-unit {
    position: absolute;
    right: 1rem;
    top: 50%;
    transform: translateY(-50%);
    color: #6c757d;
    font-size: 0.9rem;
}

.btn-remove-stop {
    width: 40px;
    height: 40px;
    border-radius: 8px;
    border: none;
    background-color: #fff2f0;
    color: #ff4d4f;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
}

.btn-remove-stop:hover {
    background-color: #ffccc7;
}

.btn-add-stop {
    background-color: #f6ffed;
    border: 1px dashed #b7eb8f;
    color: #52c41a;
    padding: 0.75rem 1.5rem;
    border-radius: 8px;
    font-size: 0.95rem;
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    margin-top: 1rem;
}

.btn-add-stop:hover {
    background-color: #d9f7be;
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

    .stop-item {
        flex-direction: column;
        gap: 0.75rem;
    }

    .stop-select,
    .stop-distance {
        width: 100%;
    }

    .btn-remove-stop {
        align-self: flex-end;
    }
}
</style>
