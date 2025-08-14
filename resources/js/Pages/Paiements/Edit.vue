<!-- Edit.vue -->
<template>
  <AppLayout>
    <div class="card">
      <div class="card-body">
        <h4 class="mb-4">Modifier le Mode de Paiement</h4>
        <form @submit.prevent="submit">
          <div class="mb-3">
            <label>Nom</label>
            <input type="text" v-model="form.nom" class="form-control" :class="{'is-invalid': form.errors.nom}" />
            <div v-if="form.errors.nom" class="invalid-feedback">{{ form.errors.nom }}</div>
          </div>

          <button type="submit" class="btn btn-success">Mettre à jour</button>
          <Link :href="route('paiement.index')" class="btn btn-secondary">Annuler</Link>
        </form>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Link, useForm } from '@inertiajs/vue3';
import { defineProps } from 'vue';

const props = defineProps({
  mode_paiement: Object,
});

const form = useForm({
  nom: props.mode_paiement.nom,
});

function submit() {
  form.put(route('paiement.update', props.mode_paiement.id));
}
</script>
