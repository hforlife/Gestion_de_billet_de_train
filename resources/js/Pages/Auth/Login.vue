<script setup>
import { useForm } from "@inertiajs/vue3";
import InputError from "@/components/InputError.vue";
import { LoaderCircle } from "lucide-vue-next";

const form = useForm({
    email: "",
    password: "",
    remember: false,
});

const submit = () => {
    form.post("login", {
        onFinish: () => form.reset("password"),
    });
};
</script>

<template>
    <div class="container-scroller">
        <div class="container-fluid page-body-wrapper full-page-wrapper">
            <div
                class="content-wrapper d-flex align-items-center auth auth-bg-1 theme-one"
            >
                <div class="row w-100">
                    <div class="col-lg-4 mx-auto">
                        <div class="auto-form-wrapper">
                            <div
                                v-if="form.hasErrors"
                                class="alert alert-danger"
                            >
                                {{ form.errors.email }}
                            </div>
                            <form @submit.prevent="submit">
                                <div class="form-group">
                                    <label class="label">Email</label>
                                    <div class="input-group">
                                        <input
                                            id="email"
                                            v-model="form.email"
                                            type="email"
                                            required
                                            autofocus
                                            autocomplete="email"
                                            placeholder="email@example.com"
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
                                    <InputError :message="form.errors.email" />
                                </div>

                                <div class="form-group">
                                    <label class="label">Mot de passe</label>
                                    <div class="input-group">
                                        <input
                                            id="password"
                                            v-model="form.password"
                                            type="password"
                                            required
                                            autocomplete="current-password"
                                            placeholder="Password"
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
                                    <InputError
                                        :message="form.errors.password"
                                    />
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

                        <ul class="auth-footer">
                            <li><a href="/dashboard">Conditions</a></li>
                            <li><a href="#">Aide</a></li>
                            <li><a href="#">Termes & Politique</a></li>
                        </ul>

                        <p class="footer-text text-center">
                            © 2024 DoucsoftTechnologies. Tous droits réservés.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
