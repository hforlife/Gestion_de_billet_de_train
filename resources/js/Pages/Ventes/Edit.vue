<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import { defineProps, computed } from "vue";
import { ArrowLeft } from "lucide-vue-next";
import Swal from "sweetalert2";
import { Link } from "@inertiajs/vue3";

const props = defineProps({
    ventes: Object,
    voyages: Array,
    trains: Array,
});

const form = useForm({
    client_nom: props.ventes.client_nom || '',
    voyage_id: props.ventes.voyage_id || null,
    train_id: props.ventes.train_id || null,
    prix: props.ventes.prix || 0,
    quantite: props.ventes.quantite || 1,
    bagage: props.ventes.bagage || false,
    poids_bagage: props.ventes.poids_bagage || 0,
    place_id: props.ventes.place_id || null,
});

const selectedVoyage = computed(() => {
    return props.voyages.find(v => v.id === form.voyage_id);
});

const updateVoyageDetails = () => {
    if (selectedVoyage.value) {
        form.prix = selectedVoyage.value.prix;
        form.train_id = selectedVoyage.value.train_id;
        // Réinitialiser la place si le voyage change
        form.place_id = null;
    }
};

const submit = () => {
    form.put(route("vente.update", props.ventes.id), {
        onSuccess: () => {
            Swal.fire({
                title: 'Succès!',
                text: 'La modification a été enregistrée',
                icon: 'success',
                confirmButtonText: 'OK',
                customClass: {
                    confirmButton: 'bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded'
                }
            });
        },
        onError: (errors) => {
            let errorMessage = errors.message || "Une erreur est survenue";
            
            if (errors.train_id) {
                errorMessage = "Aucune place disponible dans ce train";
            }
            
            Swal.fire({
                title: 'Erreur',
                text: errorMessage,
                icon: 'error',
                confirmButtonText: 'OK'
            });
        }
    });
};
</script>

<template>
    <AppLayout>
        <div class="edit-container">
            <!-- Header -->
            <div class="edit-header">
                <Link :href="route('vente.index')" class="back-button">
                    <ArrowLeft class="icon" /> Retour aux ventes
                </Link>
                <h1>Modifier le billet #{{ ventes.id }}</h1>
                <div class="place-badge" v-if="form.place_id">
                    Place: {{ form.place_id }}
                </div>
            </div>

            <!-- Form Card -->
            <div class="edit-card">
                <form @submit.prevent="submit" class="edit-form">
                    <!-- Client Info -->
                    <div class="form-section">
                        <h2 class="section-title">
                            <span class="title-icon">👤</span>
                            Informations client
                        </h2>
                        <div class="form-group">
                            <label>Nom du client</label>
                            <input 
                                type="text" 
                                v-model="form.client_nom" 
                                class="form-input"
                                placeholder="Nom complet du client"
                                required
                            >
                        </div>
                    </div>

                    <!-- Voyage Info -->
                    <div class="form-section">
                        <h2 class="section-title">
                            <span class="title-icon">🚆</span>
                            Détails du voyage
                        </h2>
                        <div class="form-group">
                            <label>Voyage</label>
                            <select 
                                v-model="form.voyage_id" 
                                @change="updateVoyageDetails"
                                class="form-select"
                                required
                            >
                                <option disabled value="">-- Choisir un voyage --</option>
                                <option 
                                    v-for="voyage in voyages" 
                                    :key="voyage.id" 
                                    :value="voyage.id"
                                >
                                    {{ voyage.name }} ({{ voyage.gare_depart }} → {{ voyage.gare_arrivee }})
                                </option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Train attribué</label>
                            <input 
                                type="text" 
                                :value="selectedVoyage ? `${selectedVoyage.train} (${selectedVoyage.train})` : 'Non défini'"
                                class="form-input"
                                readonly
                            >
                            <input type="hidden" v-model="form.train_id" />
                        </div>
                    </div>

                    <!-- Pricing -->
                    <div class="form-section">
                        <h2 class="section-title">
                            <span class="title-icon">💰</span>
                            Tarification
                        </h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="form-group">
                                <label>Prix unitaire (FCFA)</label>
                                <input 
                                    type="number" 
                                    v-model="form.prix" 
                                    class="form-input"
                                    readonly
                                >
                            </div>

                            <div class="form-group">
                                <label>Quantité</label>
                                <input 
                                    type="number" 
                                    v-model="form.quantite" 
                                    min="1"
                                    class="form-input"
                                    required
                                >
                            </div>
                        </div>
                        <div class="total-price">
                            Total: <span>{{ (form.prix * form.quantite).toLocaleString() }} FCFA</span>
                        </div>
                    </div>

                    <!-- Baggage -->
                    <div class="form-section">
                        <h2 class="section-title">
                            <span class="title-icon">🧳</span>
                            Options bagages
                        </h2>
                        <div class="form-group checkbox-group">
                            <label>
                                <input 
                                    type="checkbox" 
                                    v-model="form.bagage"
                                    class="form-checkbox"
                                >
                                <span>Bagage enregistré</span>
                            </label>
                        </div>

                        <div v-if="form.bagage" class="form-group">
                            <label>Poids du bagage (kg)</label>
                            <input 
                                type="number" 
                                v-model="form.poids_bagage" 
                                min="0"
                                step="0.1"
                                class="form-input"
                                :required="form.bagage"
                            >
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="form-actions">
                        <Link 
                            :href="route('vente.index')" 
                            class="cancel-button"
                        >
                            Annuler
                        </Link>
                        <button 
                            type="submit" 
                            class="submit-button"
                            :disabled="form.processing"
                        >
                            <span v-if="form.processing" class="spinner"></span>
                            {{ form.processing ? 'Enregistrement...' : 'Mettre à jour' }}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
