<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { computed } from "vue";

const props = defineProps({
    errors: Object,
    roles: Object,
    permissions: Array,
});

const form = useForm({
    name: props.roles.name || "",
    permissions: props.roles.permissions ? props.roles.permissions.map(p => p.id) : [],
});

// Grouper les permissions par ressource
const groupedPermissions = computed(() => {
    const groups = {};
    props.permissions.forEach(permission => {
        const parts = permission.name.split(" ");
        const resourceName = parts.length > 1 ? parts[1] : "autres";

        if (!groups[resourceName]) {
            groups[resourceName] = {
                name: resourceName,
                permissions: []
            };
        }

        groups[resourceName].permissions.push(permission);
    });

    return groups;
});

// Toutes les permissions
const allPermissions = computed(() => props.permissions || []);

// Sélectionner/désélectionner toutes les permissions
const toggleAllPermissions = () => {
    if (form.permissions.length === allPermissions.value.length) {
        form.permissions = [];
    } else {
        form.permissions = allPermissions.value.map(p => p.id);
    }
};

// Vérifier si toutes les permissions sont sélectionnées
const allSelected = computed(() =>
    form.permissions.length === allPermissions.value.length &&
    allPermissions.value.length > 0
);

// Vérifie si toutes les permissions d’un groupe sont sélectionnées
const allGroupSelected = (permissions) => {
    return permissions.length > 0 &&
        permissions.every(p => form.permissions.includes(p.id));
};

// Sélectionner/désélectionner tout un groupe
const selectAll = (module, event) => {
    const groupIds = module.permissions.map(p => p.id);
    if (event.target.checked) {
        const newPermissions = [...form.permissions];
        groupIds.forEach(id => {
            if (!newPermissions.includes(id)) {
                newPermissions.push(id);
            }
        });
        form.permissions = newPermissions;
    } else {
        form.permissions = form.permissions.filter(id => !groupIds.includes(id));
    }
};

const submit = () => {
    form.put(route("role.update", props.roles.id), {
        onSuccess: () => {
            Swal.fire({
                title: "Succès",
                text: "Rôle modifié avec succès.",
                icon: "success",
                confirmButtonText: "OK",
            });
            form.reset();
        },
        onError: () => {
            Swal.fire({
                title: "Erreur",
                text: "Veuillez corriger les erreurs dans le formulaire.",
                icon: "error",
                confirmButtonText: "OK",
            });
        },
    });
};
</script>

<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="users-header">
            <div class="header-content">
                <div class="header-title-wrapper">
                    <h1 class="page-title">Modifier Rôle</h1>
                </div>
                <div class="breadcrumb-wrapper">
                    <ul class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="#">Administration</a>
                            <span class="breadcrumb-divider">/</span>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="#">Rôles</a>
                            <span class="breadcrumb-divider">/</span>
                        </li>
                        <li class="breadcrumb-item active">Création</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Formulaire -->
        <div class="row flex-grow">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Formulaire de Modification de Rôle</h4>
                        <form @submit.prevent="submit">
                            <!-- Nom -->
                            <div class="form-group mb-4">
                                <label for="name">Nom du rôle</label>
                                <input
                                    type="text"
                                    class="form-control"
                                    id="name"
                                    v-model="form.name"
                                    placeholder="Entrer le nom..."
                                    :class="{ 'is-invalid': form.errors.name }"
                                />
                                <div v-if="form.errors.name" class="invalid-feedback">
                                    {{ form.errors.name }}
                                </div>
                            </div>

                            <!-- Permissions -->
                            <div class="form-group mb-4">
                                <label>Permissions</label>
                                <div v-if="form.errors.permissions" class="text-danger mb-2">
                                    {{ form.errors.permissions }}
                                </div>

                                <!-- Toggle all -->
                                <div class="form-check mb-3">
                                    <input
                                        class="form-check-input"
                                        type="checkbox"
                                        id="select-all"
                                        :checked="allSelected"
                                        @change="toggleAllPermissions"
                                    />
                                    <label class="form-check-label fw-bold" for="select-all">
                                        Tout sélectionner
                                    </label>
                                </div>

                                <div class="row">
                                    <div
                                        class="col-md-4 mb-3"
                                        v-for="(module, moduleName) in groupedPermissions"
                                        :key="moduleName"
                                    >
                                        <div class="card h-100">
                                            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                                                <h5 class="mb-0 text-capitalize">{{ module.name }}</h5>
                                                <input
                                                    type="checkbox"
                                                    class="form-check-input"
                                                    :checked="allGroupSelected(module.permissions)"
                                                    @change="selectAll(module, $event)"
                                                />
                                            </div>
                                            <div class="card-body">
                                                <div
                                                    class="form-check mb-2"
                                                    v-for="permission in module.permissions"
                                                    :key="permission.id"
                                                >
                                                    <input
                                                        class="form-check-input"
                                                        type="checkbox"
                                                        :id="`permission-${permission.id}`"
                                                        :value="permission.id"
                                                        v-model="form.permissions"
                                                    />
                                                    <label
                                                        class="form-check-label"
                                                        :for="`permission-${permission.id}`"
                                                    >
                                                        {{ permission.name }}
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end mt-4">
                                <button type="reset" class="btn btn-light me-2" @click="form.reset()">Annuler</button>
                                <button type="submit" class="btn btn-primary" :disabled="form.processing">
                                    <span
                                        v-if="form.processing"
                                        class="spinner-border spinner-border-sm"
                                        role="status"
                                        aria-hidden="true"
                                    ></span>
                                    {{ form.processing ? "En cours..." : "Valider" }}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
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
</style>
