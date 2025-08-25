<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import Calendar from "@/Components/Calendar.vue";
import { defineProps, onMounted, ref } from "vue";
import { Chart, registerables } from "chart.js";
import {
    TrainFront,
    Landmark,
    MapPinned,
    ShoppingCart,
    Users,
    Package,
    DollarSign,
    TrendingUp,
} from "lucide-vue-next";

Chart.register(...registerables);

const props = defineProps({
    voyages: Number,
    tickets: Number,
    trains: Number,
    gares: Number,
    stats: {
        type: Object,
        default: () => ({
            total_ventes: 0,
            revenus_totaux: 0,
            colis_express: 0,
            clients_actifs: 0,
            taux_remplissage: 0,
            voyages_du_jour: 0,
        }),
    },
    revenus_mensuels: Array,
    graph_data: Array,
    top_destinations: Array,
    performance_agents: Array,
    colis_express: Object,
});

const formatNumber = (v) =>
    isNaN(v) ? "0" : new Intl.NumberFormat("fr-FR").format(v);
const formatCurrency = (v) => `${formatNumber(v)} FCFA`;
const formatPercent = (v) => `${v}%`;

// Données simulées pour les nouveaux graphiques
const occupancyData = ref([
    { mois: "Jan", taux: 65 },
    { mois: "Fév", taux: 72 },
    { mois: "Mar", taux: 68 },
    { mois: "Avr", taux: 75 },
    { mois: "Mai", taux: 80 },
    { mois: "Jun", taux: 85 },
]);

const paymentMethodsData = ref([
    { methode: "Mobile Money", pourcentage: 45 },
    { methode: "Carte Bancaire", pourcentage: 30 },
    { methode: "Espèce", pourcentage: 20 },
    { methode: "Autre", pourcentage: 5 },
]);

onMounted(() => {
    // Graphique des ventes et revenus mensuels
    if (props.graph_data && props.graph_data.length > 0) {
        const ctx = document.getElementById("ventes-chart").getContext("2d");
        new Chart(ctx, {
            type: "bar",
            data: {
                labels: props.graph_data.map((item) => item.mois),
                datasets: [
                    {
                        label: "Nombre de ventes",
                        data: props.graph_data.map((item) => item.ventes),
                        backgroundColor: "rgba(54, 162, 235, 0.7)",
                        borderColor: "rgba(54, 162, 235, 1)",
                        borderWidth: 2,
                        borderRadius: 5,
                        yAxisID: "y",
                    },
                    {
                        label: "Revenus (FCFA)",
                        data: props.graph_data.map((item) => item.revenus),
                        backgroundColor: "rgba(75, 192, 192, 0.7)",
                        borderColor: "rgba(75, 192, 192, 1)",
                        borderWidth: 2,
                        type: "line",
                        tension: 0.4,
                        yAxisID: "y1",
                    },
                ],
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: "Ventes et revenus mensuels",
                        font: { size: 16, weight: "bold" },
                    },
                    legend: {
                        position: "top",
                    },
                },
                scales: {
                    y: {
                        type: "linear",
                        display: true,
                        position: "left",
                        title: {
                            display: true,
                            text: "Nombre de ventes",
                        },
                        grid: {
                            color: "rgba(0, 0, 0, 0.1)",
                        },
                    },
                    y1: {
                        type: "linear",
                        display: true,
                        position: "right",
                        title: {
                            display: true,
                            text: "Revenus (FCFA)",
                        },
                        grid: {
                            drawOnChartArea: false,
                        },
                    },
                    x: {
                        grid: {
                            color: "rgba(0, 0, 0, 0.1)",
                        },
                    },
                },
            },
        });
    }

    // Graphique de taux d'occupation
    const occupancyCtx = document
        .getElementById("occupancy-chart")
        .getContext("2d");
    new Chart(occupancyCtx, {
        type: "line",
        data: {
            labels: occupancyData.value.map((item) => item.mois),
            datasets: [
                {
                    label: "Taux d'occupation (%)",
                    data: occupancyData.value.map((item) => item.taux),
                    backgroundColor: "rgba(255, 159, 64, 0.2)",
                    borderColor: "rgba(255, 159, 64, 1)",
                    borderWidth: 3,
                    tension: 0.4,
                    fill: true,
                },
            ],
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                title: {
                    display: true,
                    text: "Taux d'occupation mensuel",
                    font: { size: 16, weight: "bold" },
                },
            },
            scales: {
                y: {
                    beginAtZero: true,
                    max: 100,
                    title: {
                        display: true,
                        text: "Taux d'occupation (%)",
                    },
                },
            },
        },
    });

    // Graphique des méthodes de paiement
    const paymentCtx = document
        .getElementById("payment-chart")
        .getContext("2d");
    new Chart(paymentCtx, {
        type: "doughnut",
        data: {
            labels: paymentMethodsData.value.map((item) => item.methode),
            datasets: [
                {
                    data: paymentMethodsData.value.map(
                        (item) => item.pourcentage
                    ),
                    backgroundColor: [
                        "rgba(54, 162, 235, 0.8)",
                        "rgba(75, 192, 192, 0.8)",
                        "rgba(255, 159, 64, 0.8)",
                        "rgba(153, 102, 255, 0.8)",
                    ],
                    borderWidth: 2,
                    hoverOffset: 12,
                },
            ],
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                title: {
                    display: true,
                    text: "Méthodes de paiement",
                    font: { size: 16, weight: "bold" },
                },
                legend: {
                    position: "bottom",
                },
            },
        },
    });
});
</script>

