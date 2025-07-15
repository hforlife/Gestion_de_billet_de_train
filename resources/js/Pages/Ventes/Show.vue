<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { router } from "@inertiajs/vue3";
import { Link } from "@inertiajs/vue3";
import { defineProps, computed } from "vue";
import { Pencil, Trash, File, ArrowLeft } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    vente: {
        type: Object,
        required: true
    }
});

const generateVente = (id) => {
    window.open(route("vente.generate", id), "_blank");
};

const form = computed(() => ({
    client_nom: props.vente.client_nom || "Non spécifié",
    voyage: props.vente.voyage?.name || `Voyage #${props.vente.voyage_id}`,
    gare_depart: props.vente.voyage?.gare_depart?.nom || "Non spécifié",
    gare_arrivee: props.vente.voyage?.gare_arrivee?.nom || "Non spécifié",
    train: props.vente.train?.numero || `Train #${props.vente.train_id}`,
    type_train: props.vente.train?.type || "Non spécifié",
    prix: `${props.vente.prix.toLocaleString()} FCFA`,
    quantite: props.vente.quantite || 1,
    bagage: props.vente.bagage ? "Oui" : "Non",
    poids: props.vente.poids_bagage ? `${props.vente.poids_bagage} kg` : "0 kg",
    date: new Date(props.vente.created_at).toLocaleDateString("fr-FR", {
        day: "2-digit",
        month: "long",
        year: "numeric",
        hour: "2-digit",
        minute: "2-digit"
    }),
    place: props.vente.place?.numero_place || "Non attribuée"
}));

const confirmDelete = () => {
    Swal.fire({
        title: "Confirmer la suppression",
        text: "Cette action est irréversible !",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d33",
        cancelButtonColor: "#3085d6",
        confirmButtonText: "Supprimer",
        cancelButtonText: "Annuler",
        customClass: {
            confirmButton: "bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded mx-2",
            cancelButton: "bg-gray-200 hover:bg-gray-300 px-4 py-2 rounded mx-2"
        },
        buttonsStyling: false
    }).then((result) => {
        if (result.isConfirmed) {
            router.delete(route("vente.destroy", { vente: props.vente.id }));
        }
    });
};
</script>

<template>
    <AppLayout>
        <div class="vente-detail-container">
            <!-- Header -->
            <div class="vente-header">
                <Link :href="route('vente.index')" class="back-button">
                    <ArrowLeft class="icon" /> Retour aux ventes
                </Link>
                <h1>Détails du billet</h1>
                <div class="vente-reference">Réf: #{{ vente.id }}</div>
            </div>

            <!-- Main Card -->
            <div class="vente-card">
                <!-- Client Info -->
                <div class="vente-section">
                    <h2 class="section-title">👤 Informations client</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="info-item">
                            <label>Nom du client</label>
                            <div class="info-value">{{ form.client_nom }}</div>
                        </div>
                        <div class="info-item">
                            <label>Date d'émission</label>
                            <div class="info-value">{{ form.date }}</div>
                        </div>
                    </div>
                </div>

                <!-- Voyage Info -->
                <div class="vente-section">
                    <h2 class="section-title">🚆 Détails du voyage</h2>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="info-item">
                            <label>Itinéraire</label>
                            <div class="info-value">{{ form.voyage }}</div>
                        </div>
                        <div class="info-item">
                            <label>Départ</label>
                            <div class="info-value">{{ form.gare_depart }}</div>
                        </div>
                        <div class="info-item">
                            <label>Arrivée</label>
                            <div class="info-value">{{ form.gare_arrivee }}</div>
                        </div>
                    </div>
                </div>

                <!-- Train Info -->
                <div class="vente-section">
                    <h2 class="section-title">🚄 Informations train</h2>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="info-item">
                            <label>Numéro du train</label>
                            <div class="info-value">{{ form.train }}</div>
                        </div>
                        <div class="info-item">
                            <label>Place attribuée</label>
                            <div class="info-value">{{ form.place }}</div>
                        </div>
                    </div>
                </div>

                <!-- Payment Info -->
                <div class="vente-section">
                    <h2 class="section-title">💰 Détails de paiement</h2>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="info-item">
                            <label>Prix unitaire</label>
                            <div class="info-value">{{ form.prix }}</div>
                        </div>
                        <div class="info-item">
                            <label>Quantité</label>
                            <div class="info-value">{{ form.quantite }}</div>
                        </div>
                        <div class="info-item">
                            <label>Total</label>
                            <div class="info-value highlight">
                                {{ (vente.prix * vente.quantite).toLocaleString() }} FCFA
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Baggage Info -->
                <div class="vente-section">
                    <h2 class="section-title">🧳 Informations bagages</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="info-item">
                            <label>Bagage enregistré</label>
                            <div class="info-value">{{ form.bagage }}</div>
                        </div>
                        <div class="info-item">
                            <label>Poids total</label>
                            <div class="info-value">{{ form.poids }}</div>
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="vente-actions">
                    <button @click="generateVente(vente.id)" class="action-btn print-btn">
                        <File class="icon" /> Imprimer le billet
                    </button>
                    <Link :href="route('vente.edit', vente.id)" class="action-btn edit-btn">
                        <Pencil class="icon" /> Modifier
                    </Link>
                    <button @click="confirmDelete" class="action-btn delete-btn">
                        <Trash class="icon" /> Supprimer
                    </button>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
