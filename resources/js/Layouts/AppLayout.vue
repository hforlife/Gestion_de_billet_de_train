<script setup>
import { Link } from "@inertiajs/vue3";
import { computed, onMounted, ref, watch } from "vue";
import { usePage } from "@inertiajs/vue3";
import { Plus } from "lucide-vue-next";

const page = usePage();
const user = computed(() => page.props.auth.user);
const sidebarActive = ref(false);
const userDropdownOpen = ref(false);

const userRoles = computed(() => {
    if (Array.isArray(page.props.auth?.user?.roles)) {
        return page.props.auth.user.roles;
    } else if (page.props.auth?.user?.roles?.every((role) => role?.name)) {
        return page.props.auth.user.roles.map((role) => role.name);
    }
    return [];
});

const hasAdminAccess = computed(() => userRoles.value.includes("admin"));
const hasChefAccess = computed(() => userRoles.value.includes("chef"));
const hasCaissierAccess = computed(() => userRoles.value.includes("caissier"));
const hasAdminOrChefAccess = computed(
    () => hasAdminAccess.value || hasChefAccess.value
);
const hasAdminOrChefOrCaissierAccess = computed(
    () => hasAdminAccess.value || hasChefAccess.value || hasCaissierAccess.value
);

const toggleSidebar = () => {
    sidebarActive.value = !sidebarActive.value;
};

const toggleUserDropdown = () => {
    userDropdownOpen.value = !userDropdownOpen.value;
};

const closeAllDropdowns = () => {
    userDropdownOpen.value = false;
};

onMounted(() => {
    document.addEventListener("click", (e) => {
        if (!e.target.closest(".user-dropdown")) {
            userDropdownOpen.value = false;
        }
    });

    const currentPath = window.location.pathname.split("/").pop();
    document.querySelectorAll("#sidebar .nav-link").forEach((link) => {
        const href = link.getAttribute("href") || "";
        if (href.includes(currentPath)) {
            link.classList.add("active");
            link.closest(".nav-item")?.classList.add("active");
        }
    });
});
</script>

