<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { router } from '@inertiajs/vue3';
import { Link } from "@inertiajs/vue3";
import { defineProps, computed } from "vue";
import { Pencil, Trash, File } from "lucide-vue-next";
import Swal from "sweetalert2";

const props = defineProps({
    vente: {
        required: true
    }
});

const generateVente = (id) => {
    window.open(route('vente.generate', id), '_blank');
}

const form = computed(() => ({
    client_nom: props.vente.client_nom || 'Non spécifié',
    voyage: props.vente.voyage?.name || `Voyage #${props.vente.voyage_id}`,
    train: props.vente.train?.numero || `Train #${props.vente.train_id}`,
    prix: `${props.vente.prix.toLocaleString()} FCFA`,
    bagage: props.vente.bagage ? 'Oui' : 'Non',
    poids: props.vente.poids_bagage || 0,
    date: new Date(props.vente.created_at).toLocaleDateString('fr-FR', {
        day: '2-digit',
        month: 'long',
        year: 'numeric'
    })
}));

const confirmDelete = () => {
    Swal.fire({
        title: 'Confirmer la suppression',
        text: "Cette action est irréversible !",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Supprimer',
        cancelButtonText: 'Annuler'
    }).then((result) => {
        if (result.isConfirmed) {
            router.delete(route('vente.destroy', { vente: props.vente.id }));
        }
    });
};
</script>

<template>
    <AppLayout>
        <div class="page-header">
            <h4 class="page-title">Vue d'ensemble du Billet de Train</h4>
        </div>

        <div class="card">
            <div class="card-body">
                <!-- Date -->
                <div class="mb-3 row">
                    <label for="staticEmail" class="col-sm-2 col-form-label"
                        >Emis le :</label
                    >
                    <div class="col-sm-10">
                        <input
                            type="text"
                            readonly
                            class="form-control-plaintext"
                            id="staticEmail"
                            v-model="form.date"
                        />
                    </div>
                </div>
                <!-- Nom & Prénom du Client -->
                <div class="mb-3 row">
                    <label for="staticEmail" class="col-sm-2 col-form-label"
                        >Nom du client :</label
                    >
                    <div class="col-sm-10">
                        <input
                            type="text"
                            readonly
                            class="form-control-plaintext"
                            id="staticEmail"
                            v-model="form.client_nom"
                        />
                    </div>
                </div>
                <!-- Voyage -->
                <div class="mb-3 row">
                    <label for="staticEmail" class="col-sm-2 col-form-label"
                        >Itinéraire de Voyage:</label
                    >
                    <div class="col-sm-10">
                        <input
                            type="text"
                            readonly
                            class="form-control-plaintext"
                            id="staticEmail"
                            v-model="form.voyage"
                        />
                    </div>
                </div>
                <!-- Train -->
                <div class="mb-3 row">
                    <label for="staticEmail" class="col-sm-2 col-form-label"
                        >Numéro du Train :</label
                    >
                    <div class="col-sm-10">
                        <input
                            type="text"
                            readonly
                            class="form-control-plaintext"
                            id="staticEmail"
                            v-model="form.train"
                        />
                    </div>
                </div>
                <!-- Prix -->
                <div class="mb-3 row">
                    <label for="staticEmail" class="col-sm-2 col-form-label"
                        >Prix :</label
                    >
                    <div class="col-sm-10">
                        <input
                            type="text"
                            readonly
                            class="form-control-plaintext"
                            id="staticEmail"
                            v-model="form.prix"
                        />
                    </div>
                </div>
                <!-- Bagage -->
                <div class="mb-3 row">
                    <label for="staticEmail" class="col-sm-2 col-form-label"
                        >Bagages :</label
                    >
                    <div class="col-sm-10">
                        <input
                            type="text"
                            readonly
                            class="form-control-plaintext"
                            id="staticEmail"
                            v-model="form.bagage"
                        />
                    </div>
                </div>
                <!-- Poids -->
                <div class="mb-3 row">
                    <label for="staticEmail" class="col-sm-2 col-form-label"
                        >Poids des Bagages (Kg):</label
                    >
                    <div class="col-sm-10" >
                        <input
                            type="number"
                            readonly
                            class="form-control-plaintext"
                            id="staticEmail"
                            v-model="form.poids"
                        />
                    </div>
                </div>
                <!-- Boutton Modifier/Supprimer -->
                <div class="btn-group" role="group">
                <Link :href="route('vente.edit', vente.id )" class="btn btn-warning btn-sm "><Pencil size="16" /></Link>
                <button type="button" class="btn btn-danger btn-sm" @click="confirmDelete"> <Trash size="16" /></button>
                <button @click="generateVente(vente.id)" title="Génerer billet" class="btn btn-success btn-sm" target="_blank"> <File size="16" /></button>
                 </div>

            </div>
        </div>
    </AppLayout>
</template>
