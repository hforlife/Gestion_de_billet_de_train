<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import { computed, watch } from "vue";
import Swal from "sweetalert2";

const props = defineProps({
    voyages: Array,
    trains: Array,
    modesPaiement: Array,
    pointsVente: Array,
    systemSettings: Object,
    classeWagons: Array,
});

const form = useForm({
    voyage_id: "",
    classe_wagon_id: "",
    client_nom: "",
    mode_paiement_id: props.modesPaiement[0]?.id || null,
    point_vente_id: props.pointsVente[0]?.id || null,
    quantite: 1,
    quantite_demi_tarif: 0,
    prix: 0, // prix unitaire de base
    prix_total: 0, // prix total final
    demi_tarif: false,
    bagage: false,
    poids_bagage: "",
    statut: "payé",
    penalite: false,
});

const formatNumber = (value) => {
    if (isNaN(value)) return "0";
    return new Intl.NumberFormat("fr-FR").format(value);
};

// Helpers
const floatOrZero = (v) => (isNaN(parseFloat(v)) ? 0 : parseFloat(v));

// Voyage & classe sélectionnés
const selectedVoyage = computed(() =>
    props.voyages.find((v) => v.id === form.voyage_id)
);

const availableClasses = computed(() => selectedVoyage.value?.tarifs || []);

const selectedClass = computed(() =>
    availableClasses.value.find(
        (c) => c.classe_wagon_id === form.classe_wagon_id
    )
);

// Extra bagage
const bagageExtra = computed(() => {
    if (!form.bagage || !form.poids_bagage) return 0;

    const freeWeight = 10;
    const pricePerKg = floatOrZero(props.systemSettings?.bagage_kg || 500);
    const supplement =
        form.poids_bagage > freeWeight
            ? (form.poids_bagage - freeWeight) * pricePerKg
            : 0;

    return Math.ceil(supplement / 50) * 50; // arrondi au multiple de 50
});

// Calcul du prix total final
const totalPrice = computed(() => {
    if (!selectedClass.value) return 0;

    const unitPrice = floatOrZero(selectedClass.value.prix);
    let total = 0;

    // Billets plein tarif et demi-tarif
    const billetsPleinTarif = form.quantite - form.quantite_demi_tarif;
    total += unitPrice * billetsPleinTarif;
    total += (unitPrice / 2) * form.quantite_demi_tarif;

    // Extra bagage
    total += bagageExtra.value;

    // Application de la pénalité si activée
    if (form.penalite) {
        const penaliteRate =
            floatOrZero(props.systemSettings?.penalite || 5) / 100;
        total += total * penaliteRate;
    }

    // Arrondi au centaine supérieure
    if (total < 500) return Math.floor(total / 100) * 100;
    if (total < 1000) return Math.ceil(total / 50) * 50;
    return Math.ceil(total / 100) * 100;
});

// Mise à jour automatique des prix
watch(
    () => [
        form.quantite,
        form.quantite_demi_tarif,
        form.demi_tarif,
        form.bagage,
        form.poids_bagage,
        form.penalite,
        form.classe_wagon_id,
    ],
    () => {
        form.prix = selectedClass.value?.prix || 0;
        form.prix_total = totalPrice.value;
    },
    { deep: true, immediate: true }
);

const resetPOS = () => {
    form.reset();
    form.quantite = 1;
    form.quantite_demi_tarif = 0;
    form.prix = 0;
    form.prix_total = 0;
    form.statut = "payé";
    form.bagage = false;
    form.poids_bagage = "";
    form.penalite = false;
};

const getSelectedTrainInfo = () => {
    const voyage = props.voyages.find((v) => v.id === form.voyage_id);
    return voyage?.train?.numero || "Non défini";
};

const submit = () => {
    form.transform((data) => ({
        ...data,
        prix: form.prix_total, // on envoie le total au backend
    })).post(route("vente.store"), {
        onSuccess: () => {
            Swal.fire({
                title: "Succès!",
                text: "La vente a été enregistrée",
                icon: "success",
            }).then(() => resetPOS());
        },
        onError: (errors) => {
            if (errors.place) {
                Swal.fire({
                    icon: "error",
                    title: "Erreur",
                    text: errors.place,
                });
            } else {
                Swal.fire({
                    title: "Erreur",
                    text: errors.message || "Une erreur est survenue",
                    icon: "error",
                });
            }
        },
    });
};
</script>

