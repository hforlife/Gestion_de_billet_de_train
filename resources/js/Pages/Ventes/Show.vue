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
        required: true,
    },
});

const generateVente = (id) => {
    window.open(route("vente.generate", id), "_blank");
};

const form = computed(() => ({
    client_nom: props.vente.client_nom || "Non spécifié",
    voyage: props.vente.voyage?.name || `Voyage #${props.vente.voyage_id}`,
    gare_depart: props.vente.voyage?.gare_depart?.nom || "Non spécifié",
    gare_arrivee: props.vente.voyage?.gare_arrivee?.nom || "Non spécifié",
    train:
        props.vente.voyage?.train?.numero ||
        `Train #${props.vente.voyage?.train_id}`,
    place: props.vente.place?.numero || "Non attribuée",
    wagon: props.vente.place?.wagon?.nom || "Inconnu",
    type_wagon: props.vente.place?.wagon?.type || "Standard",
    train_place: props.vente.place?.wagon?.train?.numero || "Inconnu",
    prix: `${props.vente.prix.toLocaleString()} FCFA`,
    quantite: props.vente.quantite || 1,
    bagage: props.vente.bagage ? "Oui" : "Non",
    poids: props.vente.poids_bagage ? `${props.vente.poids_bagage} kg` : "0 kg",
    date: new Date(props.vente.created_at).toLocaleDateString("fr-FR", {
        day: "2-digit",
        month: "long",
        year: "numeric",
        hour: "2-digit",
        minute: "2-digit",
    }),
    mode_paiement: props.vente.mode_paiement?.type || "Inconnu",
    point_vente: props.vente.point_vente?.gare?.nom || "Inconnu",
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
            cancelButton: "bg-gray-200 hover:bg-gray-300 px-4 py-2 rounded mx-2",
        },
        buttonsStyling: false,
    }).then((result) => {
        if (result.isConfirmed) {
            router.delete(route("vente.destroy", { vente: props.vente.id }));
        }
    });
};
</script>

