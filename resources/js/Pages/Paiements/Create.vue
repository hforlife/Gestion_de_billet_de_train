<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Link, useForm } from '@inertiajs/vue3';
import Swal from 'sweetalert2';

const form = useForm({
  type: '',
});

const submit = () => {
    form.post(route("paiement.store"), {
        preserveScroll: true,
        onSuccess: () => {
            Swal.fire({
                toast: true,
                position: "top-end",
                icon: "success",
                title: "Mode de paiement créé avec succès",
                showConfirmButton: false,
                timer: 3000,
            });
            form.reset();
        },
        onError: () => {
            Swal.fire({
                icon: "error",
                title: "Erreur",
                text: "Veuillez corriger les erreurs dans le formulaire",
            });
        },
    });
};
</script>

<template>
  <AppLayout>
     <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">Créer un Mode de Paiement</h4>
                        <Link :href="route('paiement.index')" class="btn btn-light btn-sm">← Retour</Link>
                    </div>

                    <div class="card-body">
                        <form @submit.prevent="submit">
                            <!-- Type -->
                            <div class="mb-3">
                                <label class="form-label">Type de paiement <span class="text-danger">*</span></label>
                                <select
                                    v-model="form.type"
                                    class="form-control"
                                    :class="{ 'is-invalid': form.errors.type }"
                                >
                                    <option value="" disabled>-- Sélectionner un mode de paiement --</option>
                                    <option value="especes">Espèces</option>
                                    <option value="banque">Banque</option>
                                    <option value="electronique">Électronique</option>
                                </select>
                                <div v-if="form.errors.type" class="invalid-feedback">
                                    {{ form.errors.type }}
                                </div>
                            </div>

                            <!-- Bouton -->
                            <div class="d-flex justify-content-end">
                                <button
                                    type="submit"
                                    class="btn btn-primary"
                                    :disabled="form.processing"
                                >
                                    <span v-if="form.processing" class="spinner-border spinner-border-sm me-2"></span>
                                    {{ form.processing ? "Création en cours..." : "Créer" }}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
  </AppLayout>
</template>