.edit-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 24px;
}

.edit-header {
    margin-bottom: 32px;
    position: relative;
}

.edit-header h1 {
    font-size: 1.75rem;
    font-weight: 700;
    color: #1f2937;
    margin-top: 16px;
    text-align: center;
}

.back-button {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    color: #3b82f6;
    font-weight: 500;
    margin-bottom: 16px;
}

.back-button:hover {
    color: #2563eb;
}

.back-button .icon {
    width: 18px;
    height: 18px;
}

.place-badge {
    position: absolute;
    top: 0;
    right: 0;
    background: #10b981;
    color: white;
    padding: 4px 12px;
    border-radius: 9999px;
    font-size: 0.875rem;
    font-weight: 500;
}

.edit-card {
    background: white;
    border-radius: 12px;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    overflow: hidden;
}

.edit-form {
    padding: 24px;
}

.form-section {
    margin-bottom: 32px;
    padding-bottom: 24px;
    border-bottom: 1px solid #e5e7eb;
}

.form-section:last-child {
    border-bottom: none;
    margin-bottom: 0;
    padding-bottom: 0;
}

.section-title {
    font-size: 1.25rem;
    font-weight: 600;
    color: #1f2937;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.title-icon {
    font-size: 1.5rem;
}

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    font-weight: 500;
    color: #374151;
}

.form-input, .form-select {
    width: 100%;
    padding: 10px 14px;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    font-size: 1rem;
    transition: border-color 0.2s;
}

.form-input:focus, .form-select:focus {
    outline: none;
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.form-input[readonly] {
    background-color: #f3f4f6;
    cursor: not-allowed;
}

.checkbox-group label {
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
}

.form-checkbox {
    width: 18px;
    height: 18px;
    accent-color: #3b82f6;
}

.total-price {
    font-size: 1.125rem;
    font-weight: 600;
    color: #1f2937;
    margin-top: 16px;
    text-align: right;
}

.total-price span {
    color: #10b981;
    font-size: 1.25rem;
}

.form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 16px;
    margin-top: 32px;
    padding-top: 24px;
    border-top: 1px solid #e5e7eb;
}

.cancel-button {
    padding: 10px 20px;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    background: white;
    color: #374151;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
    text-decoration: none;
    text-align: center;
}

.cancel-button:hover {
    background: #f3f4f6;
}

.submit-button {
    padding: 10px 24px;
    border: none;
    border-radius: 8px;
    background: #3b82f6;
    color: white;
    font-weight: 500;
    cursor: pointer;
    transition: background 0.2s;
    display: flex;
    align-items: center;
    gap: 8px;
}

.submit-button:hover:not(:disabled) {
    background: #2563eb;
}

.submit-button:disabled {
    background: #9ca3af;
    cursor: not-allowed;
}

.spinner {
    width: 18px;
    height: 18px;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-radius: 50%;
    border-top-color: white;
    animation: spin 1s ease-in-out infinite;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

@media (max-width: 768px) {
    .edit-container {
        padding: 16px;
    }
    
    .edit-form {
        padding: 16px;
    }
    
    .form-actions {
        flex-direction: column-reverse;
        gap: 12px;
    }
    
    .cancel-button, .submit-button {
        width: 100%;
    }
}
</style>