<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { defineProps, watch } from "vue";

const props = defineProps({
    categories: Array,
});
// Formulaire de paramètre
const form = useForm({
    categorie_id: "",
    poids_min: 0,
    poids_max: 0,
    prix_par_kg: 0,
});

watch(() => form.poids_max, (val) => {
    if (val < form.poids_min) {
        Swal.fire("Attention", "Le poids maximum doit être supérieur au minimum", "warning");
    }
});
watch(() => form.poids_min, (val) => {
    if (val < 0) {
        Swal.fire("Attention", "Le poids minimum ne peut pas être négatif", "warning");
    }
});

// Soumission du formulaire
const submit = () => {
    form.post(route("setting.store"), {
        preserveScroll: true,
        onSuccess: () => {
            Swal.fire("Succès", "Paramètre ajouté avec succès.", "success");
            form.reset();
        },
        onError: () => {
            Swal.fire("Erreur", "Merci de vérifier le formulaire.", "error");
        },
    });
};
</script>

<template>
    <AppLayout>
        <!-- 🧭 Titre -->
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Paramètres du prix au kilo</h4>
                </div>
            </div>
        </div>

        <!-- 📋 Formulaire -->
        <div class="row flex-grow">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Définir un nouveau tarif</h4>
                        <form class="forms-sample" @submit.prevent="submit">
                            <div class="form-group">
                                <label for="categorie_id">Catégorie</label>
                                <select
                                    id="categorie_id"
                                    class="form-control"
                                    v-model="form.categorie_id"
                                    required
                                >
                                    <option disabled value="">
                                        -- Sélectionner une catégorie --
                                    </option>
                                    <option
                                        v-for="cat in props.categories"
                                        :key="cat.id"
                                        :value="cat.id"
                                    >
                                        {{ cat.nom }}
                                    </option>
                                </select>
                                <div
                                    v-if="form.errors.categorie_id"
                                    class="text-danger"
                                >
                                    {{ form.errors.categorie_id }}
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="poids_min"
                                    >Poids minimum (Kg)</label
                                >
                                <input
                                    type="number"
                                    id="poids_min"
                                    v-model="form.poids_min"
                                    class="form-control"
                                    placeholder="Ex: 0"
                                    min="0"
                                    step="0.1"
                                    required
                                />
                                <div
                                    v-if="form.errors.poids_min"
                                    class="text-danger"
                                >
                                    {{ form.errors.poids_min }}
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="poids_max"
                                    >Poids maximum (Kg)</label
                                >
                                <input
                                    type="number"
                                    id="poids_max"
                                    v-model="form.poids_max"
                                    class="form-control"
                                    placeholder="Ex: 10"
                                    min="0"
                                    step="0.1"
                                    required
                                />
                                <div
                                    v-if="form.errors.poids_max"
                                    class="text-danger"
                                >
                                    {{ form.errors.poids_max }}
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="prix_par_kg"
                                    >Prix par Kg (en FCFA)</label
                                >
                                <input
                                    type="number"
                                    id="prix_par_kg"
                                    v-model="form.prix_par_kg"
                                    class="form-control"
                                    placeholder="Ex: 250"
                                    min="0"
                                    step="10"
                                    required
                                />
                                <div
                                    v-if="form.errors.prix_par_kg"
                                    class="text-danger"
                                >
                                    {{ form.errors.prix_par_kg }}
                                </div>
                            </div>

                            <!-- Boutons -->
                            <div class="d-flex justify-content-end mt-4">
                                <button
                                    type="reset"
                                    class="btn btn-light mr-2"
                                    @click="form.reset()"
                                >
                                    Annuler
                                </button>
                                <button
                                    type="submit"
                                    class="btn btn-primary"
                                    :disabled="form.processing"
                                >
                                    <span
                                        v-if="form.processing"
                                        class="spinner-border spinner-border-sm"
                                        role="status"
                                        aria-hidden="true"
                                    ></span>
                                    {{
                                        form.processing
                                            ? "En cours..."
                                            : "Valider"
                                    }}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
