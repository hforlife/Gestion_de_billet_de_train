<script setup>
import {Link} from '@inertiajs/vue3';
import { router } from '@inertiajs/vue3';
import { computed } from 'vue';
import { usePage } from '@inertiajs/vue3';

const page = usePage();
const user = computed(() => page.props.auth.user);

</script>
<template>
    <div class="container-scroller">
        <!-- partial:partials/_navbar.html -->
        <nav
            class="navbar default-layout col-lg-12 col-12 p-0 fixed-top d-flex flex-row"
        >
            <div
                class="text-center navbar-brand-wrapper d-flex align-items-top justify-content-center"
            >
                <a class="navbar-brand brand-logo" href="/dashboard">
                    <img
                        src="/resources/js/assets/images/icon_white.png"
                        alt="logo"
                    />
                </a>
                <a class="navbar-brand brand-logo-mini" href="/dashboard">
                    <img
                        src="/resources/js/assets/images/icon.png"
                        alt="logo"
                    />
                </a>
            </div>
            <div class="navbar-menu-wrapper d-flex align-items-center">
                <form class="ml-auto search-form d-none d-md-block" action="#">
                    <div class="form-group">
                        <input
                            type="search"
                            class="form-control"
                            placeholder="Chercher Ici..."
                        />
                    </div>
                </form>
                <button
                    class="navbar-toggler navbar-toggler-right d-lg-none align-self-center"
                    type="button"
                    data-toggle="offcanvas"
                >
                    <span class="mdi mdi-menu"></span>
                </button>
                <Link
                    as="button"
                    method="post"
                    :href="route('logout')"
                    class="btn btn-primary toolbar-item"
                    >Se Deconnecter</Link
                >
            </div>
        </nav>
        <!-- partial:partials/_sidebar.html -->
        <div class="container-fluid page-body-wrapper">
            <nav class="sidebar sidebar-offcanvas" id="sidebar">
                <ul class="nav">
                    <li class="nav-item nav-profile">
                        <a href="#" class="nav-link">
                            <div class="profile-image">
                                <img
                                    class="img-xs rounded-circle"
                                    src="/resources/js/assets/images/faces/face8.jpg"
                                    alt="profile image"
                                />
                                <div class="dot-indicator bg-success"></div>
                            </div>
                            <!-- Utilisateur Connecté -->
                            <div class="text-wrapper">
                                <p class="profile-name">Username</p>
                                <p class="designation">Role: Admin</p>
                            </div>
                        </a>
                    </li>
                    <!-- Menu -->
                    <li class="nav-item nav-category">Menu Principal</li>
                    <!-- Tableau de Bord/Dashboard -->
                    <li class="nav-item">
                        <Link class="nav-link" :href="route('dashboard')">
                            <i class="menu-icon typcn typcn-document-text"></i>
                            <span class="menu-title">Tableau de Bord</span>
                        </Link>
                    </li>
                    <!-- Gestion des Ventes -->
                    <li class="nav-item">
                        <Link class="nav-link" :href="route('vente.index')">
                            <i class="menu-icon typcn typcn-document-text"></i>
                            <span class="menu-title">Gestion des Ventes</span>
                        </Link>
                    </li>
                    <!-- Gestion des Gares -->
                    <li class="nav-item">
                        <Link class="nav-link" :href="route('gare.index')">
                            <i class="menu-icon typcn typcn-user-outline"></i>
                            <span class="menu-title">Gestion des Gares</span>
                        </Link>
                    </li>
                    <!-- Gestion des Bagages -->
                    <li class="nav-item">
                        <Link class="nav-link" :href="route('bagage.index')">
                            <i class="menu-icon typcn typcn-th-large-outline"></i>
                            <span class="menu-title">Gestion des Bagages</span>
                        </Link>
                    </li>
                    <!-- Gestion des Voyages -->
                    <li class="nav-item">
                        <Link class="nav-link" :href="route('voyage.index')">
                            <i class="menu-icon typcn typcn-bell"></i>
                            <span class="menu-title">Gestion des Voyages</span>
                        </Link>
                    </li>
                    <!-- Gestion des Trains -->
                    <li class="nav-item">
                        <Link class="nav-link" :href="route('train.index')">
                            <i class="menu-icon typcn typcn-bell"></i>
                            <span class="menu-title">Gestion des Trains</span>
                        </Link>
                    </li>
                    <!-- Gestion des Employées -->
                    <li class="nav-item">
                        <Link class="nav-link" :href="route('employee.index')">
                            <i class="menu-icon typcn typcn-user-outline"></i>
                            <span class="menu-title">Gestion du Personnel</span>
                        </Link>
                    </li>
                    <!-- Gestion des Sections -->
                    <li class="nav-item">
                        <Link class="nav-link" :href="route('section.index')">
                            <i class="menu-icon typcn typcn-user-outline"></i>
                            <span class="menu-title">Gestion des Sections</span>
                        </Link>
                    </li>
                    <!-- Rapports -->
                    <!-- <li class="nav-item">
                        <a class="nav-link" :href="route('rapport.index')">
                            <i class="menu-icon typcn typcn-user-outline"></i>
                            <span class="menu-title">Rapports</span>
                        </a>
                    </li> -->
                    <!-- Activités -->
                    <!-- <li class="nav-item">
                        <a class="nav-link" :href="route('activity.index')">
                            <i class="menu-icon typcn typcn-user-outline"></i>
                            <span class="menu-title">Supervision des Activités</span>
                        </a>
                    </li> -->
                    <!-- Gestion des transactions -->
                    <!-- <li class="nav-item">
                        <a class="nav-link" :href="route('pay.index')">
                            <i class="menu-icon typcn typcn-shopping-bag"></i>
                            <span class="menu-title">Gestion des Transactions</span>
                        </a>
                    </li> -->
                </ul>
            </nav>
            <!-- Content -->
                <div class="main-panel">
                    <div class="content-wrapper">
                        <slot />
                    </div>
                    <!-- content-wrapper ends -->
                    <footer class="footer">
                        <div class="container-fluid clearfix">
                            <span
                                class="text-muted d-block text-center text-sm-left d-sm-inline-block"
                                >Copyright © Doucsoft 2025</span
                            >
                            <span
                                class="float-none float-sm-right d-block mt-1 mt-sm-0 text-center"
                            >
                                Site
                                <a href="#" target="_blank"
                                    >Doucsoft Technologies</a
                                >
                                par doucsoft.com</span
                            >
                        </div>
                    </footer>
                    <!-- partial -->
                </div>
            <!-- End Content -->
            <!-- partial:partials/_footer.html -->
        </div>
    </div>
</template>