<template>
    <AppLayout>
        <!-- En-tête de page -->
        <div class="dashboard-header">
            <div class="header-content">
                <h1 class="page-title">Tableau de bord</h1>
                <nav class="breadcrumb">
                    <span class="breadcrumb-item active">
                        <i class="fas fa-tachometer-alt"></i> Tableau de bord
                    </span>
                </nav>
            </div>
        </div>

        <!-- Cartes de statistiques principales -->
        <div class="stats-grid">
            <!-- Carte Voyages -->
            <div class="stat-card">
                <div class="stat-content">
                    <div class="stat-text">
                        <h3>{{ voyages }}</h3>
                        <p>Total Voyages</p>
                        <span class="stat-trend positive">
                            <i class="fas fa-arrow-up"></i> 14.00 (0.50%)
                        </span>
                    </div>
                    <div class="stat-icon">
                        <MapPinned color="#4a6cf7" size="40" />
                    </div>
                </div>
            </div>

            <!-- Carte Ventes -->
            <div class="stat-card">
                <div class="stat-content">
                    <div class="stat-text">
                        <h3>{{ tickets }}</h3>
                        <p>Total Ventes</p>
                        <span class="stat-trend positive">
                            <i class="fas fa-arrow-up"></i> 138.97 (0.54%)
                        </span>
                    </div>
                    <div class="stat-icon">
                        <ShoppingCart color="#4a6cf7" size="40" />
                    </div>
                </div>
            </div>

            <!-- Carte Trains -->
            <div class="stat-card">
                <div class="stat-content">
                    <div class="stat-text">
                        <h3>{{ trains }}</h3>
                        <p>Total Trains</p>
                        <span class="stat-trend positive">
                            <i class="fas fa-arrow-up"></i> 57.62 (0.76%)
                        </span>
                    </div>
                    <div class="stat-icon">
                        <TrainFront color="#4a6cf7" size="40" />
                    </div>
                </div>
            </div>

            <!-- Carte Gares -->
            <div class="stat-card">
                <div class="stat-content">
                    <div class="stat-text">
                        <h3>{{ gares }}</h3>
                        <p>Total Gares</p>
                        <span class="stat-trend positive">
                            <i class="fas fa-arrow-up"></i> 138.97 (0.54%)
                        </span>
                    </div>
                    <div class="stat-icon">
                        <Landmark color="#4a6cf7" size="40" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Stats détaillées -->
        <div class="stats-detailed-grid">
            <!-- Carte Clients actifs -->
            <div class="stat-card detailed">
                <div class="stat-content">
                    <div class="stat-text">
                        <h3>{{ colis_express || 0 }}</h3>
                        <p>Colis Livré</p>
                    </div>
                    <div class="stat-icon">
                        <Package color="#4a6cf7" size="32" />
                    </div>
                </div>
                <div class="stat-footer">
                    <span class="positive"
                        ><i class="fas fa-arrow-up"></i> 12% ce mois</span
                    >
                </div>
            </div>

            <!-- Carte Voyages du jour -->
            <div class="stat-card detailed">
                <div class="stat-content">
                    <div class="stat-text">
                        <h3>{{ stats.voyages_du_jour || 0 }}</h3>
                        <p>Voyages aujourd'hui</p>
                    </div>
                    <div class="stat-icon">
                        <MapPinned color="#4a6cf7" size="32" />
                    </div>
                </div>
                <div class="stat-footer">
                    <span
                        >En cours:
                        {{
                            stats.voyages_du_jour
                                ? Math.floor(stats.voyages_du_jour * 0.6)
                                : 0
                        }}</span
                    >
                </div>
            </div>

            <!-- Carte Revenu moyen -->
            <div class="stat-card detailed">
                <div class="stat-content">
                    <div class="stat-text">
                        <h3>
                            {{
                                formatCurrency(
                                    stats.revenus_totaux
                                        ? Math.floor(
                                              stats.revenus_totaux / 1000
                                          )
                                        : 0
                                )
                            }}
                        </h3>
                        <p>Revenu moyen/jour</p>
                    </div>
                    <div class="stat-icon">
                        <DollarSign color="#4a6cf7" size="32" />
                    </div>
                </div>
                <div class="stat-footer">
                    <span class="positive"
                        ><i class="fas fa-arrow-up"></i> 15% cette semaine</span
                    >
                </div>
            </div>
        </div>

        <!-- Grille principale de données -->
        <div class="data-grid">
            <!-- Graphique principal -->
            <div class="chart-card">
                <div class="card-header">
                    <h3>Statistiques des ventes et revenus mensuels</h3>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="ventes-chart" height="250"></canvas>
                    </div>
                </div>
            </div>

            <!-- Tableau des revenus -->
            <div class="table-card">
                <div class="card-header">
                    <h3>Revenus mensuels détaillés</h3>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Mois</th>
                                    <th>Ventes</th>
                                    <th>Revenus</th>
                                    <!-- <th>Croissance</th> -->
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(item, index) in graph_data"
                                    :key="item.mois"
                                >
                                    <td>{{ item.mois }}</td>
                                    <td>{{ item.ventes }}</td>
                                    <td class="text-success">
                                        {{ formatCurrency(item.revenus) }}
                                    </td>
                                    <!-- <td>
                                        <span :class="index > 0 ? 'positive' : 'neutral'">
                                            <i class="fas" :class="index > 0 ? 'fa-arrow-up' : 'fa-minus'"></i>
                                            {{ index > 0 ? '12%' : 'N/A' }}
                                        </span>
                                    </td> -->
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <br />

        <!-- Deuxième grille de graphiques -->
        <div class="data-grid secondary">
            <!-- Graphique taux d'occupation -->
            <div class="chart-card">
                <div class="card-header">
                    <h3>Taux d'occupation des trains</h3>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="occupancy-chart" height="200"></canvas>
                    </div>
                </div>
            </div>

            <!-- Graphique méthodes de paiement -->
            <div class="chart-card">
                <div class="card-header">
                    <h3>Méthodes de paiement</h3>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="payment-chart" height="200"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top destinations -->
        <div class="data-grid">
            <div class="table-card">
                <div class="card-header">
                    <h3>Top 5 destinations populaires</h3>
                </div>
                <div class="card-body">
                    <div class="destinations-list">
                        <div
                            v-for="(destination, index) in top_destinations"
                            :key="index"
                            class="destination-item"
                        >
                            <div class="destination-rank">{{ index + 1 }}</div>
                            <div class="destination-info">
                                <h4>{{ destination.nom }}</h4>
                                <p>{{ destination.ventes }} ventes</p>
                            </div>
                            <div class="destination-revenue">
                                {{ formatCurrency(destination.revenu) }}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
