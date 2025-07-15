<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, onMounted, ref } from 'vue';
import { Chart, registerables } from 'chart.js';
import { TrainFront, Landmark, MapPinned, ShoppingCart } from 'lucide-vue-next';

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
        const ctx = document.getElementById('ventes-chart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: props.graph_data.map(item => item.mois),
                datasets: [
                    {
                        label: 'Nombre de ventes',
                        data: props.graph_data.map(item => item.ventes),
                        backgroundColor: 'rgba(54, 162, 235, 0.5)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1,
                        yAxisID: 'y',
                    },
                    {
                        label: 'Revenus (FCFA)',
                        data: props.graph_data.map(item => item.revenus),
                        backgroundColor: 'rgba(75, 192, 192, 0.5)',
                        borderColor: 'rgba(75, 192, 192, 1)',
                        borderWidth: 1,
                        type: 'line',
                        yAxisID: 'y1',
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    title: {
                        display: true,
                        text: 'Ventes et revenus mensuels'
                    },
                },
                scales: {
                    y: {
                        type: 'linear',
                        display: true,
                        position: 'left',
                        title: {
                            display: true,
                            text: 'Nombre de ventes'
                        }
                    },
                    y1: {
                        type: 'linear',
                        display: true,
                        position: 'right',
                        title: {
                            display: true,
                            text: 'Revenus (FCFA)'
                        },
                        grid: {
                            drawOnChartArea: false,
                        },
                    }
                }
            }
        });
    }
});
</script>

<template>
    <AppLayout>
        <!-- 🧭 Titre -->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Tableau de bord</h4>
                    <div
                        class="quick-link-wrapper w-100 d-md-flex flex-md-wrap"
                    >
                        <ul class="quick-links ml-auto">
                           <li><a href="#">Tableau de bord</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Count -->
        <div class="row">
            <div class="col-md-12 grid-margin">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-lg-3 col-md-6">
                                <div class="d-flex">
                                    <div class="wrapper">
                                        <h3 class="mb-0 font-weight-semibold">
                                            {{ voyages }}
                                        </h3>
                                        <h5 class="mb-0 font-weight-medium text-primary">
                                            Total Voyage
                                        </h5>
                                        <p class="mb-0 text-muted">
                                            +14.00(+0.50%)
                                        </p>
                                    </div>
                                    <div class="wrapper my-auto ml-auto ml-lg-4">
                                        <MapPinned color="#2aab45" size="50"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 mt-md-0 mt-4">
                                <div class="d-flex">
                                    <div class="wrapper">
                                        <h3 class="mb-0 font-weight-semibold">
                                            {{ tickets }}
                                        </h3>
                                        <h5 class="mb-0 font-weight-medium text-primary">
                                            Total Ventes
                                        </h5>
                                        <p class="mb-0 text-muted">
                                            +138.97(+0.54%)
                                        </p>
                                    </div>
                                    <div class="wrapper my-auto ml-auto ml-lg-4">
                                        <ShoppingCart color="#2aab45" size="50"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 mt-md-0 mt-4">
                                <div class="d-flex">
                                    <div class="wrapper">
                                        <h3 class="mb-0 font-weight-semibold">
                                            {{ trains }}
                                        </h3>
                                        <h5 class="mb-0 font-weight-medium text-primary">
                                            Total Trains
                                        </h5>
                                        <p class="mb-0 text-muted">
                                            +57.62(+0.76%)
                                        </p>
                                    </div>
                                    <div class="wrapper my-auto ml-auto ml-lg-4">
                                        <TrainFront color="#2aab45" size="50"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 mt-md-0 mt-4">
                                <div class="d-flex">
                                    <div class="wrapper">
                                        <h3 class="mb-0 font-weight-semibold">
                                            {{ gares }}
                                        </h3>
                                        <h5 class="mb-0 font-weight-medium text-primary">
                                            Total Gares
                                        </h5>
                                        <p class="mb-0 text-muted">
                                            +138.97(+0.54%)
                                        </p>
                                    </div>
                                    <div class="wrapper my-auto ml-auto ml-lg-4">
                                        <Landmark color="#2aab45" size="50" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Fin Count -->

        <!-- Stats Revenus et Colis -->
        <div class="row">
            <div class="col-md-6 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="d-flex align-items-center pb-2">
                                    <div class="dot-indicator bg-danger mr-2"></div>
                                    <p class="mb-0">Total ventes</p>
                                </div>
                                <h4 class="font-weight-semibold">{{ stats.total_ventes }}</h4>
                                <div class="progress progress-md">
                                    <div class="progress-bar bg-danger" role="progressbar" style="width: 78%" aria-valuenow="78" aria-valuemin="0" aria-valuemax="78"></div>
                                </div>
                            </div>
                            <div class="col-md-6 mt-4 mt-md-0">
                                <div class="d-flex align-items-center pb-2">
                                    <div class="dot-indicator bg-success mr-2"></div>
                                    <p class="mb-0">Revenu total</p>
                                </div>
                                <h4 class="font-weight-semibold">{{ stats.revenus_totaux }} FCFA</h4>
                                <div class="progress progress-md">
                                    <div class="progress-bar bg-success" role="progressbar" style="width: 45%" aria-valuenow="45" aria-valuemin="0" aria-valuemax="45"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-6 grid-margin stretch-card average-price-card">
                <div class="card text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between pb-2 align-items-center">
                            <h2 class="font-weight-semibold mb-0">{{ stats.colis_express }}</h2>
                            <div class="icon-holder">
                                <i class="mdi mdi-briefcase-outline"></i>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between">
                            <h5 class="font-weight-semibold mb-0">Total Colis Express</h5>
                            <p class="text-white mb-0">Transférés par vous</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tableau des revenus mensuels -->
        <div class="col-md-12 grid-margin">
            <div class="card">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <h4 class="card-title mb-0">Revenus mensuels</h4>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
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
                                    <td>{{ item.revenus }} FCFA</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Graphique -->
        <div class="row">
            <div class="col-lg-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Statistiques des ventes et revenus mensuels</h4>
                        <div class="chart-container">
                            <canvas id="ventes-chart" height="150"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