<template>
    <AppLayout>
        <div class="pos-system">
            <!-- Header -->
            <div class="pos-header">
                <Link :href="route('vente.index')" class="back-button">
                    <ArrowLeft class="icon" /> Retour aux ventes
                </Link>
                <div class="pos-logo">Détails du billet</div>
                <div class="pos-date">Réf: #{{ vente.id }}</div>
            </div>

            <!-- Main Content -->
            <div class="pos-main">
                <!-- Left Panel - Details -->
                <div class="pos-products">
                    <!-- Client Info -->
                    <div class="pos-section">
                        <h2 class="section-title">👤 Informations client</h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="pos-form-group">
                                <label>Nom du client</label>
                                <div class="pos-input">{{ form.client_nom }}</div>
                            </div>
                            <div class="pos-form-group">
                                <label>Date d'émission</label>
                                <div class="pos-input">{{ form.date }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Voyage Info -->
                    <div class="pos-section">
                        <h2 class="section-title">🚆 Détails du voyage</h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="pos-form-group">
                                <label>Itinéraire</label>
                                <div class="pos-input">{{ form.voyage }}</div>
                            </div>
                            <div class="pos-form-group">
                                <label>Départ</label>
                                <div class="pos-input">{{ form.gare_depart }}</div>
                            </div>
                            <div class="pos-form-group">
                                <label>Arrivée</label>
                                <div class="pos-input">{{ form.gare_arrivee }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Train Info -->
                    <div class="pos-section">
                        <h2 class="section-title">🚄 Informations train</h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="pos-form-group">
                                <label>Numéro du train</label>
                                <div class="pos-input">{{ form.train }}</div>
                            </div>
                            <div class="pos-form-group">
                                <label>Wagon</label>
                                <div class="pos-input">{{ form.wagon }} ({{ form.type_wagon }})</div>
                            </div>
                            <div class="pos-form-group">
                                <label>Place attribuée</label>
                                <div class="pos-input">N°{{ form.place }}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Panel - Payment & Actions -->
                <div class="pos-cart">
                    <!-- Payment Info -->
                    <div class="pos-section">
                        <h2 class="section-title">💰 Détails de paiement</h2>
                        <div class="grid grid-cols-1 gap-4">
                            <div class="pos-form-group">
                                <label>Prix unitaire</label>
                                <div class="pos-input">{{ form.prix }}</div>
                            </div>
                            <div class="pos-form-group">
                                <label>Quantité</label>
                                <div class="pos-input">{{ form.quantite }}</div>
                            </div>
                            <div class="pos-form-group">
                                <label>Total</label>
                                <div class="pos-input highlight">
                                    {{ (vente.prix * vente.quantite).toLocaleString() }} FCFA
                                </div>
                            </div>
                            <div class="pos-form-group">
                                <label>Mode de paiement</label>
                                <div class="pos-input">{{ form.mode_paiement }}</div>
                            </div>
                            <div class="pos-form-group">
                                <label>Point de vente</label>
                                <div class="pos-input">{{ form.point_vente }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Baggage Info -->
                    <div class="pos-section">
                        <h2 class="section-title">🧳 Informations bagages</h2>
                        <div class="grid grid-cols-1 gap-4">
                            <div class="pos-form-group">
                                <label>Bagage enregistré</label>
                                <div class="pos-input">{{ form.bagage }}</div>
                            </div>
                            <div class="pos-form-group">
                                <label>Poids total</label>
                                <div class="pos-input">{{ form.poids }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="pos-cart-actions">
                        <button @click="generateVente(vente.id)" class="pos-pay-btn">
                            <File class="icon" /> Imprimer le billet
                        </button>
                        <Link :href="route('vente.edit', vente.id)" class="pos-pay-btn edit-btn">
                            <Pencil class="icon" /> Modifier
                        </Link>
                        <button @click="confirmDelete" class="pos-cancel-btn delete-btn">
                            <Trash class="icon" /> Supprimer
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
.pos-system {
    display: flex;
    flex-direction: column;
    height: 100vh;
    background: #f5f5f5;
    font-family: "Arial", sans-serif;
}

.pos-header {
    background: #001737;
    color: white;
    padding: 15px 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.back-button {
    display: flex;
    align-items: center;
    gap: 8px;
    color: white;
    transition: color 0.2s;
}

.back-button:hover {
    color: #ddd;
}

.pos-logo {
    font-size: 18px;
    font-weight: bold;
    flex: 1;
    text-align: center;
}

.pos-date {
    font-size: 14px;
    background-color: #dbeafe;
    color: #1e40af;
    padding: 4px 12px;
    border-radius: 9999px;
}

.pos-main {
    display: flex;
    flex: 1;
    overflow: hidden;
}

.pos-products {
    flex: 1;
    padding: 15px;
    overflow-y: auto;
    background: white;
}

.pos-section {
    margin-bottom: 20px;
    padding: 15px;
    border-radius: 6px;
    background: #f9f9f9;
}

.section-title {
    font-size: 18px;
    font-weight: 600;
    color: #001737;
    margin-bottom: 15px;
    display: flex;
    align-items: center;
    gap: 8px;
}

.pos-form-group {
    margin-bottom: 15px;
}

.pos-form-group label {
    display: block;
    margin-bottom: 5px;
    font-weight: 500;
    color: #666;
    font-size: 14px;
}

.pos-input {
    width: 100%;
    padding: 8px 12px;
    background: white;
    border: 1px solid #ddd;
    border-radius: 4px;
    min-height: 38px;
}

.highlight {
    color: #27ae60;
    font-weight: bold;
}

.pos-cart {
    width: 400px;
    background: #f9f9f9;
    border-left: 1px solid #ddd;
    display: flex;
    flex-direction: column;
}

.pos-cart-actions {
    display: flex;
    flex-direction: column;
    padding: 15px;
    gap: 10px;
    margin-top: auto;
}

.pos-cancel-btn {
    padding: 12px;
    background: #eee;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
}

.pos-pay-btn {
    padding: 12px;
    background: #001737;
    color: white;
    border: none;
    border-radius: 4px;
    font-weight: bold;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
}

.edit-btn {
    background: #d97706;
}

.delete-btn {
    background: #dc2626;
}

.icon {
    width: 16px;
    height: 16px;
}

@media print {
    .pos-cart-actions,
    .back-button {
        display: none !important;
    }
}
</style>