/* Style général */
.dashboard-header {
    background-color: #f8f9fa;
    padding: 1.5rem 2rem;
    border-bottom: 1px solid #e1e5eb;
    margin-bottom: 1.5rem;
}

.header-content {
    max-width: 1400px;
    margin: 0 auto;
}

.page-title {
    font-size: 1.8rem;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 0.5rem;
}

.breadcrumb {
    display: flex;
    align-items: center;
    padding: 0;
    margin: 0;
    list-style: none;
    font-size: 0.9rem;
}

.breadcrumb-item {
    color: #6c757d;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.breadcrumb-item.active {
    color: #4a6cf7;
    font-weight: 500;
}

/* Grille de statistiques */
.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 1.5rem;
    margin-bottom: 1.5rem;
}

.stat-card {
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
    padding: 1.5rem;
    transition: transform 0.3s, box-shadow 0.3s;
}

.stat-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
}

.stat-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.stat-text h3 {
    font-size: 1.8rem;
    font-weight: 700;
    color: #2c3e50;
    margin-bottom: 0.5rem;
}

.stat-text p {
    color: #6c757d;
    margin-bottom: 0.5rem;
}

.stat-trend {
    font-size: 0.85rem;
    display: flex;
    align-items: center;
    gap: 0.3rem;
}