.vente-detail-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 24px;
}

.vente-header {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    margin-bottom: 32px;
    gap: 16px;
}
@media (min-width: 768px) {
    .vente-header {
        flex-direction: row;
        align-items: center;
    }
}

.vente-header h1 {
    font-size: 1.5rem;
    font-weight: 700;
    color: #1f2937;
    flex: 1;
    text-align: center;
}
@media (min-width: 768px) {
    .vente-header h1 {
        text-align: left;
    }
}

.vente-reference {
    background-color: #dbeafe;
    color: #1e40af;
    padding: 4px 12px;
    border-radius: 9999px;
    font-size: 0.875rem;
    font-weight: 500;
}

.back-button {
    display: flex;
    align-items: center;
    gap: 8px;
    color: #2563eb;
    transition: color 0.2s;
}
.back-button:hover {
    color: #1e40af;
}

.vente-card {
    background-color: white;
    border-radius: 12px;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    overflow: hidden;
}

.vente-section {
    padding: 24px;
    border-bottom: 1px solid #e5e7eb;
}
.vente-section:last-child {
    border-bottom: none;
}

.section-title {
    font-size: 1.125rem;
    font-weight: 600;
    color: #1f2937;
    margin-bottom: 16px;
    display: flex;
    align-items: center;
    gap: 8px;
}

.info-item {
    display: flex;
    flex-direction: column;
}
.info-item label {
    font-size: 0.875rem;
    font-weight: 500;
    color: #6b7280;
    margin-bottom: 4px;
}
.info-value {
    color: #1f2937;
    font-weight: 500;
}
.highlight {
    color: #059669;
    font-weight: 700;
}

.vente-actions {
    padding: 24px;
    background-color: #f9fafb;
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    justify-content: flex-end;
}
.action-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 16px;
    border-radius: 8px;
    font-weight: 500;
    transition: background-color 0.2s;
}
.print-btn {
    background-color: #2563eb;
    color: white;
}
.print-btn:hover {
    background-color: #1d4ed8;
}
.edit-btn {
    background-color: #d97706;
    color: white;
}
.edit-btn:hover {
    background-color: #b45309;
}
.delete-btn {
    background-color: #dc2626;
    color: white;
}
.delete-btn:hover {
    background-color: #b91c1c;
}
.action-btn .icon {
    width: 16px;
    height: 16px;
}

@media print {
    .vente-actions,
    .back-button {
        display: none !important;
    }
}
</style>
