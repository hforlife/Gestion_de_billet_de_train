<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { ref, computed } from "vue";
import { useForm } from "@inertiajs/vue3";
import { watch } from "vue";

const props = defineProps({
    voyages: Array,
    voyages_rec: Array,
    trains: Array,
});

const form = useForm({
    client_nom: "",
    voyage_id: null,
    train_id: null,
    prix: 0,
    quantite: 1,
    bagage: false,
    poids_bagage: 0,
});

const selectedVoyage = ref(null);
const searchQuery = ref("");
const cart = ref([]);
const activeTab = ref("regular"); // 'regular' ou 'recurrent'

// Filtrer les voyages selon l'onglet actif
const currentVoyages = computed(() => {
    return activeTab.value === "regular" ? props.voyages : props.voyages_rec;
});

// Filtrer les voyages selon la recherche
const filteredVoyages = computed(() => {
    return currentVoyages.value.filter(
        (voyage) =>
            voyage.name
                .toLowerCase()
                .includes(searchQuery.value.toLowerCase()) ||
            voyage.gare_depart_id
                .toLowerCase()
                .includes(searchQuery.value.toLowerCase()) ||
            voyage.gare_arrivee_id
                .toLowerCase()
                .includes(searchQuery.value.toLowerCase())
    );
});

// Ajouter au panier
const addToCart = (voyage) => {
    const existingItem = cart.value.find(
        (item) => item.voyage.id === voyage.id
    );
    if (existingItem) {
        existingItem.quantite++;
    } else {
        cart.value.push({
            voyage,
            quantite: 1,
            prix: voyage.prix,
            type: activeTab.value, // Stocker le type de voyage
        });
    }
    updateForm();
};

const resetPOS = () => {
    cart.value = [];
    form.reset();
};

// Mettre à jour le formulaire
const updateForm = () => {
    if (cart.value.length > 0) {
        form.voyage_id = cart.value[0].voyage.id;
        form.prix = cart.value[0].prix;
        form.quantite = cart.value.reduce(
            (sum, item) => sum + item.quantite,
            0
        );
    }
};

// Calculer le total
const total = computed(() => {
    return cart.value.reduce((sum, item) => sum + item.prix * item.quantite, 0);
});

watch(
    () => form.voyage_id,
    (newVal) => {
        const voyage = [...props.voyages, ...props.voyages_rec].find(
            (v) => v.id === newVal
        );
        if (voyage && voyage.train) {
            form.train_id = voyage.train.id;
        } else {
            form.train_id = null;
        }
    }
);

const getSelectedTrainInfo = () => {
    const voyage = props.voyages
        .concat(props.voyages_rec)
        .find((v) => v.id === form.voyage_id);
    if (!voyage || !voyage.train) return "Non défini";
    return `${voyage.train.numero} - ${voyage.train.name}`;
};

// Soumettre la vente
const submit = () => {
    form.post(route("vente.store"), {
        onSuccess: () => {
            cart.value = [];
            form.reset();
            alert("Vente enregistrée avec succès!");
        },
    });
};
</script>

