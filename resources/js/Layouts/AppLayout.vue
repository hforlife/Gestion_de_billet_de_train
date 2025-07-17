<script setup>
import { Link } from "@inertiajs/vue3";
import { computed, onMounted, ref } from "vue";
import { usePage } from "@inertiajs/vue3";
import { Plus } from "lucide-vue-next";

const page = usePage();
const user = computed(() => page.props.auth.user);
const sidebarActive = ref(false);
const userDropdownOpen = ref(false);

const userRoles = computed(() => {
    // Cas 1: Spatie renvoie un tableau de noms de rôles (format ['admin', 'chef'])
    if (Array.isArray(page.props.auth?.user?.roles)) {
        return page.props.auth.user.roles;
    }
    // Cas 2: Spatie renvoie une collection d'objets (format [{id: 1, name: 'admin'}, ...])
    else if (page.props.auth?.user?.roles?.every((role) => role?.name)) {
        return page.props.auth.user.roles.map((role) => role.name);
    }
    // Cas 3: Aucun rôle trouvé
    return [];
});

// Propriétés calculées pour les accès
const hasAdminAccess = computed(() => userRoles.value.includes("admin"));
const hasChefAccess = computed(() => userRoles.value.includes("chef"));
const hasCaissierAccess = computed(() => userRoles.value.includes("caissier"));
const hasAdminOrChefAccess = computed(
    () => hasAdminAccess.value || hasChefAccess.value
);
const hasAdminOrChefOrCaissierAccess = computed(
    () => hasAdminAccess.value || hasChefAccess.value || hasCaissierAccess.value
);

// Gestion du toggle sidebar
const toggleSidebar = () => {
    sidebarActive.value = !sidebarActive.value;
};

// Gestion du dropdown utilisateur
const toggleUserDropdown = () => {
    userDropdownOpen.value = !userDropdownOpen.value;
};

// Fermer les dropdowns quand on clique ailleurs
const closeAllDropdowns = () => {
    userDropdownOpen.value = false;
};

