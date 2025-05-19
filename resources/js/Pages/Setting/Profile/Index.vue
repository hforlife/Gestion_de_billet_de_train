<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { defineProps, reactive, watch } from "vue";
import { router, Link } from "@inertiajs/vue3";
import { Pencil, Trash, Eye } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    user: Object,
});
</script>

<template>
    <AppLayout>
        <div class="row page-title-header">
            <div class="col-12">
                <div class="page-header">
                    <h4 class="page-title">Profil Utilisateur</h4>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="card mt-4">
                <div class="card-body">
                    <h4 class="card-title">Informations Utilisateur</h4>
                    <p><strong>Nom :</strong> {{ user.name }}</p>
                    <p><strong>Email :</strong> {{ user.email }}</p>
                    <p>
                        <strong>Rôles :</strong>
                        <span
                            v-for="role in user.roles"
                            :key="role"
                            class="badge badge-primary mr-1"
                        >
                            {{ role }}
                        </span>
                    </p>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
