<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { defineProps } from "vue";

const props = defineProps({
  categorie: Object,
});

// Initialisation du formulaire avec les données existantes
const form = useForm({
  nom: props.categorie?.nom ?? '',
  description: props.categorie?.description ?? '',
});

const { errors } = form;

// Soumission du formulaire
const submit = () => {
  form.put(route('categories-colis.update', props.categorie.id), {
    onSuccess: () => {
      Swal.fire(
        'Succès',
        'Catégorie modifiée avec succès !',
        'success'
      );
    },
    onError: () => {
      Swal.fire('Erreur', 'Veuillez vérifier les champs du formulaire.', 'error');
    }
  });
};
</script>

<template>
  <AppLayout>
    <!-- En-tête de page -->
    <div class="form-header">
      <div class="header-content">
        <div class="header-title-wrapper">
          <h1 class="page-title">Modifier une Catégorie de Colis</h1>
          <nav class="breadcrumb-wrapper">
            <ol class="breadcrumb">
              <li>
                <a href="#" class="breadcrumb-item">Accueil</a>
                <span class="breadcrumb-divider">/</span>
              </li>
              <li>
                <a href="#" class="breadcrumb-item">Catégories</a>
                <span class="breadcrumb-divider">/</span>
              </li>
              <li>
                <span class="breadcrumb-item active">Modification</span>
              </li>
            </ol>
          </nav>
        </div>
      </div>
    </div>

    <!-- Formulaire -->
    <div class="form-container">
      <div class="form-card">
        <div class="creation-form">
          <h2 class="section-title">
            <i class="mdi mdi-package-variant-closed"></i>
            Formulaire de modification
          </h2>

          <form @submit.prevent="submit">
            <div class="form-grid">
              <!-- Nom de la catégorie -->
              <div class="form-section">
                <div class="form-group">
                  <label for="nom" class="form-label required">Nom de la catégorie</label>
                  <input
                    type="text"
                    class="form-input"
                    :class="{ 'is-invalid': form.errors.nom }"
                    id="nom"
                    v-model="form.nom"
                    placeholder="Ex: Documents, Marchandises..."
                    required
                  />
                  <div v-if="form.errors.nom" class="form-error">
                    {{ form.errors.nom }}
                  </div>
                </div>
              </div>

              <!-- Description -->
              <div class="form-section">
                <div class="form-group">
                  <label for="description" class="form-label required">Description</label>
                  <textarea
                    class="form-input"
                    :class="{ 'is-invalid': form.errors.description }"
                    id="description"
                    v-model="form.description"
                    placeholder="Description courte de la catégorie"
                    rows="4"
                  ></textarea>
                  <div v-if="form.errors.description" class="form-error">
                    {{ form.errors.description }}
                  </div>
                </div>
              </div>
            </div>

            <!-- Actions du formulaire -->
            <div class="form-actions">
              <button
                type="button"
                class="btn-cancel"
                @click="form.reset()"
              >
                Annuler
              </button>
              <button
                type="submit"
                class="btn-submit"
                :disabled="form.processing"
              >
                <span v-if="form.processing" class="spinner"></span>
                {{ form.processing ? "En cours..." : "Mettre à jour" }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<style scoped>
/* Style général */
.form-header {
  background-color: #f8f9fa;
  padding: 1.5rem 2rem;
  border-bottom: 1px solid #e1e5eb;
  margin-bottom: 1.5rem;
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
}

.header-title-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.page-title {
  font-size: 1.8rem;
  font-weight: 600;
  color: #2c3e50;
  margin: 0;
}

.breadcrumb-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
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
  text-decoration: none;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.breadcrumb-item:hover {
  color: #4a6cf7;
}

.breadcrumb-item.active {
  color: #4a6cf7;
  font-weight: 500;
}

.breadcrumb-divider {
  color: #adb5bd;
  margin: 0 0.5rem;
}

.form-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1.5rem;
}

/* Carte du formulaire */
.form-card {
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  border: 1px solid #e1e5eb;
  overflow: hidden;
  margin-bottom: 2rem;
}

.creation-form {
  padding: 2rem;
}

/* Sections du formulaire */
.form-section {
  margin-bottom: 2.5rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid #f0f0f0;
}

.form-section:last-child {
  border-bottom: none;
  margin-bottom: 1.5rem;
}

.section-title {
  font-size: 1.2rem;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 1.5rem;
  display: flex;
  align-items: center;
}

.section-title i {
  color: #4a6cf7;
  margin-right: 0.5rem;
}

/* Grille de formulaire */
.form-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
}

/* Groupes de champs */
.form-group {
  margin-bottom: 1rem;
}

.form-label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #495057;
  font-size: 0.95rem;
}

.form-label.required::after {
  content: " *";
  color: #ff4d4f;
}

/* Champs de formulaire */
.form-input,
textarea.form-input {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 1px solid #e1e5eb;
  border-radius: 8px;
  font-size: 1rem;
  transition: all 0.2s;
  background-color: white;
}

textarea.form-input {
  min-height: 100px;
  resize: vertical;
}

.form-input:focus,
textarea.form-input:focus {
  border-color: #4a6cf7;
  box-shadow: 0 0 0 0.2rem rgba(74, 108, 247, 0.15);
  outline: none;
}

.form-input.is-invalid,
textarea.form-input.is-invalid {
  border-color: #ff4d4f;
}

.form-input.is-invalid:focus,
textarea.form-input.is-invalid:focus {
  box-shadow: 0 0 0 0.2rem rgba(255, 77, 79, 0.15);
}

/* Messages d'erreur */
.form-error {
  color: #ff4d4f;
  font-size: 0.85rem;
  margin-top: 0.5rem;
}

/* Boutons */
.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  margin-top: 2rem;
  padding-top: 1.5rem;
  border-top: 1px solid #f0f0f0;
}

.btn-cancel {
  background-color: white;
  border: 1px solid #e1e5eb;
  color: #495057;
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-cancel:hover {
  background-color: #f8f9fa;
  border-color: #dae0e5;
}

.btn-submit {
  background-color: #4a6cf7;
  border: none;
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.btn-submit:hover:not(:disabled) {
  background-color: #3a5ce4;
  transform: translateY(-1px);
}

.btn-submit:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.spinner {
  width: 1rem;
  height: 1rem;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  border-top-color: white;
  animation: spin 1s ease-in-out infinite;
  display: inline-block;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* Responsive */
@media (max-width: 768px) {
  .header-title-wrapper {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  .form-actions {
    flex-direction: column;
  }

  .btn-cancel, .btn-submit {
    width: 100%;
  }

  .creation-form {
    padding: 1.5rem;
  }

  .form-grid {
    grid-template-columns: 1fr;
  }
}
</style>