<template>
    <AppLayout>
        <div class="pos-system">
            <!-- En-tête animé -->
            <div class="pos-header animate-header">
                <div class="pos-logo">SOPAFER Vente</div>
                <div class="pos-date">
                    {{
                        new Date().toLocaleDateString("fr-FR", {
                            weekday: "long",
                            year: "numeric",
                            month: "long",
                            day: "numeric",
                        })
                    }}
                </div>
            </div>

            <div class="pos-main">
                <!-- Voyages avec scroll amélioré -->
                <div class="pos-products custom-scrollbar">
                    <div class="pos-search">
                        <input
                            type="text"
                            placeholder="Rechercher un voyage..."
                            class="pos-search-input"
                        />
                        <svg
                            class="search-icon"
                            xmlns="http://www.w3.org/2000/svg"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                        >
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                    </div>
                    <div class="pos-products-grid">
                        <div
                            v-for="voyage in voyages"
                            :key="voyage.id"
                            class="pos-product-card"
                            :class="{
                                selected: form.voyage_id === voyage.id,
                                'has-train': voyage.train,
                            }"
                            @click="form.voyage_id = voyage.id"
                        >
                            <div class="pos-product-info">
                                <h3>{{ voyage.nom }}</h3>
                                <p v-if="voyage.ligne">
                                    <span class="departure">{{
                                        voyage.ligne.gare_depart.nom
                                    }}</span>
                                    <span class="arrow">→</span>
                                    <span class="arrival">{{
                                        voyage.ligne.gare_arrivee.nom
                                    }}</span>
                                </p>
                                <div class="pos-product-price">
                                    {{
                                        formatNumber(
                                            voyage.tarifs?.[0]?.prix || 0
                                        )
                                    }}
                                    FCFA
                                </div>
                            </div>
                            <div v-if="voyage.train" class="train-badge">
                                Train #{{ voyage.train.numero }}
                            </div>
                            <div class="hover-effect"></div>
                        </div>
                    </div>
                </div>

                <!-- Panier avec animations -->
                <div class="pos-cart custom-scrollbar">
                    <div class="pos-cart-header slide-in-top">
                        <h2>TRANSACTION EN COURS</h2>
                        <div
                            class="pos-cart-count pulse"
                            v-if="form.quantite > 0"
                        >
                            {{ form.quantite }} article(s)
                        </div>
                    </div>

                    <div class="pos-cart-form">
                        <!-- Animation de transition entre les champs -->
                        <transition name="fade-slide" mode="out-in">
                            <div v-if="form.voyage_id" key="form-fields">
                                <div class="pos-form-group">
                                    <label>Nom du client</label>
                                    <input
                                        v-model="form.client_nom"
                                        type="text"
                                        class="pos-input floating-input"
                                        required
                                        placeholder=" "
                                    />
                                    <div
                                        v-if="form.errors.client_nom"
                                        v-text="form.errors.client_nom"
                                        class="text-danger"
                                    ></div>
                                    <span class="floating-label"
                                        >Nom complet</span
                                    >
                                </div>

                                <div class="pos-form-group">
                                    <label>Train</label>
                                    <div class="train-display">
                                        <svg
                                            xmlns="http://www.w3.org/2000/svg"
                                            viewBox="0 0 24 24"
                                            fill="none"
                                            stroke="currentColor"
                                            stroke-width="2"
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                        >
                                            <path
                                                d="M12 2c-3 0-6 1-6 5v11a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V7c0-4-3-5-6-5z"
                                            ></path>
                                            <path d="M12 2v5"></path>
                                            <path d="M8 12h8"></path>
                                            <path d="M8 16h8"></path>
                                        </svg>
                                        <input
                                            type="text"
                                            :value="getSelectedTrainInfo()"
                                            class="pos-input"
                                            readonly
                                        />
                                    </div>
                                </div>

                                <div
                                    v-if="selectedVoyage"
                                    class="pos-form-group"
                                >
                                    <label>Voyage sélectionné</label>
                                    <div class="voyage-display">
                                        <svg
                                            xmlns="http://www.w3.org/2000/svg"
                                            viewBox="0 0 24 24"
                                            fill="none"
                                            stroke="currentColor"
                                            stroke-width="2"
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                        >
                                            <path
                                                d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"
                                            ></path>
                                            <circle
                                                cx="12"
                                                cy="10"
                                                r="3"
                                            ></circle>
                                        </svg>
                                        <input
                                            type="text"
                                            :value="selectedVoyage.nom"
                                            class="pos-input"
                                            readonly
                                        />
                                    </div>
                                </div>

                                <!-- Classe -->
                                <div class="pos-form-group">
                                    <label>Classe</label>
                                    <div class="select-wrapper">
                                        <select
                                            v-model="form.classe_wagon_id"
                                            class="pos-select"
                                            required
                                        >
                                            <option value="" disabled>
                                                Sélectionnez une classe
                                            </option>
                                            <option
                                                v-for="tarif in availableClasses"
                                                :key="tarif.id"
                                                :value="tarif.classe_wagon_id"
                                            >
                                                {{ tarif.classe_wagon.classe }}
                                                -
                                                {{ formatNumber(tarif.prix) }}
                                                FCFA
                                            </option>
                                        </select>
                                        <div class="select-arrow"></div>
                                        <div
                                            v-if="form.errors.classe_wagon_id"
                                            v-text="form.errors.classe_wagon_id"
                                            class="text-danger"
                                        ></div>
                                    </div>
                                    <div
                                        v-for="tarif in availableClasses"
                                        :key="tarif.id"
                                    >
                                        <div
                                            :class="{
                                                'text-red-500':
                                                    tarif.places_disponibles <=
                                                    0,
                                            }"
                                        >
                                            Places Disponibles:
                                            {{ tarif.places_disponibles }}
                                        </div>
                                    </div>
                                </div>

                                <!-- Options tarifaires -->
                                <div class="grid grid-cols-2 gap-4">
                                    <div class="pos-form-group">
                                        <label>Quantité totale</label>
                                        <div class="quantity-selector">
                                            <button
                                                @click="decreaseQty"
                                                :disabled="form.quantite <= 1"
                                            >
                                                -
                                            </button>
                                            <input
                                                v-model.number="form.quantite"
                                                type="number"
                                                min="1"
                                                class="quantity-input"
                                            />
                                            <button @click="form.quantite++">
                                                +
                                            </button>
                                        </div>
                                    </div>

                                    <div class="pos-form-group">
                                        <label class="checkbox-label">
                                            <input
                                                v-model="form.demi_tarif"
                                                type="checkbox"
                                            />
                                            Demi-tarif (enfant)
                                        </label>

                                        <div
                                            v-if="form.demi_tarif"
                                            class="mt-2"
                                        >
                                            <label
                                                >Nombre de billets en
                                                demi-tarif</label
                                            >
                                            <input
                                                v-model.number="
                                                    form.quantite_demi_tarif
                                                "
                                                type="number"
                                                min="0"
                                                :max="form.quantite"
                                                class="pos-input"
                                            />
                                        </div>
                                    </div>
                                </div>

                                <!-- Bagage -->
                                <div class="pos-form-group checkbox-group">
                                    <label class="custom-checkbox">
                                        <input
                                            v-model="form.bagage"
                                            type="checkbox"
                                            class="pos-checkbox"
                                        />
                                        <span class="checkmark"></span>
                                        Bagage supplémentaire
                                    </label>
                                </div>
                                <transition name="slide-down">
                                    <div
                                        v-if="form.bagage"
                                        class="pos-form-group"
                                    >
                                        <label>Poids (kg)</label>
                                        <input
                                            v-model.number="form.poids_bagage"
                                            type="number"
                                            min="0"
                                            step="0.1"
                                            class="pos-input floating-input"
                                            placeholder="Ex: 12.5"
                                        />
                                        <span class="floating-label"
                                            >Poids en kg</span
                                        >
                                    </div>
                                </transition>

                                <div class="pos-form-group">
                                    <label class="checkbox-label">
                                        <input
                                            v-model="form.penalite"
                                            type="checkbox"
                                        />
                                        Appliquer pénalité ({{
                                            systemSettings?.penalite || 5
                                        }}%)
                                    </label>
                                </div>

                                <!-- Paiement -->
                                <div class="pos-form-group">
                                    <label>Mode de paiement</label>
                                    <div class="select-wrapper">
                                        <select
                                            v-model="form.mode_paiement_id"
                                            class="pos-select"
                                            required
                                        >
                                            <option
                                                v-for="mode in modesPaiement"
                                                :key="mode.id"
                                                :value="mode.id"
                                            >
                                                {{ mode.type }}
                                            </option>
                                        </select>
                                        <div class="select-arrow"></div>
                                    </div>
                                </div>

                                <div class="pos-form-group">
                                    <label>Point de vente</label>
                                    <div class="select-wrapper">
                                        <select
                                            v-model="form.point_vente_id"
                                            class="pos-select"
                                            required
                                        >
                                            <option
                                                v-for="point in pointsVente"
                                                :key="point.id"
                                                :value="point.id"
                                            >
                                                {{ point.gare.nom }}
                                            </option>
                                        </select>
                                        <div class="select-arrow"></div>
                                    </div>
                                </div>

                                <!-- Total avec animation -->
                                <!-- <div
                                    class="pos-cart-summary"
                                    v-if="form.prix > 0"
                                >
                                    <div class="pos-summary-row">
                                        <span>Total:</span>
                                        <span class="pos-total bounce-in">
                                            {{ formatNumber(form.prix) }} FCFA
                                        </span>
                                    </div>
                                </div> -->
                            </div>
                            <div
                                v-else
                                key="empty-cart"
                                class="empty-cart-message"
                            >
                                <svg
                                    xmlns="http://www.w3.org/2000/svg"
                                    viewBox="0 0 24 24"
                                    fill="none"
                                    stroke="currentColor"
                                    stroke-width="2"
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                >
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="12" y1="8" x2="12" y2="12"></line>
                                    <line
                                        x1="12"
                                        y1="16"
                                        x2="12.01"
                                        y2="16"
                                    ></line>
                                </svg>
                                <p>Sélectionnez un voyage pour commencer</p>
                            </div>
                        </transition>

                        <!-- Statut -->
                        <div class="pos-form-group" v-if="form.voyage_id">
                            <label>Statut de Paiement</label>
                            <div class="select-wrapper">
                                <select
                                    v-model="form.statut"
                                    class="pos-select"
                                    required
                                >
                                    <option value="" disabled>
                                        -- Choisissez un statut --
                                    </option>
                                    <option value="payé">Payé</option>
                                    <option value="réservé">Réservé</option>
                                </select>
                                <div class="select-arrow"></div>
                                <div
                                    v-if="form.errors.statut"
                                    v-text="form.errors.statut"
                                    class="text-danger"
                                ></div>
                            </div>
                        </div>

                        <div class="pos-cart-summary" v-if="form.prix > 0">
                            <!-- Prix unitaire -->
                            <div class="pos-summary-row">
                                <span>Prix unitaire:</span>
                                <span>{{ formatNumber(form.prix) }} FCFA</span>
                            </div>

                            <!-- Détail demi-tarif -->
                            <div
                                v-if="
                                    form.demi_tarif &&
                                    form.quantite_demi_tarif > 0
                                "
                                class="pos-summary-row"
                            >
                                <span
                                    >Billets plein tarif ({{
                                        form.quantite -
                                        form.quantite_demi_tarif
                                    }}):</span
                                >
                                <span
                                    >{{
                                        formatNumber(
                                            form.prix *
                                                (form.quantite -
                                                    form.quantite_demi_tarif)
                                        )
                                    }}
                                    FCFA</span
                                >
                            </div>
                            <div
                                v-if="
                                    form.demi_tarif &&
                                    form.quantite_demi_tarif > 0
                                "
                                class="pos-summary-row"
                            >
                                <span
                                    >Billets demi-tarif ({{
                                        form.quantite_demi_tarif
                                    }}):</span
                                >
                                <span
                                    >{{
                                        formatNumber(
                                            (form.prix / 2) *
                                                form.quantite_demi_tarif
                                        )
                                    }}
                                    FCFA</span
                                >
                            </div>

                            <div
                                v-if="form.bagage && bagageExtra > 0"
                                class="pos-summary-row"
                            >
                                <span>Supplément bagage:</span>
                                <span
                                    >{{ formatNumber(bagageExtra) }} FCFA</span
                                >
                            </div>

                            <div v-if="form.penalite" class="pos-summary-row">
                                <span
                                    >Pénalité ({{
                                        systemSettings?.penalite || 5
                                    }}%):</span
                                >
                                <span
                                    >{{
                                        formatNumber(
                                            totalPrice -
                                                (quantityAdjustedPrice +
                                                    bagageExtra)
                                        )
                                    }}
                                    FCFA</span
                                >
                            </div>

                            <div
                                class="pos-summary-row"
                                style="font-weight: 700; font-size: 1.2em"
                            >
                                <span>Total:</span>
                                <span class="pos-total"
                                    >{{ formatNumber(totalPrice) }} FCFA</span
                                >
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="pos-cart-actions" v-if="form.voyage_id">
                            <button
                                @click="resetPOS"
                                class="pos-cancel-btn hover-effect-btn"
                            >
                                <span>Annuler</span>
                            </button>
                            <button
                                @click="submit"
                                :disabled="
                                    !form.voyage_id ||
                                    !form.classe_wagon_id ||
                                    form.processing
                                "
                                class="pos-pay-btn hover-effect-btn"
                            >
                                <span>Valider la vente</span>
                                <svg
                                    v-if="!form.processing"
                                    xmlns="http://www.w3.org/2000/svg"
                                    viewBox="0 0 24 24"
                                    fill="none"
                                    stroke="currentColor"
                                    stroke-width="2"
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                >
                                    <path d="M5 12h14"></path>
                                    <path d="M12 5l7 7-7 7"></path>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
