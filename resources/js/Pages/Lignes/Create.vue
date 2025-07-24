<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";

const props = defineProps({
    gares: Array,
});

const form = useForm({
    nom: "",
    gare_depart_id: "",
    gare_arrivee_id: "",
    distance_totale: 0,
});

const submit = () => {
    form.post(route("ligne.store"), {
        preserveScroll: true,
        onSuccess: () => {
            Swal.fire({
                title: "Succès",
                text: "La ligne a été créée avec succès",
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
                <div class="page-header d-flex justify-content-between align-items-center">
                    <h4 class="page-title">Création d'une nouvelle ligne</h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <Link :href="route('dashboard')">Tableau de bord</Link>
                            </li>
                            <li class="breadcrumb-item">
                                <Link :href="route('ligne.index')">Lignes</Link>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">
                                Nouvelle ligne
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
                        <h4 class="card-title">Informations de la ligne</h4>
                        <form @submit.prevent="submit" class="pt-3">
                            <!-- Section 1: Informations de base -->
                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label">Nom de la ligne *</label>
                                <div class="col-sm-9">
                                    <input
                                        type="text"
                                        class="form-control"
                                        v-model="form.nom"
                                        placeholder="Ex: Bamako-Kayes"
                                        :class="{ 'is-invalid': form.errors.nom }"
                                        required
                                    />
                                    <div class="invalid-feedback">
                                        {{ form.errors.nom }}
                                    </div>
                                </div>
                            </div>

                            <!-- Section 2: Gares -->
                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label">Gare de départ *</label>
                                <div class="col-sm-9">
                                    <select
                                        class="form-control"
                                        v-model="form.gare_depart_id"
                                        :class="{ 'is-invalid': form.errors.gare_depart_id }"
                                        required
                                    >
                                        <option value="">Sélectionnez une gare</option>
                                        <option
                                            v-for="gare in gares"
                                            :key="gare.id"
                                            :value="gare.id"
                                        >
                                            {{ gare.nom }}
                                        </option>
                                    </select>
                                    <div class="invalid-feedback">
                                        {{ form.errors.gare_depart_id }}
                                    </div>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label">Gare d'arrivée *</label>
                                <div class="col-sm-9">
                                    <select
                                        class="form-control"
                                        v-model="form.gare_arrivee_id"
                                        :class="{ 'is-invalid': form.errors.gare_arrivee_id }"
                                        required
                                    >
                                        <option value="">Sélectionnez une gare</option>
                                        <option
                                            v-for="gare in gares"
                                            :key="gare.id"
                                            :value="gare.id"
                                            :disabled="gare.id === form.gare_depart_id"
                                        >
                                            {{ gare.nom }}
                                        </option>
                                    </select>
                                    <div class="invalid-feedback">
                                        {{ form.errors.gare_arrivee_id }}
                                    </div>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label">Distance totale (km) *</label>
                                <div class="col-sm-9">
                                    <input
                                        type="number"
                                        step="0.1"
                                        min="1"
                                        class="form-control"
                                        v-model="form.distance_totale"
                                        placeholder="Distance en kilomètres"
                                        :class="{ 'is-invalid': form.errors.distance_totale }"
                                        required
                                    />
                                    <div class="invalid-feedback">
                                        {{ form.errors.distance_totale }}
                                    </div>
                                </div>
                            </div>

                            <!-- Boutons de soumission -->
                            <div class="form-group row mt-4">
                                <div class="col-sm-12 d-flex justify-content-end">
                                    <Link
                                        :href="route('ligne.index')"
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