onMounted(() => {
    // Ajoute un écouteur pour fermer les dropdowns au clic externe
    document.addEventListener("click", (e) => {
        if (!e.target.closest(".user-dropdown")) {
            userDropdownOpen.value = false;
        }
    });

    // Active l'élément de menu correspondant à l'URL
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
    <div class="container-scroller" @click="closeAllDropdowns">
        <!-- Navbar -->
        <nav
            class="navbar default-layout col-lg-12 col-12 p-0 fixed-top d-flex flex-row"
        >
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
                    :href="route('vente.create')"
                    class="btn btn-primary btn-icon-text"
                >
                    Effectuer une Vente
                    <!-- <Plus size="16" class="me-1" /> -->
                </Link>
                <ul class="navbar-nav ml-auto">
                    <!-- Dropdown Utilisateur -->
                    <!-- Paramètre -->
                    <li class="nav-item">
                        <div>
                            <Link
                                class="btn btn-primary text-white"
                                :href="route('setting.index')"
                            >
                                <i class="mdi mdi-cogs mr-2"></i>
                                Paramètres
                            </Link>
                        </div>
                    </li>
                    <!-- Profil -->
                    <li
                        class="nav-item dropdown d-none d-xl-inline-block user-dropdown"
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

                                <p class="mb-1 mt-3 font-weight-semibold">
                                    {{ user.name }}
                                </p>
                                <p class="font-weight-light text-muted mb-0">
                                    {{ user.email }}
                                </p>
                            </div>
                            <Link
                                class="dropdown-item"
                                :href="route('user.profile')"
                            >
                                <i class="dropdown-item-icon ti-dashboard"></i>
                                Mon Profil
                            </Link>
                            <Link
                                as="button"
                                method="post"
                                :href="route('logout')"
                                class="dropdown-item"
                            >
                                <i class="dropdown-item-icon ti-power-off"></i>
                                Déconnexion
                            </Link>
                        </div>
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

        <!-- Sidebar -->
        <div class="container-fluid page-body-wrapper">
            <nav
                class="sidebar sidebar-offcanvas"
                :class="{ active: sidebarActive }"
                id="sidebar"
            >
                <ul class="nav">
                    <li class="nav-item nav-profile">
                        <a href="#" class="nav-link">
                            <div class="profile-image">
                                <img
                                    class="img-xs rounded-circle"
                                    src="/resources/js/assets/images/user-icon.png"
                                    alt="profile image"
                                />
                                <div class="dot-indicator bg-success"></div>
                            </div>
                            <div class="text-wrapper">
                                <p class="profile-name">{{ user.name }}</p>
                                <p class="designation">
                                    {{
                                        user.roles?.join(", ") || "Utilisateur"
                                    }}
                                </p>
                            </div>
                        </a>
                    </li>

                    <li class="nav-item nav-category">Menu Principal</li>

                    <!-- Dashboard -->
                    <li class="nav-item">
                        <Link
                            class="nav-link"
                            :href="route('dashboard')"
                            :class="{ active: $page.url === '/dashboard' }"
                        >
                            <i class="menu-icon typcn typcn-document-text"></i>
                            <span class="menu-title">Tableau de Bord</span>
                        </Link>
                    </li>

                    <!-- Ventes -->
                    <li class="nav-item">
                        <Link
                            class="nav-link"
                            :href="route('vente.index')"
                            :class="{
                                active: $page.url.startsWith('/vente'),
                            }"
                        >
                            <i class="menu-icon typcn typcn-document-text"></i>
                            <span class="menu-title">Gestion des Ventes</span>
                        </Link>
                    </li>

                    <!-- Gares/Arrets/Trains -->
                    <li class="nav-item">
                        <a
                            class="nav-link"
                            data-toggle="collapse"
                            href="#ui-basic"
                            aria-expanded="false"
                            aria-controls="ui-basic"
                        >
                            <i class="menu-icon typcn typcn-coffee"></i>
                            <span class="menu-title">Gestion des Gares</span>
                            <i class="menu-arrow"></i>
                        </a>
                        <div class="collapse" id="ui-basic">
                            <ul class="nav flex-column sub-menu">
                                <!-- Gares -->
                                <li class="nav-item">
                                    <!-- <a class="nav-link" href="pages/ui-features/buttons.html">Gares</a> -->
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
                                        <span class="menu-title">Gares</span>
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
                                        <span class="menu-title">Arrets</span>
                                    </Link>
                                </li>

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
                                        <span class="menu-title">Trains</span>
                                    </Link>
                                </li>

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
                                        <span class="menu-title">Wagons</span>
                                    </Link>
                                </li>
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
                            <span class="menu-title">Gestion des Colis</span>
                            <i class="menu-arrow"></i>
                        </a>
                        <div class="collapse" id="ui-classic">
                            <ul class="nav flex-column sub-menu">
                                <li class="nav-item">
                                    <Link
                                        class="nav-link"
                                        :href="route('categories-colis.index')"
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
                                        <span class="menu-title">Colis</span>
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
                            <span class="menu-title">Gestion des Voyages</span>
                            <i class="menu-arrow"></i>
                        </a>
                        <div class="collapse" id="ui-zeta">
                            <ul class="nav flex-column sub-menu">
                                <li class="nav-item">
                                    <Link
                                        class="nav-link"
                                        :href="route('voyage.index')"
                                        :class="{
                                           active: $page.url.startsWith('/voyage'),
                                        }"
                                    >
                                        <i
                                            class="menu-icon typcn typcn-th-large-outline"
                                        ></i>
                                        <span class="menu-title"
                                            >Voyages Classique</span
                                        >
                                    </Link>
                                </li>
                                <li class="nav-item">
                                    <Link
                                        class="nav-link"
                                        :href="route('voyage-reccurent.index')"
                                        :class="{
                                            active: $page.url.startsWith(
                                                '/voyage-reccurent'
                                            ),
                                        }"
                                    >
                                        <i
                                            class="menu-icon typcn typcn-th-large-outline"
                                        ></i>
                                        <span class="menu-title">Voyages Récurrents</span>
                                    </Link>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <!-- Utilisateurs -->
                    <li class="nav-item">
                        <Link
                            class="nav-link"
                            :class="{
                                active: $page.url.startsWith('/user'),
                            }"
                            :href="route('user.index')"
                        >
                            <i class="menu-icon typcn typcn-user-outline"></i>
                            <span class="menu-title"
                                >Gestion des Utilisateurs</span
                            >
                        </Link>
                    </li>

                    <!-- Rapport -->
                    <li class="nav-item">
                        <Link
                            class="nav-link"
                            :class="{
                                active: $page.url.startsWith('/feed'),
                            }"
                            :href="route('feed.index')"
                        >
                            <i class="menu-icon typcn typcn-user-outline"></i>
                            <span class="menu-title">Rapport</span>
                        </Link>
                    </li>
                </ul>
            </nav>

            <!-- Contenu principal -->
            <div class="main-panel">
                <div class="content-wrapper">
                    <div v-if="$page.props.flash.message" class="alert">
                        {{ $page.props.flash.message }}
                    </div>
                    <slot />
                </div>

                <!-- Footer -->
                <footer class="footer">
                    <div class="container-fluid clearfix">
                        <span
                            class="text-muted d-block text-center text-sm-left d-sm-inline-block"
                        >
                            Copyright © Doucsoft {{ new Date().getFullYear() }}
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
</template>

<style scoped>
/* Style pour les dropdowns */
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
}

/* Animation pour la sidebar */
.sidebar-offcanvas {
    transition: transform 0.3s ease-in-out;
}

.sidebar-offcanvas.active {
    transform: translateX(0);
}

/* Style pour les liens actifs */
.nav-link.active {
    background-color: rgba(75, 73, 172, 0.1);
    border-left: 3px solid var(--primary);
}

/* Style pour les alertes */
.alert {
    padding: 15px;
    margin-bottom: 20px;
    border: 1px solid transparent;
    border-radius: 4px;
}

.alert-success {
    color: #3c763d;
    background-color: #dff0d8;
    border-color: #d6e9c6;
}
</style>
