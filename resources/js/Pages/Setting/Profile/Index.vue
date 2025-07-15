<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps } from "vue";

const props = defineProps({
    user: Object,
});
</script>

<template>
    <AppLayout>
        <!-- Titre de page -->
        <div class="row page-title-header mb-4">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Profil de {{ user.name }}</h4>
                </div>
            </div>
        </div>

        <!-- Contenu principal -->
        <div class="container">
            <div class="row">
                <!-- 📸 Carte Avatar -->
                <div class="col-md-4 mb-4">
                    <div class="card shadow-sm border-0">
                        <div class="card-body text-center">
                            <center>
                                <img
                                        src="/resources/js/assets/images/user-icon.png"
                                        alt="Admin"
                                        class="rounded-circle"
                                        width="150"
                                    />
                             </center>
                            <h5 class="card-title">{{ user.name }}</h5>
                            <p
                                v-for="role in user.roles"
                                :key="role"
                                class="badge bg-primary mb-1"
                            >
                                {{ role }}
                            </p>
                            <p class="text-muted">{{ user.email }}</p>
                        </div>
                    </div>
                </div>

                <!-- 📄 Infos personnelles -->
                <div class="col-md-8">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-light">
                            <h5 class="mb-0">Informations personnelles</h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3 row">
                                <label class="col-sm-4 col-form-label fw-bold"
                                    >Nom :</label
                                >
                                <div class="col-sm-8">{{ user.name }}</div>
                            </div>
                            <div class="mb-3 row">
                                <label class="col-sm-4 col-form-label fw-bold"
                                    >Email :</label
                                >
                                <div class="col-sm-8">{{ user.email }}</div>
                            </div>
                            <div class="mb-3 row">
                                <label class="col-sm-4 col-form-label fw-bold"
                                    >Rôle(s) :</label
                                >
                                <div class="col-sm-8">
                                    <span
                                        v-for="role in user.roles"
                                        :key="role"
                                        class="badge bg-secondary me-2"
                                    >
                                        {{ role }}
                                    </span>
                                </div>
                            </div>

                            <!-- Bouton Modifier -->
                            <div class="text-end">
                                <a
                                    class="btn btn-outline-primary"
                                    href="#"
                                >
                                    <i class="mdi mdi-account-edit-outline me-1"></i>
                                    Modifier mon profil
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
