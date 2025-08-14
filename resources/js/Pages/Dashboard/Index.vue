<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import Calendar from "@/Components/Calendar.vue";
import { defineProps, onMounted, ref } from "vue";
import { Chart, registerables } from "chart.js";
import { TrainFront, Landmark, MapPinned, ShoppingCart } from "lucide-vue-next";

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
        }),
    },
    revenus_mensuels: Array,
    graph_data: Array,
});

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
                        backgroundColor: "rgba(54, 162, 235, 0.5)",
                        borderColor: "rgba(54, 162, 235, 1)",
                        borderWidth: 1,
                        yAxisID: "y",
                    },
                    {
                        label: "Revenus (FCFA)",
                        data: props.graph_data.map((item) => item.revenus),
                        backgroundColor: "rgba(75, 192, 192, 0.5)",
                        borderColor: "rgba(75, 192, 192, 1)",
                        borderWidth: 1,
                        type: "line",
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
                },
            },
        });
    }
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

        <!-- Cartes de statistiques -->
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

        <!-- Stats Revenus et Colis -->
        <div class="revenue-grid">
            <!-- Carte Ventes -->
            <div class="revenue-card">
                <div class="card-header">
                    <div class="header-dot bg-danger"></div>
                    <h4>Total Ventes</h4>
                </div>
                <div class="card-body">
                    <h2>{{ stats.total_ventes }}</h2>
                    <div class="progress-container">
                        <div
                            class="progress-bar bg-danger"
                            style="width: 78%"
                        ></div>
                    </div>
                </div>
            </div>

            <!-- Carte Revenus -->
            <div class="revenue-card">
                <div class="card-header">
                    <div class="header-dot bg-success"></div>
                    <h4>Revenu Total</h4>
                </div>
                <div class="card-body">
                    <h2>{{ stats.revenus_totaux }} FCFA</h2>
                    <div class="progress-container">
                        <div
                            class="progress-bar bg-success"
                            style="width: 45%"
                        ></div>
                    </div>
                </div>
            </div>

            <!-- Carte Colis -->
            <div class="revenue-card highlight">
                <div class="card-header">
                    <div class="header-dot bg-warning"></div>
                    <h4>Colis Express</h4>
                </div>
                <div class="card-body">
                    <h2>{{ stats.colis_express }}</h2>
                    <p class="text-white mb-0">Transférés par vous</p>
                </div>
                <div class="card-icon">
                    <i class="mdi mdi-briefcase-outline"></i>
                </div>
            </div>
        </div>

<!-- Graphique et Tableau -->
        <div class="data-grid">

            <!-- Tableau -->
            <div class="table-card">
                <div class="card-header">
                    <h3>Revenus mensuels</h3>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="data-table table ">
                            <thead>
                                <tr>
                                    <th>Mois</th>
                                    <th>Nombre de ventes</th>
                                    <th>Revenus (FCFA)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="item in graph_data" :key="item.mois">
                                    <td>{{ item.mois }}</td>
                                    <td>{{ item.ventes }}</td>
                                    <td class="text-success">{{ item.revenus }} FCFA</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>


            <!-- Graphique -->
            <div class="chart-card">
                <div class="card-header">
                    <h3>Statistiques des ventes et revenus mensuels</h3>
                </div>
                <div class="card-body">
                     <div class="chart-container">
                        <canvas id="ventes-chart" height="150"></canvas>
                    </div>
                </div>
            </div>


        </div>




        <!-- Calendrier -->
        <!-- <div class="row">
            <div class="lg:col-span-2">
                <Calendar :events="events" />
            </div>
         </div> -->
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
</style>
