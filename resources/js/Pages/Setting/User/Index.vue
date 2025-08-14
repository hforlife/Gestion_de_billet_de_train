<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Pencil, Trash, Eye, Plus } from "lucide-vue-next";
import Swal from "sweetalert2";
import { ref, onMounted } from "vue";

const tableWrapper = ref(null);

onMounted(() => {
    console.log("Table wrapper:", tableWrapper.value);
});

const props = defineProps({
    users: Object, // ✅ c’est un objet paginé, pas Array !
    filters: Object,
    flash: Object, // ✅ pour les messages flash
});

// 🔍 Filtres réactifs
const filters = reactive({
    search: props.filters.search || "",
});

// 🔍 Watch pour mise à jour auto lors de la recherche
watch(
    () => filters.search,
    (newValue) => {
        router.get(
            route("user.index"),
            { search: newValue },
            {
                preserveState: true,
                replace: true,
            }
        );
    }
);

// Affichage du message flash
if (props.flash && props.flash.success) {
    Swal.fire("Succès", props.flash.success, "success");
}
// Fonction pour rediriger vers la page d’édition avec l'ID
const editUsers = (id) => {
    router.visit(route("user.edit", id));
};

// 🗑️ Suppression avec confirmation
const deleteUsers = (id) => {
    Swal.fire({
        title: "Êtes-vous sûr ?",
        text: "Cette action est irréversible !",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Oui, supprimer !",
        cancelButtonText: "Annuler",
    }).then((result) => {
        if (result.isConfirmed) {
            router.delete(route("user.destroy", { user: id }), {
                onSuccess: () => {
                    Swal.fire(
                        "Supprimé !",
                        "Le Colis a été supprimé avec succès.",
                        "success"
                    );
                },
            });
        }
    });
};

const getRoleClass = (role) => {
    const rolesMap = {
        admin: "admin",
        administrateur: "admin",
        manager: "manager",
        gestionnaire: "manager",
        user: "user",
        utilisateur: "user",
    };
    return rolesMap[role.toLowerCase()] || "user";
};

const sortBy = (column) => {
    if (!tableWrapper.value) return;
    // Logique de tri sécurisée
    console.log("Trier par:", column);
};
</script>

<template>
    <AppLayout>
        <!-- En-tête de page -->
        <div class="users-header">
            <div class="header-content">
                <div class="header-title-wrapper">
                    <h1 class="page-title">Gestion des Utilisateurs</h1>
                    <Link :href="route('user.create')" class="btn-create-user">
                        <i class="fas fa-user-plus"></i> Nouvel Utilisateur
                    </Link>
                </div>
                <div class="breadcrumb-wrapper">
                    <nav class="breadcrumb">
                        <Link
                            :href="route('dashboard')"
                            class="breadcrumb-item"
                        >
                            <i class="fas fa-home"></i> Tableau de bord
                        </Link>
                        <span class="breadcrumb-divider">/</span>
                        <span class="breadcrumb-item active">
                            <i class="fas fa-users"></i> Utilisateurs
                        </span>
                    </nav>
                    <div class="search-box">
                        <input
                            type="text"
                            v-model="filters.search"
                            placeholder="Rechercher un utilisateur..."
                            class="search-input"
                            @keyup.enter="getResults"
                        />
                        <button class="search-btn" @click="getResults">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Contenu principal -->
        <div class="users-container">
            <!-- Carte principale -->
            <div class="users-card">
                <!-- En-tête du tableau -->
                <div class="table-header">
                    <div class="table-title">
                        <i class="fas fa-list"></i>
                        <h2>Liste des Utilisateurs</h2>
                        <span class="badge-count"
                            >{{ users.total }} utilisateur(s)</span
                        >
                    </div>
                    <div class="table-actions">
                        <button class="btn-export">
                            <i class="fas fa-file-export"></i> Exporter
                        </button>
                    </div>
                </div>

                <!-- Tableau -->
                <div class="table-responsive">
                    <div ref="tableWrapper" class="table-responsive">
                        <table class="users-table">
                            <thead>
                                <tr>
                                    <th class="column-id">#</th>
                                    <th class="column-name">
                                        <span>Nom</span>
                                        <button
                                            class="sort-btn"
                                            @click="sortBy('name')"
                                        >
                                            <i class="fas fa-sort"></i>
                                        </button>
                                    </th>
                                    <th class="column-email">Email</th>
                                    <th class="column-roles">Rôles</th>
                                    <th class="column-status">Statut</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(user, index) in users.data"
                                    :key="user.id"
                                >
                                    <td class="column-id">
                                        {{ users.from + index }}
                                    </td>
                                    <td class="column-name">
                                        <div class="user-avatar">
                                            <img
                                                src="/resources/js/assets/images/user-icon.png"
                                                alt="User"
                                                class="avatar-img"
                                            />
                                            <span>{{ user.name }}</span>
                                        </div>
                                    </td>
                                    <td class="column-email">
                                        <a :href="'mailto:' + user.email">{{
                                            user.email
                                        }}</a>
                                    </td>
                                    <td class="column-roles">
                                        <div class="roles-tags">
                                            <span
                                                v-for="role in user.roles"
                                                :key="role"
                                                class="role-tag"
                                                :class="getRoleClass(role)"
                                            >
                                                {{ role }}
                                            </span>
                                        </div>
                                    </td>
                                    <td class="column-status">
                                        <span class="status-badge active"
                                            >Actif</span
                                        >
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button
                                                @click="editUsers(user.id)"
                                                class="btn-action btn-edit"
                                            >
                                                <Pencil size="16" />
                                            </button>
                                            <button
                                                @click="deleteUsers(user.id)"
                                                class="btn-action btn-delete"
                                            >
                                                <Trash size="16" />
                                            </button>
                                            <button
                                                @click="viewUser(user.id)"
                                                class="btn-action btn-view"
                                            >
                                                <Eye size="16" />
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr v-if="users.data.length === 0">
                                    <td
                                        colspan="8"
                                        class="text-center py-4 text-muted"
                                    >
                                        Aucun utilisateur trouvé
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 📄 Pagination -->
                <div class="table-footer">
                    <div class="pagination-info">
                        <p class="text-muted">
                            Affichage de {{ users.from }} à {{ users.to }} sur
                            {{ users.total }} utilisateurs
                        </p>
                    </div>

                    <div class="pagination-controls">
                        <nav class="float-end">
                            <ul class="pagination">
                                <li
                                    v-for="link in users.links"
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
                <!-- Fin Pagination -->
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
/* Style général */
.users-header {
    background-color: #f8f9fa;
    padding: 1.5rem 2rem;
    border-bottom: 1px solid #e1e5eb;
    margin-bottom: 1.5rem;
}