.pos-summary-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 0.5rem;
}

.total-row {
    font-weight: 700;
    font-size: 1.2em;
    border-top: 1px dashed #ccc;
    padding-top: 0.5rem;
    margin-top: 0.5rem;
}
/* Base Styles */
.pos-system {
    display: flex;
    flex-direction: column;
    height: 100vh;
    background: #f8fafc;
    font-family: "Inter", -apple-system, BlinkMacSystemFont, sans-serif;
    overflow: hidden;
}

/* Header with Animation */
.pos-header {
    background: linear-gradient(135deg, #001737 0%, #003366 100%);
    color: white;
    padding: 15px 30px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 4px 12px rgba(0, 23, 55, 0.1);
    z-index: 10;
}

.animate-header {
    animation: fadeInDown 0.5s ease-out;
}

.pos-logo {
    font-size: 24px;
    font-weight: 700;
    letter-spacing: 0.5px;
    background: linear-gradient(90deg, #fff 0%, #a3c4ff 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

.pos-date {
    font-size: 14px;
    opacity: 0.9;
}

/* Main Layout */
.pos-main {
    display: flex;
    flex: 1;
    overflow: hidden;
}

/* Products Section with Custom Scroll */
.pos-products {
    flex: 1;
    padding: 20px;
    overflow-y: auto;
    background: white;
    transition: all 0.3s ease;
}

.custom-scrollbar {
    scrollbar-width: thin;
    scrollbar-color: #c1c1c1 #f1f1f1;
}

.custom-scrollbar::-webkit-scrollbar {
    width: 8px;
}

.custom-scrollbar::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 10px;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
    background-color: #c1c1c1;
    border-radius: 10px;
}

.pos-search {
    position: relative;
    margin-bottom: 20px;
}

.pos-search-input {
    width: 100%;
    padding: 12px 20px 12px 40px;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    font-size: 15px;
    transition: all 0.3s;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
}

.pos-search-input:focus {
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    outline: none;
}

.search-icon {
    position: absolute;
    left: 12px;
    top: 50%;
    transform: translateY(-50%);
    width: 18px;
    height: 18px;
    stroke: #64748b;
}

/* Product Grid with Animation */
.pos-products-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 20px;
    padding: 5px;
}

.pos-product-card {
    position: relative;
    border: 1px solid #e2e8f0;
    border-radius: 10px;
    padding: 20px;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
    background: white;
    overflow: hidden;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.pos-product-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
}

.pos-product-card.selected {
    border-color: #3b82f6;
    background-color: #f0f7ff;
    animation: pulse-border 2s infinite;
}

.pos-product-card.has-train::after {
    content: "";
    position: absolute;
    top: 10px;
    right: 10px;
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: #10b981;
    box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.2);
}

