<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, ref } from "vue";
import { router } from "@inertiajs/vue3";
import { useForm } from "@inertiajs/vue3";
import { Link } from "@inertiajs/vue3";
import { Pencil, LogOut } from "lucide-vue-next";

const props = defineProps({
    user: Object,
});

// Gestion du modal
const showModal = ref(false);

// Formulaire
const form = useForm({
    name: props.user.name,
    email: props.user.email,
    username: props.user.username,
});

const submit = () => {
    form.put(route("profile.update"), {
        preserveScroll: true,
        onSuccess: () => {
            showModal.value = false;
        },
    });
};

const confirmLogout = () => {
    if (confirm("Voulez-vous vraiment vous déconnecter ?")) {
        router.post(route("logout"));
    }
};
</script>

<template>
    <AppLayout>
        <!-- En-tête de page -->
        <div class="profile-header">
            <div class="header-content">
                <h1 class="page-title">Profil Utilisateur</h1>
                <p class="page-subtitle">
                    Gestion des informations personnelles
                </p>
                <div class="breadcrumb">
                    <span>Tableau de bord</span> / <span>Profil</span> /
                    <span class="active">{{ user.name }}</span>
                </div>
            </div>
        </div>

        <!-- Contenu principal -->
        <div class="profile-container">
            <div class="profile-grid">
                <!-- Carte Avatar -->
                <div class="profile-card profile-card-avatar">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-user-circle icon"></i>
                            Photo de profil
                        </h2>
                    </div>
                    <div class="card-body">
                        <div class="avatar-container">
                            <img
                                src="/resources/js/assets/images/user-icon.png"
                                alt="Photo de profil"
                                class="avatar-image"
                            />
                            <div class="avatar-overlay">
                                <button class="btn-avatar-edit">
                                    <i class="fas fa-camera"></i> Changer
                                </button>
                            </div>
                        </div>
                        <div class="user-info">
                            <h3 class="user-name">{{ user.name }}</h3>
                            <div class="user-roles">
                                <span
                                    v-for="role in user.roles"
                                    :key="role"
                                    class="role-badge"
                                >
                                    {{ role }}
                                </span>
                            </div>
                            <div class="user-email">
                                <i class="fas fa-envelope"></i> {{ user.email }}
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Carte Informations personnelles -->
                <div class="profile-card profile-card-details">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-id-card icon"></i>
                            Informations personnelles
                        </h2>
                        <button @click="showModal = true" class="btn-edit">
                            <Pencil class="icon" size="16" />
                            Modifier
                        </button>
                    </div>
                    <div class="card-body">
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-user"></i> Nom complet
                                </div>
                                <div class="info-value">{{ user.name }}</div>
                            </div>

                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-at"></i> Adresse email
                                </div>
                                <div class="info-value">{{ user.email }}</div>
                            </div>

                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-user-tag"></i> Rôle(s)
                                </div>
                                <div class="info-value">
                                    <div class="roles-container">
                                        <span
                                            v-for="role in user.roles"
                                            :key="role"
                                            class="role-tag"
                                        >
                                            {{ role }}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Carte Actions -->
                <div class="profile-card profile-card-actions">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-cog icon"></i>
                            Actions
                        </h2>
                    </div>
                    <div class="card-body">
                        <button
                            @click="confirmLogout"
                            class="profile-action-btn text-danger"
                        >
                            <LogOut class="icon" size="16" />
                            Déconnexion
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal de modification -->
        <div v-if="showModal" class="modal-overlay">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title">Modifier le profil</h3>
                    <button @click="showModal = false" class="modal-close">
                        &times;
                    </button>
                </div>
                <form @submit.prevent="submit" class="modal-body">
                    <div class="form-group">
                        <label>Nom complet</label>
                        <input
                            v-model="form.name"
                            type="text"
                            class="form-input"
                        />
                        <p v-if="form.errors.name" class="error-message">
                            {{ form.errors.name }}
                        </p>
                    </div>

                    <div class="form-group">
                        <label>Adresse email</label>
                        <input
                            v-model="form.email"
                            type="email"
                            class="form-input"
                        />
                        <p v-if="form.errors.email" class="error-message">
                            {{ form.errors.email }}
                        </p>
                    </div>

                    <div class="form-group">
                        <label>Nom d'utilisateur</label>
                        <input
                            v-model="form.username"
                            type="text"
                            class="form-input"
                        />
                        <p v-if="form.errors.username" class="error-message">
                            {{ form.errors.username }}
                        </p>
                    </div>

                    <div class="modal-footer">
                        <button
                            type="button"
                            @click="showModal = false"
                            class="btn-secondary"
                        >
                            Annuler
                        </button>
                        <button
                            type="submit"
                            class="btn-primary"
                            :disabled="form.processing"
                        >
                            <span v-if="form.processing"
                                >Enregistrement...</span
                            >
                            <span v-else>Enregistrer</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
/* Styles généraux */
.profile-header {
    background-color: #f8f9fa;
    padding: 1.5rem 2rem;
    border-bottom: 1px solid #e1e5eb;
    margin-bottom: 2rem;
}

.header-content {
    max-width: 1200px;
    margin: 0 auto;
}

.page-title {
    font-size: 1.8rem;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 0.5rem;
}

.page-subtitle {
    font-size: 1rem;
    color: #7a8a9b;
    margin-bottom: 0.5rem;
}

.breadcrumb {
    font-size: 0.85rem;
    color: #6c757d;
}

.breadcrumb .active {
    color: #4a6cf7;
    font-weight: 500;
}

