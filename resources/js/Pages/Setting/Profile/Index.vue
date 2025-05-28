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

        <div class="container">
            <div class="main-body">
                <div class="row gutters-sm">
                    <div class="col-md-4 mb-3">
                        <div class="card">
                            <div class="card-body">
                                <div
                                    class="d-flex flex-column align-items-center text-center"
                                >
                                    <img
                                        src="/resources/js/assets/images/icon.png"
                                        alt="Admin"
                                        class="rounded-circle"
                                        width="150"
                                    />
                                    <div class="mt-3">
                                        <h4>{{ user.name }}</h4>
                                        <p
                                            class="text-secondary mb-1"
                                            v-for="role in user.roles"
                                            :key="role"
                                        >
                                            {{ role }}
                                        </p>
                                        <p class="text-muted font-size-sm">
                                            {{ user.email }}
                                        </p>
                                        <!-- <button class="btn btn-primary mr-1">
                                            Follow
                                        </button>
                                        <button class="btn btn-outline-primary">
                                            Message
                                        </button> -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="card mb-3">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-sm-3">
                                        <h6 class="mb-0">Nom Utilisateur</h6>
                                    </div>
                                    <div class="col-sm-9 text-secondary">
                                        {{ user.name }}
                                    </div>
                                </div>
                                <hr />
                                <div class="row">
                                    <div class="col-sm-3">
                                        <h6 class="mb-0">Email</h6>
                                    </div>
                                    <div class="col-sm-9 text-secondary">
                                        {{ user.email }}
                                    </div>
                                </div>
                                <hr />
                                <div class="row">
                                    <div class="col-sm-3">
                                        <h6 class="mb-0">Rôle</h6>
                                    </div>
                                    <div
                                        class="col-sm-9 text-secondary"
                                        v-for="role in user.roles"
                                        :key="role"
                                    >
                                        {{ role }}
                                    </div>
                                </div>
                                <hr />
                                <div class="row">
                                    <div class="col-sm-12">
                                        <a
                                            class="btn btn-info"
                                            target="__blank"
                                            href="https://www.bootdey.com/snippets/view/profile-edit-data-and-skills"
                                            >Modifier</a
                                        >
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
