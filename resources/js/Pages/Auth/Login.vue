<script setup>
import { useForm } from "@inertiajs/vue3";
import Swal from "sweetalert2";

const form = useForm({
    login: "",
    password: "",
    remember: false,
});

const submit = () => {
    form.post("/login", {
        onSuccess: () => {
            Swal.fire("Succès", "Bienvenue sur le Tableau de bord.", "success");
        },
        onError: () => {
            Swal.fire("Erreur", "Merci de vérifier les champs du formulaire.", "error");
        },
        onFinish: () =>  form.reset("password"),
    });
};
</script>

<template>
    <div class="container-scroller">
        <div class="container-fluid page-body-wrapper full-page-wrapper">
            <div class="content-wrapper d-flex align-items-center auth auth-bg-1 theme-one">
                <div class="row w-100">
                    <div class="col-lg-4 mx-auto">
                        <div class="p-2 flex">
                            <center>
                                <img  src="/resources/js/assets/images/icon_white.png" class="justify-center" alt="logo" width="400" />
                            </center>
                        </div>
                        <br>
                        <div class="auto-form-wrapper">
                            <form @submit.prevent="submit">
                                <div class="form-group">
<<<<<<< Updated upstream
                                    <label class="label">Nom d'utilisateur / Email</label>
=======
                                    <label class="label">Email ou Nom Utilisateur</label>
>>>>>>> Stashed changes
                                    <div class="input-group">
                                        <input
                                            id="login"
                                            v-model="form.login"
                                            type="text"
                                            name="login"
                                            :message='form.errors.login'
                                            required
                                            autofocus
<<<<<<< Updated upstream
                                            autocomplete="username"
                                            placeholder="Nom d'utilisateur ou Email"
=======
                                            placeholder="email@example.com"
>>>>>>> Stashed changes
                                            class="form-control"
                                        />
                                        <div class="input-group-append">
                                            <span class="input-group-text">
                                                <i
                                                    class="mdi mdi-check-circle-outline"
                                                ></i>
                                            </span>
                                        </div>
                                    </div>
                                    <span v-if="form.errors.login" class="text-red-500">{{ form.errors.login }}</span>
                                </div>

                                <div class="form-group">
                                    <label class="label">Mot de passe</label>
                                    <div class="input-group">
                                        <input
                                            id="password"
                                            v-model="form.password"
                                            type="password"
                                            name="password"
                                            :message='form.errors.password'
                                            required
                                            autocomplete="current-password"
                                            placeholder="Mot de passe"
                                            class="form-control"
                                        />
                                        <div class="input-group-append">
                                            <span class="input-group-text">
                                                <i
                                                    class="mdi mdi-check-circle-outline"
                                                ></i>
                                            </span>
                                        </div>
                                    </div>
                                    <span v-if="form.errors.password" class="text-red-500">{{ form.errors.password }}</span>
                                </div>

                                <div
                                    class="form-group d-flex justify-content-between"
                                >
                                    <div
                                        class="form-check form-check-flat mt-0"
                                    >
                                        <label class="form-check-label">
                                            <input
                                                type="checkbox"
                                                class="form-check-input"
                                                v-model="form.remember"
                                            />
                                            Se souvenir de moi
                                            <i class="input-helper"></i>
                                        </label>
                                    </div>
                                    <a
                                        href="#"
                                        class="text-small forgot-password text-black"
                                        >Mot de passe oublié</a
                                    >
                                </div>

                                <div class="form-group">
                                    <button
                                        type="submit"
                                        :tabindex="4"
                                        :disabled="form.processing"
                                        class="btn btn-primary submit-btn btn-block"
                                    >
                                        {{
                                            form.processing
                                                ? "Connexion en cours..."
                                                : "Connexion"
                                        }}
                                    </button>
                                </div>
                            </form>
                        </div>

                        <p class="footer-text text-center mt-2">
                            © 2024 DoucsoftTechnologies. Tous droits réservés.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