<template>
    <transition name="fade">
        <div class="container-scroller" @click="closeAllDropdowns">
            <!-- Navbar -->
            <nav
                class="navbar default-layout col-lg-12 col-12 p-0 fixed-top d-flex flex-row animate-navbar"
            >
                <!-- Logo & Mini Logo -->
                <div
                    class="text-center navbar-brand-wrapper d-flex align-items-top justify-content-center"
                >
                    <Link
                        class="navbar-brand brand-logo"
                        :href="route('dashboard')"
                    >
                        <img
                            src="/resources/js/assets/images/icon_white.png"
                            alt="logo"
                        />
                    </Link>
                    <Link
                        class="navbar-brand brand-logo-mini"
                        :href="route('dashboard')"
                    >
                        <img
                            src="/resources/js/assets/images/icon.png"
                            alt="logo"
                            style="width: 50px; height: 50px"
                            class="rounded-circle"
                        />
                    </Link>
                </div>

                <div class="navbar-menu-wrapper d-flex align-items-center">
                    <Link
                        :href="route('create')"
                        class="btn btn-primary btn-icon-text animate-fade"
                    >
                        Effectuer une Vente
                    </Link>

                    <ul class="navbar-nav ml-auto">
                        <!-- Paramètres -->
                        <li class="nav-item">
                            <div>
                                <Link
                                    class="btn btn-primary text-white animate-fade"
                                    :href="route('setting.index')"
                                >
                                    <i class="mdi mdi-cogs mr-2"></i> <!--Paramètres-->
                                </Link>
                            </div>
                        </li>

                        <!-- Profil Utilisateur -->
                        <li
                            class="nav-item dropdown d-none d-xl-inline-block user-dropdown animate-fade"
                            @click.stop
                        >
                            <a
                                class="nav-link dropdown-toggle"
                                id="UserDropdown"
                                href="#"
                                @click="toggleUserDropdown"
                            >
                                <img
                                    class="img-xs rounded-circle"
                                    src="/resources/js/assets/images/user-icon.png"
                                    alt="Profile image"
                                />
                            </a>
                            <transition name="fade">
                                <div
                                    class="dropdown-menu dropdown-menu-right navbar-dropdown"
                                    :class="{ show: userDropdownOpen }"
                                    aria-labelledby="UserDropdown"
                                >
                                    <div class="dropdown-header text-center">
                                        <center>
                                            <img
                                                class="img-md rounded-circle"
                                                src="/resources/js/assets/images/user-icon.png"
                                                alt="Profile image"
                                            />
                                        </center>
                                        <p
                                            class="mb-1 mt-3 font-weight-semibold"
                                        >
                                            {{ user.name }}
                                        </p>
                                        <p
                                            class="font-weight-light text-muted mb-0"
                                        >
                                            {{ user.email }}
                                        </p>
                                    </div>
                                    <Link
                                        class="dropdown-item"
                                        :href="route('user.profile')"
                                    >
                                        <i
                                            class="dropdown-item-icon ti-dashboard"
                                        ></i>
                                        Mon Profil
                                    </Link>
                                    <Link
                                        as="button"
                                        method="post"
                                        :href="route('logout')"
                                        class="dropdown-item"
                                    >
                                        <i
                                            class="dropdown-item-icon ti-power-off"
                                        ></i>
                                        Déconnexion
                                    </Link>
                                </div>
                            </transition>
                        </li>
                    </ul>

                    <button
                        class="navbar-toggler navbar-toggler-right d-lg-none align-self-center"
                        type="button"
                        @click="toggleSidebar"
                    >
                        <span class="mdi mdi-menu"></span>
                    </button>
                </div>
            </nav>

            <!-- Sidebar & Main Content -->
            <div class="container-fluid page-body-wrapper">
                <transition name="slide">
                    <nav
                        class="sidebar sidebar-offcanvas"
                        :class="{ active: sidebarActive }"
                        id="sidebar"
                    >
                        <ul class="nav">
                            <li class="nav-item nav-profile animate-fade">
                                <a href="#" class="nav-link">
                                    <div class="profile-image">
                                        <img
                                            class="img-xs rounded-circle"
                                            src="/resources/js/assets/images/user-icon.png"
                                            alt="profile image"
                                        />
                                        <div
                                            class="dot-indicator bg-success"
                                        ></div>
                                    </div>
                                    <div class="text-wrapper">
                                        <p class="profile-name">
                                            {{ user.name }}
                                        </p>
                                        <p class="designation">
                                            {{
                                                user.roles?.join(", ") ||
                                                "Utilisateur"
                                            }}
                                        </p>
                                    </div>
                                </a>
                            </li>
                            <li class="nav-item nav-category">
                                Menu Principal
                            </li>

                            <!-- Dashboard -->
                            <li class="nav-item">
                                <Link
                                    class="nav-link"
                                    :href="route('dashboard')"
                                    :class="{
                                        active: $page.url === '/dashboard',
                                    }"
                                >
                                    <i
                                        class="menu-icon typcn typcn-document-text"
                                    ></i>
                                    <span class="menu-title"
                                        >Tableau de Bord</span
                                    >
                                </Link>
                            </li>

                            <!-- Ventes/Points de Ventes -->
                            <li class="nav-item">
                                <a
                                    class="nav-link"
                                    data-toggle="collapse"
                                    href="#ui-basical"
                                    aria-expanded="false"
                                    aria-controls="ui-basical"
                                >
                                    <i class="menu-icon typcn typcn-coffee"></i>
                                    <span class="menu-title"
                                        >Gestion des Ventes</span
                                    >
                                    <i class="menu-arrow"></i>
                                </a>
                                <div class="collapse" id="ui-basical">
                                    <ul class="nav flex-column sub-menu">
                                        <!-- Ventes -->
                                        <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :href="route('vente.index')"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/vente'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-document-text"
                                                ></i>
                                                <span class="menu-title"
                                                    >Gestion des Ventes</span
                                                >
                                            </Link>
                                        </li>
                                        <!-- Points Ventes -->
                                        <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :href="
                                                    route('points-vente.index')
                                                "
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/points-vente'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-document-text"
                                                ></i>
                                                <span class="menu-title"
                                                    >Points de Ventes</span
                                                >
                                            </Link>
                                        </li>
                                    </ul>
                                </div>
                            </li>

                            <!-- Gares/Arrets -->
                            <li class="nav-item">
                                <a
                                    class="nav-link"
                                    data-toggle="collapse"
                                    href="#ui-basic"
                                    aria-expanded="false"
                                    aria-controls="ui-basic"
                                >
                                    <i class="menu-icon typcn typcn-coffee"></i>
                                    <span class="menu-title"
                                        >Gestion des Gares</span
                                    >
                                    <i class="menu-arrow"></i>
                                </a>
                                <div class="collapse" id="ui-basic">
                                    <ul class="nav flex-column sub-menu">
                                        <!-- Gares -->
                                        <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :href="route('gare.index')"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/gare'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-user-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Gares</span
                                                >
                                            </Link>
                                        </li>

                                        <!-- Distances Gares -->
                                        <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :href="route('distance.index')"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/distance'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-user-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Distance Gares</span
                                                >
                                            </Link>
                                        </li>

                                        <!-- Types Gare -->
                                        <!-- <li class="nav-item">
                                            <a class="nav-link" href="pages/ui-features/typography.html">Trains</a>
                                            <Link
                                                class="nav-link"
                                                :href="route('type.index')"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/type'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-bell"
                                                ></i>
                                                <span class="menu-title"
                                                    >Types Gare</span
                                                >
                                            </Link>
                                        </li> -->

                                        <!-- Ligne -->
                                        <li class="nav-item">
                                            <!-- <a class="nav-link" href="pages/ui-features/buttons.html">Gares</a> -->
                                            <Link
                                                class="nav-link"
                                                :href="route('ligne.index')"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/ligne'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-user-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Lignes</span
                                                >
                                            </Link>
                                        </li>

                                        <!-- Arrets -->
                                        <li class="nav-item">
                                            <!-- <a class="nav-link" href="pages/ui-features/dropdowns.html">Arrets</a> -->
                                            <Link
                                                class="nav-link"
                                                :href="route('arret.index')"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/arret'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-user-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Arrets</span
                                                >
                                            </Link>
                                        </li>
                                    </ul>
                                </div>
                            </li>

                            <!-- Trains/Wagons -->
                            <li class="nav-item">
                                <a
                                    class="nav-link"
                                    data-toggle="collapse"
                                    href="#ui-base"
                                    aria-expanded="false"
                                    aria-controls="ui-base"
                                >
                                    <i class="menu-icon typcn typcn-coffee"></i>
                                    <span class="menu-title"
                                        >Gestion des Trains</span
                                    >
                                    <i class="menu-arrow"></i>
                                </a>
                                <div class="collapse" id="ui-base">
                                    <ul class="nav flex-column sub-menu">
                                        <!-- Trains -->
                                        <li class="nav-item">
                                            <!-- <a class="nav-link" href="pages/ui-features/typography.html">Trains</a> -->
                                            <Link
                                                class="nav-link"
                                                :href="route('train.index')"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/train'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-bell"
                                                ></i>
                                                <span class="menu-title"
                                                    >Trains</span
                                                >
                                            </Link>
                                        </li>

                                        <!-- Classes Wagons -->
                                        <!-- <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :href="route('classe.index')"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/classe'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-th-large-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Classes Wagon</span
                                                >
                                            </Link>
                                        </li> -->

                                        <!-- Wagons -->
                                        <li class="nav-item">
                                            <!-- <a class="nav-link" href="pages/ui-features/typography.html">Trains</a> -->
                                            <Link
                                                class="nav-link"
                                                :href="route('wagon.index')"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/wagon'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-bell"
                                                ></i>
                                                <span class="menu-title"
                                                    >Wagons</span
                                                >
                                            </Link>
                                        </li>

                                        <!-- Maintenance -->
                                        <!-- <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :href="route('maintenance.index')"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/maintenance'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-bell"
                                                ></i>
                                                <span class="menu-title"
                                                    >Maintenance</span
                                                >
                                            </Link>
                                        </li> -->
                                    </ul>
                                </div>
                            </li>

                            <!-- Gestion des Colis -->
                            <li class="nav-item">
                                <a
                                    class="nav-link"
                                    data-toggle="collapse"
                                    href="#ui-classic"
                                    aria-expanded="false"
                                    aria-controls="ui-classic"
                                >
                                    <i class="menu-icon typcn typcn-coffee"></i>
                                    <span class="menu-title"
                                        >Gestion des Colis</span
                                    >
                                    <i class="menu-arrow"></i>
                                </a>
                                <div class="collapse" id="ui-classic">
                                    <ul class="nav flex-column sub-menu">
                                        <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :href="
                                                    route(
                                                        'categories-colis.index'
                                                    )
                                                "
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/categories-colis'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-th-large-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Catégories de Colis</span
                                                >
                                            </Link>
                                        </li>
                                        <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :href="route('colis.index')"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/colis'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-th-large-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Colis</span
                                                >
                                            </Link>
                                        </li>
                                    </ul>
                                </div>
                            </li>

                            <!-- Voyages -->
                            <li class="nav-item">
                                <a
                                    class="nav-link"
                                    data-toggle="collapse"
                                    href="#ui-zeta"
                                    aria-expanded="false"
                                    aria-controls="ui-zeta"
                                >
                                    <i class="menu-icon typcn typcn-coffee"></i>
                                    <span class="menu-title"
                                        >Gestion des Voyages</span
                                    >
                                    <i class="menu-arrow"></i>
                                </a>
                                <div class="collapse" id="ui-zeta">
                                    <ul class="nav flex-column sub-menu">
                                        <!-- Voyages Classique -->
                                        <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :href="route('voyage.index')"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/voyage'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-th-large-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Voyages</span
                                                >
                                            </Link>
                                        </li>

                                        <!-- Voyages Recurrent  -->
                                        <!-- <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :href="
                                                    route(
                                                        'voyage-reccurent.index'
                                                    )
                                                "
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/voyage-reccurent'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-th-large-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Voyages Récurrents</span
                                                >
                                            </Link>
                                        </li> -->

                                        <!-- Tarifs -->
                                        <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :href="
                                                    route(
                                                        'tarif.index'
                                                    )
                                                "
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/tarif'
                                                    ),
                                                }"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-th-large-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Tarifs de Voyages</span
                                                >
                                            </Link>
                                        </li>
                                    </ul>
                                </div>
                            </li>

                            <!-- Administration -->
                            <li class="nav-item">
                                <a
                                    class="nav-link"
                                    data-toggle="collapse"
                                    href="#ui-zet"
                                    aria-expanded="false"
                                    aria-controls="ui-zet"
                                >
                                    <i class="menu-icon typcn typcn-coffee"></i>
                                    <span class="menu-title"
                                        >Administration</span
                                    >
                                    <i class="menu-arrow"></i>
                                </a>
                                <div class="collapse" id="ui-zet">
                                    <ul class="nav flex-column sub-menu">
                                        <!-- Utilisateurs -->
                                        <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/user'
                                                    ),
                                                }"
                                                :href="route('user.index')"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-user-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Gestion des
                                                    Utilisateurs</span
                                                >
                                            </Link>
                                        </li>

                                        <!-- Rapport -->
                                        <!-- <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/feed'
                                                    ),
                                                }"
                                                :href="route('feed.index')"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-user-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Rapport</span
                                                >
                                            </Link>
                                        </li> -->

                                        <!-- Modes de Paiements -->
                                        <!-- <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/paiement'
                                                    ),
                                                }"
                                                :href="route('paiement.index')"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-user-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Mode de Paiements</span
                                                >
                                            </Link>
                                        </li> -->
                                    </ul>
                                </div>
                            </li>

                            <!-- Paramètres -->
                            <li class="nav-item">
                                <a
                                    class="nav-link"
                                    data-toggle="collapse"
                                    href="#ui-ze"
                                    aria-expanded="false"
                                    aria-controls="ui-ze"
                                >
                                    <i class="menu-icon typcn typcn-coffee"></i>
                                    <span class="menu-title"
                                        >Paramètres</span
                                    >
                                    <i class="menu-arrow"></i>
                                </a>
                                <div class="collapse" id="ui-ze">
                                    <ul class="nav flex-column sub-menu">
                                        <!-- Rôles -->
                                        <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/role'
                                                    ),
                                                }"
                                                :href="route('role.index')"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-user-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Rôles & Permissions</span
                                                >
                                            </Link>
                                        </li>

                                        <!-- Rapport -->
                                        <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/setting'
                                                    ),
                                                }"
                                                :href="route('setting.index')"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-user-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Paramètres Systèmes</span
                                                >
                                            </Link>
                                        </li>

                                        <!-- Modes de Paiements -->
                                        <!-- <li class="nav-item">
                                            <Link
                                                class="nav-link"
                                                :class="{
                                                    active: $page.url.startsWith(
                                                        '/paiement'
                                                    ),
                                                }"
                                                :href="route('paiement.index')"
                                            >
                                                <i
                                                    class="menu-icon typcn typcn-user-outline"
                                                ></i>
                                                <span class="menu-title"
                                                    >Mode de Paiements</span
                                                >
                                            </Link>
                                        </li> -->
                                    </ul>
                                </div>
                            </li>

                        </ul>
                    </nav>
                </transition>

                <div class="main-panel">
                    <div class="content-wrapper">
                        <transition name="fade">
                            <div
                                v-if="$page.props.flash.message"
                                class="alert alert-success"
                            >
                                {{ $page.props.flash.message }}
                            </div>
                        </transition>
                        <slot />
                    </div>

                    <footer class="footer">
                        <div class="container-fluid clearfix">
                            <span
                                class="text-muted d-block text-center text-sm-left d-sm-inline-block"
                            >
                                Copyright © DOUCSOFT Technologies
                                {{ new Date().getFullYear() }}
                            </span>
                            <span
                                class="float-none float-sm-right d-block mt-1 mt-sm-0 text-center"
                            >
                                Site
                                <a href="#" target="_blank"
                                    >Doucsoft Technologies</a
                                >
                                par doucsoft.com
                            </span>
                        </div>
                    </footer>
                </div>
            </div>
        </div>
    </transition>