.hover-effect {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(
        135deg,
        rgba(59, 130, 246, 0.1) 0%,
        rgba(59, 130, 246, 0) 100%
    );
    opacity: 0;
    transition: opacity 0.3s;
}

.pos-product-card:hover .hover-effect {
    opacity: 1;
}

.pos-product-info h3 {
    font-size: 16px;
    margin-bottom: 8px;
    color: #1e293b;
    font-weight: 600;
}

.pos-product-info p {
    font-size: 14px;
    color: #64748b;
    margin-bottom: 12px;
    display: flex;
    align-items: center;
    gap: 5px;
}

.departure,
.arrival {
    transition: all 0.3s;
}

.pos-product-card:hover .departure {
    color: #3b82f6;
}

.pos-product-card:hover .arrival {
    color: #10b981;
}

.arrow {
    margin: 0 5px;
    color: #94a3b8;
}

.pos-product-price {
    font-weight: 700;
    color: #3b82f6;
    font-size: 18px;
}

.train-badge {
    position: absolute;
    top: 10px;
    right: 10px;
    background: #e0f2fe;
    color: #0369a1;
    padding: 3px 8px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: 500;
}

/* Cart Section with Animations */
.pos-cart {
    width: 420px;
    background: #f8fafc;
    border-left: 1px solid #e2e8f0;
    display: flex;
    flex-direction: column;
    overflow-y: auto;
}

