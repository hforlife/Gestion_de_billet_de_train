<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { defineProps } from "vue";

const props = defineProps({
    gare: Object,
    typesGare: Array,
});

const form = useForm({
    nom: props.gare.nom,
    adresse: props.gare.adresse,
    type_gare_id: props.gare.type_gare_id,
    distance_km: props.gare.distance_km,
    internet: props.gare.internet,
    electricite: props.gare.electricite,
    nombre_guichets: props.gare.nombre_guichets,
    controle_bagage: props.gare.controle_bagage,
});

const submit = () => {
    form.put(route("gare.update", props.gare.id), {
        preserveScroll: true,
        onSuccess: () => {
            Swal.fire({
                title: "Succès",
                text: "La gare a été mise à jour avec succès",
                icon: "success",
                confirmButtonText: "OK",
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
                <div class="page-header d-flex justify-content-between align-items-center">
                    <h4 class="page-title">Modification d'une gare</h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><Link :href="route('dashboard')">Tableau de bord</Link></li>
                            <li class="breadcrumb-item"><Link :href="route('gare.index')">Gares</Link></li>
                            <li class="breadcrumb-item active" aria-current="page">Modifier</li>
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
                            <!-- Nom -->
                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label">Nom de la gare *</label>
                                <div class="col-sm-9">
                                    <input
                                        type="text"
                                        class="form-control"
                                        v-model="form.nom"
                                        :class="{ 'is-invalid': form.errors.nom }"
                                        required
                                    />
                                    <div class="invalid-feedback">{{ form.errors.nom }}</div>
                                </div>
                            </div>

                            <!-- Adresse -->
                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label">Adresse *</label>
                                <div class="col-sm-9">
                                    <input
                                        type="text"
                                        class="form-control"
                                        v-model="form.adresse"
                                        :class="{ 'is-invalid': form.errors.adresse }"
                                        required
                                    />
                                    <div class="invalid-feedback">{{ form.errors.adresse }}</div>
                                </div>
                            </div>

                            <!-- Type de gare -->
                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label">Type de gare *</label>
                                <div class="col-sm-9">
                                    <select
                                        class="form-control"
                                        v-model="form.type_gare_id"
                                        :class="{ 'is-invalid': form.errors.type_gare_id }"
                                        required
                                    >
                                        <option value="">Sélectionnez un type</option>
                                        <option
                                            v-for="type in typesGare"
                                            :key="type.id"
                                            :value="type.id"
                                        >
                                            {{ type.type }}
                                        </option>
                                    </select>
                                    <div class="invalid-feedback">{{ form.errors.type_gare_id }}</div>
                                </div>
                            </div>

                            <!-- Distance -->
                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label">Distance depuis Bamako (km) *</label>
                                <div class="col-sm-9">
                                    <input
                                        type="number"
                                        step="0.01"
                                        class="form-control"
                                        v-model="form.distance_km"
                                        :class="{ 'is-invalid': form.errors.distance_km }"
                                        required
                                    />
                                    <div class="invalid-feedback">{{ form.errors.distance_km }}</div>
                                </div>
                            </div>

                            <!-- Équipements -->
                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label">Équipements</label>
                                <div class="col-sm-9">
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" v-model="form.internet" />
                                        Accès Internet
                                    </div>
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" v-model="form.electricite" />
                                        Électricité
                                    </div>
                                </div>
                            </div>

                            <!-- Guichets -->
                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label">Nombre de guichets *</label>
                                <div class="col-sm-9">
                                    <input
                                        type="number"
                                        min="0"
                                        class="form-control"
                                        v-model="form.nombre_guichets"
                                        :class="{ 'is-invalid': form.errors.nombre_guichets }"
                                        required
                                    />
                                    <div class="invalid-feedback">{{ form.errors.nombre_guichets }}</div>
                                </div>
                            </div>

                            <!-- Contrôle bagage -->
                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label">Contrôle des bagages *</label>
                                <div class="col-sm-9">
                                    <select
                                        class="form-control"
                                        v-model="form.controle_bagage"
                                        :class="{ 'is-invalid': form.errors.controle_bagage }"
                                        required
                                    >
                                        <option value="physique">Physique</option>
                                        <option value="electronique">Électronique</option>
                                        <option value="aucun">Aucun</option>
                                    </select>
                                    <div class="invalid-feedback">{{ form.errors.controle_bagage }}</div>
                                </div>
                            </div>

                            <!-- Boutons -->
                            <div class="form-group row mt-4">
                                <div class="col-sm-12 d-flex justify-content-end">
                                    <Link :href="route('gare.index')" class="btn btn-light mr-2">Annuler</Link>
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
                                        {{ form.processing ? "Mise à jour..." : "Mettre à jour" }}
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