<template>
    <AppLayout>
        <div class="pos-system">
            <!-- Header -->
            <div class="pos-header">
                <div class="pos-logo">SOPAFER Vente</div>
                <div class="pos-date">
                    {{ new Date().toLocaleDateString() }}
                </div>
            </div>

            <!-- Main Content -->
            <div class="pos-main">
                <!-- Left Panel - Products -->
                <div class="pos-products">
                    <div class="pos-search">
                        <input
                            v-model="searchQuery"
                            type="text"
                            placeholder="Rechercher un voyage..."
                            class="pos-search-input"
                        />
                    </div>

                    <!-- Onglets -->
                    <div class="pos-tabs">
                        <button
                            @click="activeTab = 'regular'"
                            :class="{ active: activeTab === 'regular' }"
                        >
                            Voyages Réguliers
                        </button>
                        <button
                            @click="activeTab = 'recurrent'"
                            :class="{ active: activeTab === 'recurrent' }"
                        >
                            Voyages Récurrents
                        </button>
                    </div>

                    <div class="pos-products-grid">
                        <div
                            v-for="voyage in filteredVoyages"
                            :key="voyage.id"
                            class="pos-product-card"
                            @click="addToCart(voyage)"
                        >
                            <div class="pos-product-info">
                                <h3>{{ voyage.name }}</h3>
                                <p>
                                    {{ voyage.gare_depart.nom }} →
                                    {{ voyage.gare_arrivee.nom }}
                                </p>
                                <div
                                    v-if="activeTab === 'recurrent'"
                                    class="pos-recurrent-info"
                                >
                                    <span v-if="Array.isArray(voyage.jours)">
                                        Jours: {{ voyage.jours.join(", ") }}
                                    </span>
                                    <span v-else>
                                        Jours:
                                        {{ voyage.jours || "Non spécifié" }}
                                    </span>
                                    <span
                                        >Heure: {{ voyage.heure_depart }}</span
                                    >
                                </div>

                                <div class="pos-product-price">
                                    {{ voyage.prix.toLocaleString() }} FCFA
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Panel - Cart -->
                <div class="pos-cart">
                    <div class="pos-cart-header">
                        <h2>TRANSACTION EN COURS</h2>
                        <div class="pos-cart-count">
                            {{
                                cart.reduce(
                                    (acc, item) => acc + item.quantite,
                                    0
                                )
                            }}
                            articles
                        </div>
                    </div>

                    <div class="pos-cart-items">
                        <div
                            v-for="(item, index) in cart"
                            :key="index"
                            class="pos-cart-item"
                        >
                            <div class="pos-cart-item-info">
                                <h3>{{ item.voyage.name }}</h3>
                                <p>
                                    {{ item.voyage.gare_depart.nom }} →
                                    {{ item.voyage.gare_arrivee.nom }}
                                </p>
                                <small v-if="item.type === 'recurrent'"
                                    >(Récurrent)</small
                                >
                            </div>
                            <div class="pos-cart-item-qty">
                                <button
                                    @click="
                                        item.quantite > 1
                                            ? item.quantite--
                                            : cart.splice(index, 1)
                                    "
                                >
                                    -
                                </button>
                                <span>{{ item.quantite }}</span>
                                <button @click="item.quantite++">+</button>
                            </div>
                            <div class="pos-cart-item-price">
                                {{
                                    (item.prix * item.quantite).toLocaleString()
                                }}
                                FCFA
                            </div>
                        </div>
                    </div>

                    <div class="pos-cart-summary">
                        <div class="pos-summary-row">
                            <span>Total:</span>
                            <span class="pos-total"
                                >{{ total.toLocaleString() }} FCFA</span
                            >
                        </div>
                    </div>

                    <div class="pos-cart-form">
                        <div class="pos-form-group">
                            <label>Nom du client</label>
                            <input
                                v-model="form.client_nom"
                                type="text"
                                class="pos-input"
                            />
                        </div>

                        <div class="pos-form-group">
                            <label>Train</label>
                            <input
                                type="text"
                                :value="getSelectedTrainInfo()"
                                class="pos-input"
                                
                                readonly
                            />
                        </div>

                        <div class="pos-form-group">
                            <label>
                                <input
                                    v-model="form.bagage"
                                    type="checkbox"
                                    class="pos-checkbox"
                                />
                                Bagage supplémentaire
                            </label>
                        </div>

                        <div v-if="form.bagage" class="pos-form-group">
                            <label>Poids (kg)</label>
                            <input
                                v-model.number="form.poids_bagage"
                                type="number"
                                min="0"
                                class="pos-input"
                            />
                        </div>
                    </div>

                    <div class="pos-cart-actions">
                        <button class="pos-cancel-btn" @click="resetPOS">
                            Annuler
                        </button>
                        <button
                            @click="submit"
                            class="pos-pay-btn"
                            :disabled="cart.length === 0"
                        >
                            Valider la vente
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

.pos-logo {
    font-size: 24px;
    font-weight: bold;
    letter-spacing: 1px;
}

