<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps } from "vue";

const props = defineProps({
    user: Object,
});
</script>

<template>
    <AppLayout>
        <!-- En-tête de page -->
        <div class="profile-header">
            <div class="header-content">
                <h1 class="page-title">Profil Utilisateur</h1>
                <p class="page-subtitle">Gestion des informations personnelles</p>
                <div class="breadcrumb">
                    <span>Tableau de bord</span> / <span>Profil</span> / <span class="active">{{ user.name }}</span>
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
                        <button class="btn-edit">
                            <i class="fas fa-edit"></i> Modifier
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

                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-calendar-alt"></i> Date d'inscription
                                </div>
                                <div class="info-value">15 Mars 2023</div>
                            </div>

                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-clock"></i> Dernière connexion
                                </div>
                                <div class="info-value">Aujourd'hui, 14:32</div>
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
                        <button class="profile-action-btn">
                            <i class="fas fa-key"></i> Changer le mot de passe
                        </button>
                        <button class="profile-action-btn">
                            <i class="fas fa-bell"></i> Préférences de notifications
                        </button>
                        <button class="profile-action-btn">
                            <i class="fas fa-language"></i> Langue préférée
                        </button>
                        <button class="profile-action-btn text-danger">
                            <i class="fas fa-sign-out-alt"></i> Déconnexion
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
/* Style général */
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

/* Cartes de profil */
.profile-card {
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    border: 1px solid #e1e5eb;
    overflow: hidden;
    margin-bottom: 1.5rem;
}

.profile-card-avatar {
    grid-row: span 1;
}

.profile-card-details {
    grid-column: 2;
    grid-row: 1;
}

.profile-card-actions {
    grid-column: 1;
    grid-row: 2;
}

.card-header {
    padding: 1rem 1.5rem;
    border-bottom: 1px solid #f0f0f0;
    background-color: #f9fafb;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.card-title {
    font-size: 1.1rem;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 0;
    display: flex;
    align-items: center;
}

.card-title .icon {
    margin-right: 0.75rem;
    color: #4a6cf7;
    font-size: 1.1em;
}

.btn-edit {
    background-color: transparent;
    border: 1px solid #4a6cf7;
    color: #4a6cf7;
    padding: 0.3rem 0.8rem;
    border-radius: 4px;
    font-size: 0.85rem;
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.btn-edit:hover {
    background-color: #4a6cf7;
    color: white;
}

.card-body {
    padding: 1.5rem;
}

/* Section Avatar */
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
    transition: all 0.2s;
}

.btn-avatar-edit:hover {
    background-color: rgba(255, 255, 255, 0.2);
}

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

/* Badges de rôles */
.user-roles {
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

.roles-container {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
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

.info-label i {
    color: #4a6cf7;
    width: 20px;
    text-align: center;
}

.info-value {
    font-size: 1rem;
    font-weight: 500;
    color: #2c3e50;
}

/* Boutons d'action */
.profile-action-btn {
    display: flex;
    align-items: center;
    gap: 0.8rem;
    width: 100%;
    padding: 0.8rem 1rem;
    margin-bottom: 0.7rem;
    background-color: #f8f9fa;
    border: 1px solid #e1e5eb;
    border-radius: 6px;
    color: #495057;
    text-align: left;
    cursor: pointer;
    transition: all 0.2s;
}

.profile-action-btn:hover {
    background-color: #e9ecef;
    border-color: #dae0e5;
    transform: translateX(3px);
}

.profile-action-btn i {
    color: #4a6cf7;
    font-size: 1.1em;
    width: 20px;
}

.profile-action-btn.text-danger {
    color: #dc3545;
}

.profile-action-btn.text-danger i {
    color: #dc3545;
}

/* Responsive */
@media (max-width: 992px) {
    .profile-grid {
        grid-template-columns: 1fr;
    }

    .profile-card-details {
        grid-column: 1;
        grid-row: 2;
    }

    .profile-card-actions {
        grid-row: 3;
    }

    .info-grid {
        grid-template-columns: 1fr;
    }
}
</style>