.stat-trend.positive {
    color: #28a745;
}

.stat-trend.negative {
    color: #dc3545;
}

.stat-icon {
    background-color: rgba(74, 108, 247, 0.1);
    width: 60px;
    height: 60px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* Grille de revenus */
.revenue-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 1.5rem;
    margin-bottom: 1.5rem;
}

.revenue-card {
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
    padding: 1.5rem;
    position: relative;
}

.revenue-card.highlight {
    background-color: #4a6cf7;
    color: white;
}

.card-header {
    display: flex;
    align-items: center;
    margin-bottom: 1rem;
    background-color: transparent;
    border: none;
}

.header-dot {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    margin-right: 0.75rem;
}

.bg-danger {
    background-color: #dc3545;
}
.bg-success {
    background-color: #28a745;
}
.bg-warning {
    background-color: #ffc107;
}

.revenue-card h4 {
    font-size: 1rem;
    font-weight: 500;
    margin: 0;
}

.revenue-card.highlight h4 {
    color: white;
}

.card-body h2 {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 1rem;
}

.revenue-card.highlight h2 {
    color: white;
}

.progress-container {
    height: 8px;
    background-color: #e9ecef;
    border-radius: 4px;
    overflow: hidden;
}

.progress-bar {
    height: 100%;
    border-radius: 4px;
}

.card-icon {
    position: absolute;
    top: 1.5rem;
    right: 1.5rem;
    font-size: 2rem;
    opacity: 0.2;
}

/* Grille de données */
.data-grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: 1.5rem;
}

.chart-card,
.table-card {
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
    padding: 1.5rem;
}

.card-header h3 {
    font-size: 1.25rem;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 1rem;
}

.chart-container {
    position: relative;
}

.data-table {
    width: 100%;
    border-collapse: collapse;
}

.data-table th {
    text-align: left;
    padding: 0.75rem 1rem;
    background-color: #f8f9fa;
    color: #495057;
    font-weight: 600;
    text-transform: uppercase;
    font-size: 0.75rem;
    letter-spacing: 0.5px;
}

.data-table td {
    padding: 1rem;
    border-bottom: 1px solid #e9ecef;
    color: #495057;
}