.slide-in-top {
    animation: slideInTop 0.4s ease-out;
}

.pos-cart-header {
    background: linear-gradient(135deg, #001737 0%, #003366 100%);
    color: white;
    padding: 18px 25px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    position: sticky;
    top: 0;
    z-index: 5;
}

.pos-cart-header h2 {
    font-size: 18px;
    margin: 0;
    font-weight: 600;
    letter-spacing: 0.5px;
}

.pos-cart-count {
    background: #ef4444;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 600;
}

.pulse {
    animation: pulse 2s infinite;
}

.pos-cart-form {
    padding: 20px;
    flex: 1;
}

.pos-form-group {
    margin-bottom: 20px;
    position: relative;
}

.pos-form-group label {
    display: block;
    margin-bottom: 8px;
    font-weight: 500;
    color: #334155;
    font-size: 14px;
}

.pos-input,
.pos-select {
    width: 100%;
    padding: 12px 15px;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    font-size: 15px;
    transition: all 0.3s;
    background: white;
}

.pos-input:focus,
.pos-select:focus {
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    outline: none;
}

/* Floating Label Input */
.floating-input {
    padding-top: 18px;
    padding-bottom: 8px;
}

.floating-label {
    position: absolute;
    left: 15px;
    top: 38px;
    color: #94a3b8;
    transition: all 0.2s;
    pointer-events: none;
    font-size: 15px;
}

.floating-input:focus + .floating-label,
.floating-input:not(:placeholder-shown) + .floating-label {
    top: 20px;
    font-size: 12px;
    color: #3b82f6;
}

/* Custom Select */
.select-wrapper {
    position: relative;
}

.select-arrow {
    position: absolute;
    top: 50%;
    right: 15px;
    transform: translateY(-50%);
    width: 0;
    height: 0;
    border-left: 5px solid transparent;
    border-right: 5px solid transparent;
    border-top: 5px solid #64748b;
    pointer-events: none;
}

.pos-select {
    appearance: none;
    padding-right: 35px;
}

/* Checkbox Styles */
.checkbox-group {
    display: flex;
    align-items: center;
}

.custom-checkbox {
    display: flex;
    align-items: center;
    position: relative;
    padding-left: 30px;
    cursor: pointer;
    user-select: none;
    color: #334155;
    font-size: 14px;
}

.custom-checkbox input {
    position: absolute;
    opacity: 0;
    cursor: pointer;
    height: 0;
    width: 0;
}

.checkmark {
    position: absolute;
    top: 0;
    left: 0;
    height: 20px;
    width: 20px;
    background-color: white;
    border: 1px solid #e2e8f0;
    border-radius: 4px;
    transition: all 0.2s;
}

.custom-checkbox:hover input ~ .checkmark {
    border-color: #3b82f6;
}

.custom-checkbox input:checked ~ .checkmark {
    background-color: #3b82f6;
    border-color: #3b82f6;
}

.checkmark:after {
    content: "";
    position: absolute;
    display: none;
}

.custom-checkbox input:checked ~ .checkmark:after {
    display: block;
}

.custom-checkbox .checkmark:after {
    left: 7px;
    top: 3px;
    width: 5px;
    height: 10px;
    border: solid white;
    border-width: 0 2px 2px 0;
    transform: rotate(45deg);
}

/* Quantity Selector */
.quantity-selector {
    display: flex;
    align-items: center;
}

.quantity-btn {
    width: 36px;
    height: 36px;
    background: #f1f5f9;
    border: 1px solid #e2e8f0;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    font-size: 16px;
    color: #334155;
    transition: all 0.2s;
}

.quantity-btn:first-child {
    border-radius: 8px 0 0 8px;
}

.quantity-btn:last-child {
    border-radius: 0 8px 8px 0;
}

.quantity-btn:hover {
    background: #e2e8f0;
}

.quantity-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.quantity-input {
    width: 50px;
    text-align: center;
    border-radius: 0;
    border-left: none;
    border-right: none;
    padding: 8px;
}

/* Train and Voyage Display */
.train-display,
.voyage-display {
    position: relative;
}

.train-display svg,
.voyage-display svg {
    position: absolute;
    left: 12px;
    top: 50%;
    transform: translateY(-50%);
    width: 18px;
    height: 18px;
    stroke: #64748b;
}

.train-display input,
.voyage-display input {
    padding-left: 40px;
}

/* Cart Summary */
.pos-cart-summary {
    padding: 20px;
    background: white;
    border-top: 1px solid #e2e8f0;
    border-bottom: 1px solid #e2e8f0;
    margin: 20px -20px;
}

.pos-summary-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 5px;
}

