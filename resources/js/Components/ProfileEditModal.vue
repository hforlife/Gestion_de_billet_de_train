<script setup>
import { ref, watch } from 'vue';
import { useForm } from '@inertiajs/vue3';

const props = defineProps({
    user: Object,
    show: Boolean
});

const emit = defineEmits(['close']);

const form = useForm({
    name: props.user.name,
    email: props.user.email,
    username: props.user.username,
});

const submit = () => {
    form.put(route('profile.update'), {
        preserveScroll: true,
        onSuccess: () => {
            emit('close');
        },
    });
};

// Réinitialiser le formulaire quand le modal s'ouvre
watch(() => props.show, (newVal) => {
    if (newVal) {
        form.reset();
        form.name = props.user.name;
        form.email = props.user.email;
        form.username = props.user.username;
    }
});
</script>

<!-- ProfileEditModal.vue -->
<template>
  <transition name="fade">
    <div v-if="show" class="fixed inset-0 z-50 flex items-center justify-center p-4">
      <!-- Fond -->
      <div class="absolute inset-0 bg-black/40 backdrop-blur-sm" @click="$emit('close')"></div>

      <!-- Modal -->
      <div class="relative w-full max-w-md bg-white rounded-xl shadow-lg p-6 animate-fadeIn">
        <!-- En-tête -->
        <div class="flex justify-between items-center mb-4">
          <h3 class="text-lg font-semibold text-gray-800">Modifier le profil</h3>
          <button @click="$emit('close')" class="text-gray-400 hover:text-gray-600">
            <svg class="h-5 w-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <!-- Formulaire -->
        <form @submit.prevent="submit" class="space-y-4">
          <!-- Nom -->
          <div>
            <input
              v-model="form.name"
              type="text"
              placeholder="Nom complet"
              class="input"
              :class="{ 'border-red-300': form.errors.name }"
            />
            <p v-if="form.errors.name" class="text-sm text-red-500 mt-1">{{ form.errors.name }}</p>
          </div>

          <!-- Email -->
          <div>
            <input
              v-model="form.email"
              type="email"
              placeholder="Adresse email"
              class="input"
              :class="{ 'border-red-300': form.errors.email }"
            />
            <p v-if="form.errors.email" class="text-sm text-red-500 mt-1">{{ form.errors.email }}</p>
          </div>

          <!-- Username -->
          <div>
            <input
              v-model="form.username"
              type="text"
              placeholder="Nom d'utilisateur"
              class="input"
              :class="{ 'border-red-300': form.errors.username }"
            />
            <p v-if="form.errors.username" class="text-sm text-red-500 mt-1">{{ form.errors.username }}</p>
          </div>

          <!-- Boutons -->
          <div class="flex justify-end gap-2 pt-2">
            <button
              type="button"
              @click="$emit('close')"
              class="px-4 py-2 text-sm rounded-lg border border-gray-300 text-gray-600 hover:bg-gray-100"
            >
              Annuler
            </button>
            <button
              type="submit"
              :disabled="form.processing"
              class="px-4 py-2 text-sm rounded-lg bg-blue-600 text-white hover:bg-blue-700 disabled:opacity-50"
            >
              Enregistrer
            </button>
          </div>
        </form>
      </div>
    </div>
  </transition>
</template>

<style scoped>
.input {
  @apply w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500;
}
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
.animate-fadeIn {
  animation: fadeIn 0.25s ease-out;
}
</style>