.data-table tr:last-child td {
    border-bottom: none;
}

.data-table tr:hover td {
    background-color: #f8f9fa;
}

.text-success {
    color: #28a745;
    font-weight: 500;
}

/* Responsive amélioré */
@media (max-width: 1024px) {
    .stats-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 768px) {
    .dashboard-header {
        padding: 1rem;
    }

    .page-title {
        font-size: 1.5rem;
    }

    .revenue-grid {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 576px) {
    .stats-grid {
        gap: clamp(0.5rem, 2vw, 1.5rem);
        padding: clamp(0.5rem, 2vw, 1rem);
    }

    .stat-card {
        padding: 1rem;
    }

    .stat-content {
        flex-direction: row; /* Conserver l'alignement horizontal */
    }

    .stat-text h3 {
        font-size: 1.5rem;
    }

    .data-table {
        display: block;
        overflow-x: auto;
        white-space: nowrap;
    }

    .chart-container {
        height: 200px !important;
    }

    .card-header h3 {
        font-size: 1.1rem;
    }
}

@media (max-width: 400px) {
    .stat-content {
        flex-direction: column;
        text-align: center;
    }

    .stat-icon {
        margin-top: 0.5rem;
        margin-left: 0 !important;
    }

    .header-content {
        padding: 0 0.5rem;
    }
}
/* Nouveaux styles */
.stats-detailed-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 1.5rem;
    margin-bottom: 1.5rem;
}

.stat-card.detailed {
    padding: 1.2rem;
}

.stat-card.detailed .stat-content {
    margin-bottom: 0.5rem;
}

.stat-footer {
    border-top: 1px solid #e9ecef;
    padding-top: 0.5rem;
    font-size: 0.85rem;
}

.stat-footer .positive {
    color: #28a745;
}

.data-grid.secondary {
    grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
    margin-bottom: 1.5rem;
}

.destinations-list,
.performance-list {
    display: flex;
    flex-direction: column;
    gap: 1rem;
}

.destination-item,
.performance-item {
    display: flex;
    align-items: center;
    padding: 0.75rem;
    background-color: #f8f9fa;
    border-radius: 8px;
    transition: background-color 0.3s;
}

.destination-item:hover,
.performance-item:hover {
    background-color: #e9ecef;
}

.destination-rank {
    width: 30px;
    height: 30px;
    background-color: #4a6cf7;
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    margin-right: 1rem;
}

.destination-info h4,
.agent-info h4 {
    margin: 0;
    font-size: 1rem;
    color: #2c3e50;
}

.destination-info p,
.agent-info p {
    margin: 0;
    color: #6c757d;
    font-size: 0.85rem;
}

.destination-revenue {
    margin-left: auto;
    font-weight: bold;
    color: #28a745;
}

.performance-bar {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    margin-left: auto;
    min-width: 100px;
}

.progress-container {
    width: 100px;
    height: 8px;
    background-color: #e9ecef;
    border-radius: 4px;
    overflow: hidden;
}

.progress-bar {
    height: 100%;
    background-color: #4a6cf7;
    border-radius: 4px;
    transition: width 0.3s ease;
}

/* Améliorations responsives */
@media (max-width: 1024px) {
    .data-grid.secondary {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 768px) {
    .stats-detailed-grid {
        grid-template-columns: repeat(2, 1fr);
    }

    .destination-item,
    .performance-item {
        flex-direction: column;
        text-align: center;
        gap: 0.5rem;
    }

    .destination-revenue,
    .performance-bar {
        margin-left: 0;
    }
}

@media (max-width: 480px) {
    .stats-detailed-grid {
        grid-template-columns: 1fr;
    }
}

/* Animations */
.stat-card {
    transition: all 0.3s ease;
}

.stat-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

.chart-card,
.table-card {
    transition: transform 0.3s ease;
}

.chart-card:hover,
.table-card:hover {
    transform: translateY(-1px);
}
</style>