.pos-total {
    font-weight: 700;
    font-size: 20px;
    color: #3b82f6;
}

.bounce-in {
    animation: bounceIn 0.5s;
}

/* Empty Cart Message */
.empty-cart-message {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 40px 20px;
    text-align: center;
    color: #64748b;
}

.empty-cart-message svg {
    width: 48px;
    height: 48px;
    stroke: #cbd5e1;
    margin-bottom: 15px;
}

.empty-cart-message p {
    font-size: 15px;
    max-width: 80%;
    line-height: 1.5;
}

/* Cart Actions */
.pos-cart-actions {
    display: flex;
    padding: 20px;
    gap: 15px;
    background: white;
    border-top: 1px solid #e2e8f0;
    position: sticky;
    bottom: 0;
}

.hover-effect-btn {
    position: relative;
    overflow: hidden;
}

.hover-effect-btn span {
    position: relative;
    z-index: 1;
    transition: color 0.3s;
}

.hover-effect-btn::after {
    content: "";
    position: absolute;
    top: 50%;
    left: 50%;
    width: 5px;
    height: 5px;
    background: rgba(255, 255, 255, 0.5);
    opacity: 0;
    border-radius: 100%;
    transform: scale(1, 1) translate(-50%, -50%);
    transform-origin: 50% 50%;
}

