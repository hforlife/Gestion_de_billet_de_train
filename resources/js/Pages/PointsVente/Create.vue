<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import { Plus, ArrowLeft } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    gares: Array,
});

const form = useForm({
    gare_id: "",
    type: "",
    actif: true,
});

const submit = () => {
    form.post(route('points-vente.store'), {
        onSuccess: () => {
            Swal.fire("Succès", "Point de vente créé avec succès", "success");
        },
        onError: () => {
            Swal.fire("Erreur", "Veuillez vérifier les champs", "error");
        },
    });
};
</script>

<template>
    <AppLayout>
        <!-- 🧭 Titre -->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Points de Vente</h4>
                    <div class="quick-link-wrapper w-100 d-md-flex flex-md-wrap">
                        <ul class="quick-links ml-auto">
                            <li><Link :href="route('dashboard')">Tableau de bord</Link></li>
                            <li><Link :href="route('points-vente.index')">Points de vente</Link></li>
                            <li>Nouveau point</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Formulaire -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="card-title mb-0">Nouveau Point de Vente</h4>
                            <Link
                                :href="route('points-vente.index')"
                                class="btn btn-light btn-icon-text"
                            >
                                <ArrowLeft size="16" class="me-1" />
                                Retour
                            </Link>
                        </div>

                        <form class="forms-sample" @submit.prevent="submit">
                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label">Gare *</label>
                                <div class="col-sm-9">
                                    <select
                                        v-model="form.gare_id"
                                        class="form-control"
                                        :class="{ 'is-invalid': form.errors.gare_id }"
                                        required
                                    >
                                        <option value="" disabled>Sélectionnez une gare</option>
                                        <option
                                            v-for="gare in gares"
                                            :key="gare.id"
                                            :value="gare.id"
                                        >
                                            {{ gare.nom }} ({{ gare.type }})
                                        </option>
                                    </select>
                                    <div v-if="form.errors.gare_id" class="invalid-feedback">
                                        {{ form.errors.gare_id }}
                                    </div>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label">Type de point *</label>
                                <div class="col-sm-9">
                                    <select
                                        v-model="form.type"
                                        class="form-control"
                                        :class="{ 'is-invalid': form.errors.type }"
                                        required
                                    >
                                        <option value="gare">Interne</option>
                                        <option value="externe">Externe</option>
                                    </select>
                                    <div v-if="form.errors.type" class="invalid-feedback">
                                        {{ form.errors.type }}
                                    </div>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label">Statut</label>
                                <div class="col-sm-9 d-flex align-items-center">
                                    <div class="form-check form-switch">
                                        <input
                                            type="checkbox"
                                            class="form-check-input"
                                            v-model="form.actif"
                                            id="actifSwitch"
                                        />
                                        <label class="form-check-label" for="actifSwitch">
                                            {{ form.actif ? 'Actif' : 'Inactif' }}
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group row mt-4">
                                <div class="col-sm-12 d-flex justify-content-end">
                                    <button
                                        type="button"
                                        @click="router.visit(route('points-vente.index'))"
                                        class="btn btn-light mr-2"
                                    >
                                        Annuler
                                    </button>
                                    <button
                                        type="submit"
                                        class="btn btn-primary"
                                        :disabled="form.processing"
                                    >
                                        <span
                                            v-if="form.processing"
                                            class="spinner-border spinner-border-sm me-1"
                                        ></span>
                                        {{ form.processing ? 'Création en cours...' : 'Créer' }}
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
.form-check-input:checked {
    background-color: #4e73df;
    border-color: #4e73df;
}

.invalid-feedback {
    display: block;
    color: #dc3545;
    font-size: 0.875em;
}
</style>
