<!-- Create.vue -->
<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { useForm } from '@inertiajs/vue3';

const props = defineProps({
    lignes: Array,
    classes: Array,
});

const form = useForm({
    ligne_id: '',
    classe_wagon_id: '',
    prix_base: '',
    date_effet: new Date().toISOString().split('T')[0],
    date_expiration: '',
});

const submit = () => {
    form.post(route('tarifs.store'));
};
</script>

<template>
    <AppLayout title="Créer un Tarif">
        <template #header>
            <h2 class="font-semibold text-xl text-gray-800 leading-tight">
                Créer un Nouveau Tarif
            </h2>
        </template>

        <div class="py-6">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                    <div class="p-6 bg-white border-b border-gray-200">
                        <form @submit.prevent="submit">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <!-- Ligne -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Ligne</label>
                                    <select
                                        v-model="form.ligne_id"
                                        class="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
                                        required
                                    >
                                        <option value="" disabled>Sélectionnez une ligne</option>
                                        <option
                                            v-for="ligne in lignes"
                                            :key="ligne.id"
                                            :value="ligne.id"
                                        >
                                            {{ ligne.nom }}
                                        </option>
                                    </select>
                                </div>

                                <!-- Classe -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Classe</label>
                                    <select
                                        v-model="form.classe_wagon_id"
                                        class="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
                                        required
                                    >
                                        <option value="" disabled>Sélectionnez une classe</option>
                                        <option
                                            v-for="classe in classes"
                                            :key="classe.id"
                                            :value="classe.id"
                                        >
                                            {{ classe.nom }}
                                        </option>
                                    </select>
                                </div>

                                <!-- Prix -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Prix de base (FCFA)</label>
                                    <input
                                        v-model="form.prix_base"
                                        type="number"
                                        min="0"
                                        step="0.01"
                                        class="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
                                        required
                                    />
                                </div>

                                <!-- Date effet -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Date d'effet</label>
                                    <input
                                        v-model="form.date_effet"
                                        type="date"
                                        class="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
                                        required
                                    />
                                </div>

                                <!-- Date expiration -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Date d'expiration (optionnel)</label>
                                    <input
                                        v-model="form.date_expiration"
                                        type="date"
                                        class="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
                                        :min="form.date_effet"
                                    />
                                </div>
                            </div>

                            <div class="mt-6 flex justify-end">
                                <button
                                    type="submit"
                                    class="btn btn-primary"
                                    :disabled="form.processing"
                                >
                                    Enregistrer
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
