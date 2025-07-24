<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Link, router, useForm } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import { Pencil, Trash, Plus } from 'lucide-vue-next';
import Swal from 'sweetalert2';

const props = defineProps({
  modes_paiement: Object,
  filters: Object,
});

const filters = ref({ search: props.filters.search || '' });

watch(() => filters.value.search, (val) => {
  router.get(route('paiement.index'), { search: val }, { preserveState: true, replace: true });
});

function editPaiement(id) {
  router.visit(route('paiement.edit', id));
}

function deletePaiement(id) {
  Swal.fire({
    title: 'Confirmer la suppression ?',
    showCancelButton: true,
    confirmButtonText: 'Oui, supprimer',
  }).then((result) => {
    if (result.isConfirmed) {
      router.delete(route('paiement.destroy', id));
    }
  });
}
</script>

<template>
  <AppLayout>
    <div class="row page-title-header">
      <div class="col-12">
        <div class="page-header">
          <h4 class="page-title">Gestion des Modes de Paiement</h4>
          <div class="quick-link-wrapper w-100 d-md-flex flex-md-wrap">
            <ul class="quick-links ml-auto">
              <li><Link :href="route('dashboard')">Tableau de bord</Link></li>
              <li><a href="#">Modes de Paiement</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <div class="row mb-3">
      <div class="col-md-6">
        <input v-model="filters.search" type="text" placeholder="Rechercher..." class="form-control" />
      </div>
    </div>

    <div class="card">
      <div class="card-body">
        <div class="d-flex justify-content-between mb-3">
          <h4>Liste des Modes de Paiement</h4>
          <Link :href="route('paiement.create')" class="btn btn-primary">
            <Plus size="16" class="me-1" /> Nouveau Mode de Paiement
          </Link>
        </div>

        <table class="table table-bordered">
          <thead>
            <tr>
              <th>#</th>
              <th>Nom</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in modes_paiement.data" :key="item.id">
              <td>{{ index + 1 }}</td>
              <td>{{ item.type }}</td>
              <td>
                <button class="btn btn-warning btn-sm" @click="editPaiement(item.id)"><Pencil size="16" /></button>
                <button class="btn btn-danger btn-sm" @click="deletePaiement(item.id)"><Trash size="16" /></button>
              </td>
            </tr>
            <tr v-if="!modes_paiement.data.length">
              <td colspan="3" class="text-center">Aucun mode de paiement trouvé.</td>
            </tr>
          </tbody>
        </table>

        <pagination :links="modes_paiement.links" />
      </div>
    </div>
  </AppLayout>
</template>
