<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";

const form = useForm({
    nom: "",
    adresse: "",
    type_gare_id: "",
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
        <!-- En-tête de page -->
        <div class="row page-title-header">
            <div class="col-12">
                <div
                    class="page-header d-flex justify-content-between align-items-center"
                >
                    <h4 class="page-title">Création d'une nouvelle gare</h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <Link :href="route('dashboard')"
                                    >Tableau de bord</Link
                                >
                            </li>
                            <li class="breadcrumb-item">
                                <Link :href="route('gare.index')">Gares</Link>
                            </li>
                            <li
                                class="breadcrumb-item active"
                                aria-current="page"
                            >
                                Nouvelle gare
                            </li>
                        </ol>
                    </nav>
                </div>
            </div>
        </div>

        <!-- Formulaire -->
        <div class="row">
            <div class="col-md-8 mx-auto">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Informations de la gare</h4>
                        <form @submit.prevent="submit" class="pt-3">
                            <!-- Section 1: Informations de base -->
                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label"
                                    >Nom de la gare *</label
                                >
                                <div class="col-sm-9">
                                    <input
                                        type="text"
                                        class="form-control"
                                        v-model="form.nom"
                                        placeholder="Nom de la gare"
                                        :class="{
                                            'is-invalid': form.errors.nom,
                                        }"
                                        required
                                    />
                                    <div class="invalid-feedback">
                                        {{ form.errors.nom }}
                                    </div>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label"
                                    >Adresse *</label
                                >
                                <div class="col-sm-9">
                                    <input
                                        type="text"
                                        class="form-control"
                                        placeholder="Adresse de la gare"
                                        v-model="form.adresse"
                                        :class="{
                                            'is-invalid': form.errors.adresse,
                                        }"
                                        required
                                    />
                                    <div class="invalid-feedback">
                                        {{ form.errors.adresse }}
                                    </div>
                                </div>
                            </div>

                            <!-- Section 2: Type et caractéristiques -->
                            <div class="form-group row">
                                <label
                                    for="type_gare_id"
                                    class="col-sm-3 col-form-label"
                                    >Type de gare *</label
                                >
                                <div class="col-sm-9">
                                    <select
                                        id="type_gare_id"
                                        class="form-control"
                                        v-model="form.type_gare_id"
                                        :class="{
                                            'is-invalid':
                                                form.errors.type_gare_id,
                                        }"
                                        required
                                    >
                                        <option value="">Sélectionnez un type</option>
                                        <option :value="1">Principale</option>
                                        <option :value="2">Passage</option>
                                        <option :value="3">Halte</option>
                                        <option :value="4">Fermée</option>
                                    </select>
                                    <div
                                        v-if="form.errors.type_gare_id"
                                        class="invalid-feedback"
                                    >
                                        {{ form.errors.type_gare_id }}
                                    </div>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label"
                                    >Distance depuis Bamako (km) *</label
                                >
                                <div class="col-sm-9">
                                    <input
                                        type="number"
                                        step="0.01"
                                        class="form-control"
                                        v-model="form.distance_km"
                                        :class="{
                                            'is-invalid':
                                                form.errors.distance_km,
                                        }"
                                        required
                                    />
                                    <div class="invalid-feedback">
                                        {{ form.errors.distance_km }}
                                    </div>
                                </div>
                            </div>

                            <!-- Section 3: Équipements -->
                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label"
                                    >Équipements</label
                                >
                                <div class="col-sm-9">
                                    <div class="form-check">
                                        <input
                                            type="checkbox"
                                            class="form-check-input"
                                            v-model="form.internet"
                                        />
                                        Accès Internet disponible
                                    </div>
                                    <div class="form-check">
                                        <input
                                            type="checkbox"
                                            class="form-check-input"
                                            v-model="form.electricite"
                                        />
                                        Électricité disponible
                                    </div>
                                </div>
                            </div>

                            <!-- Section 4: Services -->
                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label"
                                    >Nombre de guichets *</label
                                >
                                <div class="col-sm-9">
                                    <input
                                        type="number"
                                        class="form-control"
                                        v-model="form.nombre_guichets"
                                        min="0"
                                        :class="{
                                            'is-invalid':
                                                form.errors.nombre_guichets,
                                        }"
                                        required
                                    />
                                    <div class="invalid-feedback">
                                        {{ form.errors.nombre_guichets }}
                                    </div>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label"
                                    >Contrôle des bagages *</label
                                >
                                <div class="col-sm-9">
                                    <select
                                        class="form-control"
                                        v-model="form.controle_bagage"
                                        :class="{
                                            'is-invalid':
                                                form.errors.controle_bagage,
                                        }"
                                        required
                                    >
                                        <option value="physique">
                                            Physique
                                        </option>
                                        <option value="electronique">
                                            Électronique
                                        </option>
                                        <option value="aucun">Aucun</option>
                                    </select>
                                    <div class="invalid-feedback">
                                        {{ form.errors.controle_bagage }}
                                    </div>
                                </div>
                            </div>

                            <!-- Boutons de soumission -->
                            <div class="form-group row mt-4">
                                <div
                                    class="col-sm-12 d-flex justify-content-end"
                                >
                                    <Link
                                        :href="route('gare.index')"
                                        class="btn btn-light mr-2"
                                    >
                                        Annuler
                                    </Link>
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
                                                ? "Enregistrement..."
                                                : "Enregistrer"
                                        }}
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
.card {
    border-radius: 10px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
}

.form-control.is-invalid {
    border-color: #dc3545;
}

.invalid-feedback {
    display: block;
    color: #dc3545;
}

.page-title-header {
    margin-bottom: 30px;
}

.form-group {
    margin-bottom: 1.5rem;
}
</style>