</template>

<style scoped>
.user-dropdown {
    position: relative;
}

.dropdown-menu {
    display: none;
    position: absolute;
    right: 0;
    z-index: 1000;
}

.dropdown-menu.show {
    display: block;
    animation: fadeIn 0.3s ease-in-out;
}

.sidebar-offcanvas {
    transition: transform 0.3s ease-in-out;
}

.sidebar-offcanvas.active {
    transform: translateX(0);
}

.nav-link.active {
    background-color: rgba(75, 73, 172, 0.1);
    border-left: 3px solid var(--primary);
}

.alert {
    padding: 15px;
    margin-bottom: 20px;
    border: 1px solid transparent;
    border-radius: 4px;
    transition: opacity 0.5s ease-in-out;
}

.alert-success {
    color: #3c763d;
    background-color: #dff0d8;
    border-color: #d6e9c6;
}

/* Animations */
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.5s ease;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}

.slide-enter-active,
.slide-leave-active {
    transition: transform 0.3s ease-in-out;
}
.slide-enter-from,
.slide-leave-to {
    transform: translateX(-100%);
}

.animate-fade {
    animation: fadeIn 0.6s ease-in-out;
}

.animate-navbar {
    animation: slideDown 0.4s ease-out;
}

@keyframes fadeIn {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}

@keyframes slideDown {
    from {
        transform: translateY(-20px);
        opacity: 0;
    }
    to {
        transform: translateY(0);
        opacity: 1;
    }
}
</style>