.header-content {
    max-width: 1400px;
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

.users-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 1.5rem;
}

/* Carte principale */
.users-card {
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    border: 1px solid #e1e5eb;
    overflow: hidden;
    margin-bottom: 2rem;
}

/* En-tête du tableau */
.table-header {
    padding: 1.25rem 1.5rem;
    border-bottom: 1px solid #f0f0f0;
    background-color: #f9fafb;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 1rem;
}

.table-title {
    display: flex;
    align-items: center;
    gap: 1rem;
}

.table-title h2 {
    font-size: 1.2rem;
    font-weight: 600;
    color: #2c3e50;
    margin: 0;
}

.table-title i {
    color: #4a6cf7;
    font-size: 1.2em;
}

.badge-count {
    background-color: #e9ecef;
    color: #495057;
    padding: 0.25rem 0.75rem;
    border-radius: 50px;
    font-size: 0.85rem;
    font-weight: 500;
}

.table-actions {
    display: flex;
    gap: 0.75rem;
}

/* Boutons */
.btn-create-user {
    background-color: #4a6cf7;
    border: none;
    color: white;
    padding: 0.5rem 1.25rem;
    border-radius: 6px;
    font-size: 0.95rem;
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.btn-create-user:hover {
    background-color: #3a5ce4;
    transform: translateY(-1px);
}

.btn-export {
    background-color: white;
    border: 1px solid #e1e5eb;
    color: #495057;
    padding: 0.4rem 1rem;
    border-radius: 6px;
    font-size: 0.9rem;
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.btn-export:hover {
    background-color: #f8f9fa;
    border-color: #dae0e5;
}

/* Barre de recherche */
.search-box {
    position: relative;
    min-width: 250px;
}

.search-input {
    width: 100%;
    padding: 0.5rem 1rem 0.5rem 2.5rem;
    border: 1px solid #e1e5eb;
    border-radius: 6px;
    font-size: 0.9rem;
    transition: all 0.2s;
}

.search-input:focus {
    border-color: #4a6cf7;
    box-shadow: 0 0 0 0.2rem rgba(74, 108, 247, 0.25);
    outline: none;
}

.search-btn {
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 2.5rem;
    background: transparent;
    border: none;
    color: #6c757d;
    cursor: pointer;
}

/* Tableau */
.users-table {
    width: 100%;
    border-collapse: collapse;
}

.users-table thead {
    background-color: #f8f9fa;
}

.users-table th {
    padding: 1rem 1.25rem;
    text-align: left;
    font-weight: 600;
    color: #495057;
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    border-bottom: 1px solid #e1e5eb;
}

.users-table td {
    padding: 1rem 1.25rem;
    border-bottom: 1px solid #f0f0f0;
    vertical-align: middle;
}

.users-table tr:last-child td {
    border-bottom: none;
}

.users-table tr:hover td {
    background-color: #f9fafb;
}

/* Colonnes spécifiques */
.column-id {
    width: 60px;
    color: #6c757d;
    font-weight: 500;
}

.column-name {
    font-weight: 500;
}

.user-avatar {
    display: flex;
    align-items: center;
    gap: 0.75rem;
}

.avatar-img {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid #e9ecef;
}

.column-email a {
    color: #4a6cf7;
    text-decoration: none;
}

.column-email a:hover {
    text-decoration: underline;
}

.roles-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
}

.role-tag {
    padding: 0.25rem 0.75rem;
    border-radius: 4px;
    font-size: 0.8rem;
    font-weight: 500;
}

.role-tag.admin {
    background-color: #f8f0ff;
    color: #8a2be2;
    border-left: 3px solid #8a2be2;
}

.role-tag.manager {
    background-color: #e6f7ff;
    color: #1890ff;
    border-left: 3px solid #1890ff;
}

.role-tag.user {
    background-color: #f6ffed;
    color: #52c41a;
    border-left: 3px solid #52c41a;
}

.status-badge {
    padding: 0.25rem 0.75rem;
    border-radius: 50px;
    font-size: 0.8rem;
    font-weight: 500;
}

.status-badge.active {
    background-color: #e6f7ff;
    color: #1890ff;
}

.status-badge.inactive {
    background-color: #fff2f0;
    color: #ff4d4f;
}

/* Boutons d'action */
.action-buttons {
    display: flex;
    gap: 0.5rem;
}

.btn-action {
    width: 32px;
    height: 32px;
    border-radius: 6px;
    border: none;
    background-color: transparent;
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
}

.btn-action:hover {
    transform: scale(1.1);
}

.btn-edit {
    color: #faad14;
    background-color: rgba(250, 173, 20, 0.1);
}

.btn-edit:hover {
    background-color: rgba(250, 173, 20, 0.2);
}

.btn-delete {
    color: #ff4d4f;
    background-color: rgba(255, 77, 79, 0.1);
}

.btn-delete:hover {
    background-color: rgba(255, 77, 79, 0.2);
}

.btn-view {
    color: #4a6cf7;
    background-color: rgba(74, 108, 247, 0.1);
}

.btn-view:hover {
    background-color: rgba(74, 108, 247, 0.2);
}

/* Message aucun résultat */
.no-results {
    text-align: center;
    padding: 3rem;
    color: #6c757d;
    font-size: 1rem;
}

.no-results i {
    font-size: 1.5rem;
    margin-bottom: 0.5rem;
    display: block;
    color: #adb5bd;
}

/* Pied de tableau */
.table-footer {
    padding: 1.25rem 1.5rem;
    border-top: 1px solid #f0f0f0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 1rem;
}

.pagination-info {
    font-size: 0.9rem;
    color: #6c757d;
}

.pagination-controls {
    display: flex;
    gap: 0.5rem;
}

.pagination-link {
    padding: 0.5rem 0.75rem;
    border-radius: 4px;
    border: 1px solid #e1e5eb;
    color: #495057;
    text-decoration: none;
    font-size: 0.9rem;
    min-width: 36px;
    text-align: center;
    transition: all 0.2s;
}

.pagination-link:hover:not(.active):not(.disabled) {
    background-color: #f8f9fa;
    border-color: #dae0e5;
}

.pagination-link.active {
    background-color: #4a6cf7;
    border-color: #4a6cf7;
    color: white;
}

.pagination-link.disabled {
    color: #adb5bd;
    cursor: not-allowed;
    opacity: 0.7;
}

.pagination-link.prev-next {
    font-weight: bold;
}

/* Tri */
.sort-btn {
    background: none;
    border: none;
    color: #adb5bd;
    cursor: pointer;
    margin-left: 0.25rem;
    transition: all 0.2s;
}

.sort-btn:hover {
    color: #4a6cf7;
}

/* Responsive */
@media (max-width: 768px) {
    .header-title-wrapper {
        flex-direction: column;
        align-items: flex-start;
        gap: 1rem;
    }

    .table-header {
        flex-direction: column;
        align-items: flex-start;
    }

    .table-footer {
        flex-direction: column;
    }

    .users-table {
        display: block;
        overflow-x: auto;
    }
}
</style>
