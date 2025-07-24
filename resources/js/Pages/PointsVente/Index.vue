<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Plus, Pencil, Trash, Search } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    pointsVente: Object,
    filters: Object,
    flash: Object,
});

const filters = reactive({
    search: props.filters.search || "",
});

watch(
    () => filters.search,
    (search) => {
        router.get(route('points-vente.index'), { search }, {
            preserveState: true,
            replace: true,
        });
    }
);

const deletePoint = (id) => {
    Swal.fire({
        title: "Confirmer la suppression",
        text: "Êtes-vous sûr de vouloir supprimer ce point de vente ?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Oui, supprimer",
        cancelButtonText: "Annuler",
    }).then((result) => {
        if (result.isConfirmed) {
            router.delete(route('points-vente.destroy', id));
        }
    });
};
</script>

<template>
    <AppLayout>
        <!-- En-tête de page -->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Points de Vente</h4>
                    <div class="quick-link-wrapper w-100 d-md-flex flex-md-wrap">
                        <ul class="quick-links ml-auto">
                            <li><Link :href="route('dashboard')">Tableau de bord</Link></li>
                            <li><Link :href="route('points-vente.index')">Points de vente</Link></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Barre de recherche -->
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="input-group">
                    <input
                        type="text"
                        v-model="filters.search"
                        placeholder="Rechercher par gare..."
                        class="form-control"
                    />
                    <button class="btn btn-outline-secondary" type="button">
                        <Search class="h-4 w-4" />
                    </button>
                </div>
            </div>
        </div>

        <!-- Tableau des points de vente -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="card-title mb-0">Liste des points de vente</h4>
                            <Link
                                :href="route('points-vente.create')"
                                class="btn btn-primary btn-icon-text"
                            >
                                <Plus size="16" class="me-1" />
                                Nouveau point de vente
                            </Link>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Gare</th>
                                        <th>Type de gare</th>
                                        <th>Type de point</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(point, index) in pointsVente.data" :key="point.id">
                                        <td>{{ index + 1 }}</td>
                                        <td>{{ point.gare_nom }}</td>
                                        <td>{{ point.gare_type }}</td>
                                        <td class="text-capitalize">{{ point.type }}</td>
                                        <td>
                                            <span :class="{
                                                'badge bg-success': point.actif === 'Actif',
                                                'badge bg-danger': point.actif === 'Inactif'
                                            }">
                                                {{ point.actif }}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <Link
                                                    :href="route('points-vente.edit', point.id)"
                                                    class="btn btn-warning btn-sm"
                                                >
                                                    <Pencil size="16" />
                                                </Link>
                                                <button
                                                    @click="deletePoint(point.id)"
                                                    class="btn btn-danger btn-sm"
                                                >
                                                    <Trash size="16" />
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr v-if="pointsVente.data.length === 0">
                                        <td colspan="6" class="text-center py-4 text-muted">
                                            Aucun point de vente trouvé
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <p class="text-muted">
                                    Affichage de {{ pointsVente.from }} à {{ pointsVente.to }} sur {{ pointsVente.total }} points
                                </p>
                            </div>
                            <div class="col-md-6">
                                <nav class="float-end">
                                    <ul class="pagination">
                                        <li
                                            v-for="link in pointsVente.links"
                                            :key="link.label"
                                            class="page-item"
                                            :class="{
                                                active: link.active,
                                                disabled: !link.url,
                                            }"
                                        >
                                            <Link
                                                v-if="link.url"
                                                :href="link.url"
                                                class="page-link"
                                                v-html="link.label"
                                            />
                                            <span
                                                v-else
                                                class="page-link"
                                                v-html="link.label"
                                            ></span>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
.text-capitalize {
    text-transform: capitalize;
}
</style>