.profile-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 1rem;
}

.profile-grid {
    display: grid;
    grid-template-columns: 300px 1fr;
    gap: 1.5rem;
}

/* Cartes */
.profile-card {
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
    border: 1px solid #e1e5eb;
    overflow: hidden;
}

.card-header {
    padding: 1rem 1.5rem;
    border-bottom: 1px solid #f0f0f0;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.card-title {
    font-size: 1.1rem;
    font-weight: 600;
    color: #2c3e50;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.card-body {
    padding: 1.5rem;
}

/* Avatar */
.avatar-container {
    position: relative;
    width: 150px;
    height: 150px;
    margin: 0 auto 1.5rem;
    border-radius: 50%;
    overflow: hidden;
    border: 3px solid #e1e5eb;
}

.avatar-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.avatar-overlay {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    background-color: rgba(0, 0, 0, 0.5);
    padding: 0.5rem;
    text-align: center;
    opacity: 0;
    transition: opacity 0.3s;
}

.avatar-container:hover .avatar-overlay {
    opacity: 1;
}

.btn-avatar-edit {
    background-color: transparent;
    border: 1px solid white;
    color: white;
    padding: 0.2rem 0.5rem;
    border-radius: 4px;
    font-size: 0.8rem;
    cursor: pointer;
}

/* Informations utilisateur */
.user-info {
    text-align: center;
}

.user-name {
    font-size: 1.4rem;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 0.5rem;
}

.user-email {
    color: #6c757d;
    margin-top: 0.5rem;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
}

.user-roles,
.roles-container {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 0.5rem;
    margin-bottom: 1rem;
}

.role-badge {
    background-color: #4a6cf7;
    color: white;
    padding: 0.3rem 0.8rem;
    border-radius: 20px;
    font-size: 0.8rem;
    font-weight: 500;
}

.role-tag {
    background-color: #e9ecef;
    color: #495057;
    padding: 0.3rem 0.8rem;
    border-radius: 4px;
    font-size: 0.85rem;
    border-left: 3px solid #4a6cf7;
}

/* Grille d'informations */
.info-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 1.5rem;
}

.info-item {
    margin-bottom: 0;
}

.info-label {
    font-size: 0.9rem;
    color: #6c757d;
    margin-bottom: 0.3rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.info-value {
    font-size: 1rem;
    font-weight: 500;
    color: #2c3e50;
}

/* Boutons */
.btn-edit {
    background-color: #4a6cf7;
    color: white;
    padding: 0.5rem 1rem;
    border-radius: 6px;
    font-size: 0.9rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    transition: background-color 0.2s;
}

.btn-edit:hover {
    background-color: #3a5bd9;
}

.profile-action-btn {
    display: flex;
    align-items: center;
    gap: 0.8rem;
    width: 100%;
    padding: 0.8rem 1rem;
    background-color: #f8f9fa;
    border: 1px solid #e1e5eb;
    border-radius: 6px;
    color: #495057;
    cursor: pointer;
    transition: all 0.2s;
}

.profile-action-btn:hover {
    background-color: #e9ecef;
}

.profile-action-btn.text-danger {
    color: #dc3545;
}

/* Modal */
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
}

.modal-content {
    background-color: white;
    border-radius: 10px;
    width: 100%;
    max-width: 500px;
    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    animation: modalFadeIn 0.3s;
}

@keyframes modalFadeIn {
    from {
        opacity: 0;
        transform: translateY(-20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.modal-header {
    padding: 1.5rem;
    border-bottom: 1px solid #e1e5eb;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.modal-title {
    font-size: 1.3rem;
    font-weight: 600;
    color: #2c3e50;
}

.modal-close {
    font-size: 1.5rem;
    color: #6c757d;
    background: none;
    border: none;
    cursor: pointer;
}

.modal-body {
    padding: 1.5rem;
}

.form-group {
    margin-bottom: 1.5rem;
}

.form-group label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
    color: #495057;
}

.form-input {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #ced4da;
    border-radius: 6px;
    font-size: 1rem;
    transition: border-color 0.2s;
}

.form-input:focus {
    border-color: #4a6cf7;
    outline: none;
    box-shadow: 0 0 0 3px rgba(74, 108, 247, 0.1);
}

.error-message {
    color: #dc3545;
    font-size: 0.85rem;
    margin-top: 0.25rem;
}

.modal-footer {
    padding: 1.5rem;
    border-top: 1px solid #e1e5eb;
    display: flex;
    justify-content: flex-end;
    gap: 1rem;
}

.btn-primary {
    background-color: #4a6cf7;
    color: white;
    padding: 0.75rem 1.5rem;
    border-radius: 6px;
    font-weight: 500;
    border: none;
    cursor: pointer;
    transition: background-color 0.2s;
}

.btn-primary:hover {
    background-color: #3a5bd9;
}

.btn-primary:disabled {
    background-color: #a0aec0;
    cursor: not-allowed;
}

.btn-secondary {
    background-color: #f8f9fa;
    color: #495057;
    padding: 0.75rem 1.5rem;
    border-radius: 6px;
    font-weight: 500;
    border: 1px solid #e1e5eb;
    cursor: pointer;
    transition: all 0.2s;
}

.btn-secondary:hover {
    background-color: #e9ecef;
}

/* Responsive */
@media (max-width: 992px) {
    .profile-grid {
        grid-template-columns: 1fr;
    }

    .info-grid {
        grid-template-columns: 1fr;
    }
}
</style>