.hover-effect-btn:hover::after {
    animation: ripple 1s ease-out;
}

.pos-cancel-btn {
    flex: 1;
    padding: 14px;
    background: #f1f5f9;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 500;
    color: #334155;
    transition: all 0.3s;
}

.pos-cancel-btn:hover {
    background: #e2e8f0;
}

.pos-pay-btn {
    flex: 2;
    padding: 14px;
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    color: white;
    border: none;
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    transition: all 0.3s;
    box-shadow: 0 2px 4px rgba(16, 185, 129, 0.2);
}

.pos-pay-btn:hover {
    background: linear-gradient(135deg, #059669 0%, #047857 100%);
    box-shadow: 0 4px 8px rgba(16, 185, 129, 0.3);
}

.pos-pay-btn:disabled {
    background: #cbd5e1;
    cursor: not-allowed;
    box-shadow: none;
}

.pos-pay-btn svg {
    width: 18px;
    height: 18px;
}

/* Animations */
@keyframes fadeInDown {
    from {
        opacity: 0;
        transform: translateY(-20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes slideInTop {
    from {
        opacity: 0;
        transform: translateY(-30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes pulse {
    0% {
        box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.4);
    }
    70% {
        box-shadow: 0 0 0 10px rgba(239, 68, 68, 0);
    }
    100% {
        box-shadow: 0 0 0 0 rgba(239, 68, 68, 0);
    }
}

@keyframes pulse-border {
    0% {
        box-shadow: 0 0 0 0 rgba(59, 130, 246, 0.4);
    }
    70% {
        box-shadow: 0 0 0 8px rgba(59, 130, 246, 0);
    }
    100% {
        box-shadow: 0 0 0 0 rgba(59, 130, 246, 0);
    }
}

@keyframes bounceIn {
    0%,
    20%,
    40%,
    60%,
    80%,
    100% {
        transition-timing-function: cubic-bezier(0.215, 0.61, 0.355, 1);
    }
    0% {
        opacity: 0;
        transform: scale3d(0.3, 0.3, 0.3);
    }
    20% {
        transform: scale3d(1.1, 1.1, 1.1);
    }
    40% {
        transform: scale3d(0.9, 0.9, 0.9);
    }
    60% {
        opacity: 1;
        transform: scale3d(1.03, 1.03, 1.03);
    }
    80% {
        transform: scale3d(0.97, 0.97, 0.97);
    }
    100% {
        opacity: 1;
        transform: scale3d(1, 1, 1);
    }
}

@keyframes ripple {
    0% {
        transform: scale(0, 0);
        opacity: 1;
    }
    100% {
        transform: scale(50, 50);
        opacity: 0;
    }
}

/* Transition Effects */
.fade-slide-enter-active,
.fade-slide-leave-active {
    transition: all 0.3s ease;
}

.fade-slide-enter-from,
.fade-slide-leave-to {
    opacity: 0;
    transform: translateY(10px);
}

.slide-down-enter-active,
.slide-down-leave-active {
    transition: all 0.3s ease;
    max-height: 100px;
    overflow: hidden;
}

.slide-down-enter-from,
.slide-down-leave-to {
    opacity: 0;
    max-height: 0;
    transform: translateY(-10px);
}

/* Responsive Adjustments */
@media (max-width: 1024px) {
    .pos-main {
        flex-direction: column;
    }

    .pos-cart {
        width: 100%;
        border-left: none;
        border-top: 1px solid #e2e8f0;
    }

    .pos-products-grid {
        grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
    }
}

@media (max-width: 640px) {
    .pos-header {
        flex-direction: column;
        gap: 10px;
        padding: 15px;
    }

    .pos-products-grid {
        grid-template-columns: 1fr;
    }

    .grid-cols-2 {
        grid-template-columns: 1fr;
    }

    .pos-cart-actions {
        flex-direction: column;
    }
}
</style>