.pos-date {
    font-size: 16px;
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

.pos-search {
    margin-bottom: 15px;
}

.pos-search-input {
    width: 100%;
    padding: 10px 15px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 16px;
}

.pos-products-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 15px;
}

.pos-product-card {
    border: 1px solid #e0e0e0;
    border-radius: 6px;
    padding: 15px;
    cursor: pointer;
    transition: all 0.2s;
}

.pos-product-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.pos-product-info h3 {
    font-size: 16px;
    margin-bottom: 5px;
    color: #333;
}

.pos-product-info p {
    font-size: 14px;
    color: #666;
    margin-bottom: 10px;
}

.pos-product-price {
    font-weight: bold;
    color: #e74c3c;
    font-size: 18px;
}

.pos-cart {
    width: 400px;
    background: #f9f9f9;
    border-left: 1px solid #ddd;
    display: flex;
    flex-direction: column;
}

.pos-cart-header {
    background: #001737;
    color: white;
    padding: 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.pos-cart-header h2 {
    font-size: 18px;
    margin: 0;
}

.pos-cart-count {
    background: #e74c3c;
    padding: 3px 8px;
    border-radius: 10px;
    font-size: 14px;
}

.pos-cart-items {
    flex: 1;
    overflow-y: auto;
    padding: 15px;
}

.pos-cart-item {
    border-bottom: 1px solid #eee;
    padding: 10px 0;
    display: flex;
    flex-direction: column;
}

.pos-cart-item-info h3 {
    font-size: 16px;
    margin: 0 0 5px 0;
    color: #333;
}

.pos-cart-item-info p {
    font-size: 14px;
    color: #666;
    margin: 0;
}

.pos-cart-item-qty {
    display: flex;
    align-items: center;
    margin: 8px 0;
}

.pos-cart-item-qty button {
    width: 25px;
    height: 25px;
    background: #eee;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.pos-cart-item-qty span {
    margin: 0 10px;
    min-width: 20px;
    text-align: center;
}

.pos-cart-item-price {
    font-weight: bold;
    color: #333;
    text-align: right;
}

.pos-cart-summary {
    padding: 15px;
    background: white;
    border-top: 1px solid #ddd;
    border-bottom: 1px solid #ddd;
}

.pos-summary-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 5px;
}

.pos-total {
    font-weight: bold;
    font-size: 18px;
    color: #e74c3c;
}

.pos-cart-form {
    padding: 15px;
    background: white;
}

.pos-form-group {
    margin-bottom: 15px;
}

.pos-form-group label {
    display: block;
    margin-bottom: 5px;
    font-weight: 500;
}

.pos-input,
.pos-select {
    width: 100%;
    padding: 8px 12px;
    border: 1px solid #ddd;
    border-radius: 4px;
}

.pos-checkbox {
    margin-right: 8px;
}

.pos-cart-actions {
    display: flex;
    padding: 15px;
    gap: 10px;
}

.pos-cancel-btn {
    flex: 1;
    padding: 12px;
    background: #eee;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.pos-pay-btn {
    flex: 2;
    padding: 12px;
    background: #27ae60;
    color: white;
    border: none;
    border-radius: 4px;
    font-weight: bold;
    cursor: pointer;
}

.pos-pay-btn:disabled {
    background: #001737;
    cursor: not-allowed;
}

.pos-tabs {
    display: flex;
    margin-bottom: 15px;
    border-bottom: 1px solid #ddd;
}

.pos-tabs button {
    flex: 1;
    padding: 10px;
    background: none;
    border: none;
    border-bottom: 3px solid transparent;
    cursor: pointer;
    font-weight: 500;
    color: #666;
}

.pos-tabs button.active {
    border-bottom-color: #001737;
    color: #001737;
    font-weight: bold;
}

.pos-recurrent-info {
    font-size: 12px;
    color: #666;
    margin: 5px 0;
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.pos-cart-item-info small {
    font-size: 12px;
    color: #e74c3c;
    font-style: italic;
}
</style>
