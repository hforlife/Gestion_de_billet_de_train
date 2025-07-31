<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {

        // Nouvelle structure
        // 5. Gestion commerciale
        Schema::create('modes_paiement', function (Blueprint $table) {
            $table->id();
            $table->enum('type', ['especes', 'banque', 'electronique']);
            $table->timestamps();
        });

        Schema::create('gares', function (Blueprint $table) {
            $table->id();
            $table->string('nom');
            $table->string('adresse');
            $table->enum('type', ['principale', 'passage', 'halte', 'fermee'])->default('principale');
            $table->boolean('internet')->default(false);
            $table->boolean('electricite')->default(false);
            $table->integer('nombre_guichets')->default(0);
            $table->enum('controle_bagage', ['physique', 'electronique', 'aucun'])->default('physique');
            $table->decimal('distance_km', 10, 2)->default(0); // Distance depuis Bamako
            $table->timestamps();
        });

        // 3. Points de vente (selon la liste spécifiée)
        Schema::create('points_ventes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('gare_id')->constrained('gares');
            $table->enum('type', ['gare', 'externe'])->default('gare');
            $table->boolean('actif')->default(true);
            $table->timestamps();
        });


        // 2. Structure des trains
        Schema::create('classes_wagon', function (Blueprint $table) {
            $table->id();
            $table->enum('classe', ['premiere', 'deuxieme']);
            $table->decimal('prix_multiplier', 5, 2)->default(1.0); // Multiplicateur pour le tarif
            $table->timestamps();
        });

        Schema::create('trains', function (Blueprint $table) {
            $table->id();
            $table->string('numero')->unique(); // N°12 Bamako-Kayes, N°13 Kayes-Bamako
            $table->enum('sens', ['Bamako-Kayes', 'Kayes-Bamako'])->nullable();
            $table->enum('etat', ['actif', 'maintenance'])->default('actif');
            $table->integer('nombre_agents')->default(20); // 2 gardes/voiture x 10 voitures
            $table->timestamps();
        });

        Schema::create('wagons', function (Blueprint $table) {
            $table->id();
            $table->foreignId('train_id')->constrained('trains')->onDelete('cascade');
            $table->foreignId('classe_id')->constrained('classes_wagon');
            $table->string('numero_wagon')->unique(); // Format 2020XXX
            $table->integer('nombre_sieges')->default(56);
            $table->integer('sieges_disponibles')->default(54); // 56 - 2 pour agents
            $table->timestamps();
        });


        Schema::create('places', function (Blueprint $table) {
            $table->id();
            $table->foreignId('wagon_id')->constrained('wagons')->onDelete('cascade');
            $table->integer('numero');
            $table->timestamps();

            // Suppression du champ 'occupee' redondant
            $table->unique(['wagon_id', 'numero']); // Contrainte d'unicité
        });

        // 4. Gestion des voyages
        Schema::create('lignes', function (Blueprint $table) {
            $table->id();
            $table->string('nom'); // Bamako-Kayes
            $table->foreignId('gare_depart_id')->constrained('gares');
            $table->foreignId('gare_arrivee_id')->constrained('gares');
            $table->decimal('distance_totale', 10, 2); // 492 km
            $table->timestamps();
        });

        Schema::create('arrets_ligne', function (Blueprint $table) {
            $table->id();
            $table->foreignId('ligne_id')->constrained('lignes')->onDelete('cascade');
            $table->foreignId('gare_id')->constrained('gares');
            $table->integer('ordre');
            $table->decimal('distance_depart', 10, 2); // Distance depuis gare de départ
            $table->boolean('vente_chef_train')->default(false);
            $table->timestamps();

            $table->unique(['ligne_id', 'gare_id']);
        });

        Schema::create('distances_gares', function (Blueprint $table) {
            $table->id();
            $table->foreignId('gare_depart_id')->constrained('gares');
            $table->foreignId('gare_arrivee_id')->constrained('gares');
            $table->integer('distance_km'); // km entre les 2 gares
        });

        // Schema::create('maintenances', function (Blueprint $table) {
        //     $table->id();
        //     $table->foreignId('train_id')->constrained();
        //     $table->dateTime('date_debut');
        //     $table->dateTime('date_fin_prevue');
        //     $table->dateTime('date_fin_reelle')->nullable();
        //     $table->text('description');
        //     $table->enum('statut', ['planifie', 'en_cours', 'termine', 'retard']);
        //     $table->timestamps();
        // });

        Schema::create('voyages', function (Blueprint $table) {
            $table->id();
            $table->string('nom');
            $table->string('numero_voyage')->unique();
            $table->foreignId('train_id')->constrained('trains');
            $table->foreignId('ligne_id')->constrained('lignes');
            $table->dateTime('date_depart');
            $table->dateTime('date_arrivee');
            $table->enum('statut', ['programme', 'en_cours', 'termine', 'annule'])->default('programme');
            $table->timestamps();
        });

        Schema::create('tarifs_gares', function (Blueprint $table) {
            $table->id();
            $table->foreignId('voyage_id')->constrained('voyages')->onDelete('cascade');
            $table->foreignId('classe_wagon_id')->constrained('classes_wagon');
            $table->decimal('prix', 10, 2);
            $table->date('date_effet');
            $table->date('date_expiration')->nullable();
            $table->timestamps();
        });


        Schema::create('tarifs_voyage', function (Blueprint $table) {
            $table->id();
            $table->foreignId('voyage_id')->constrained('voyages');
            $table->foreignId('tarif_gare_id')->constrained('tarifs_gares');
            $table->timestamps();

            $table->unique(['voyage_id', 'tarif_gare_id']);
        });


        // 4. Ventes - Suppression du train_id redondant
        Schema::create('ventes', function (Blueprint $table) {
            $table->id();
            $table->string('client_nom')->nullable();
            $table->foreignId('voyage_id')->constrained('voyages')->onDelete('cascade');
            $table->foreignId('mode_paiement_id')->constrained('modes_paiement');
            $table->foreignId('point_vente_id')->constrained('points_ventes');
            $table->foreignId('classe_wagon_id')->constrained('classes_wagon');
            $table->decimal('prix', 8, 2);
            $table->integer('quantite')->default(1);
            $table->boolean('demi_tarif')->default(false);
            $table->dateTime('date_vente')->default(now());
            $table->boolean('bagage')->default(false);
            $table->decimal('poids_bagage', 8, 2)->nullable();
            $table->boolean('penalite')->default(false);
            $table->foreignId('place_id')->nullable()->constrained('places')->nullOnDelete();
            $table->enum('statut', ['payé', 'réservé'])->default('payé');
            $table->string('reference')->unique()->nullable(); // N°12-2025-03-18-001
            $table->timestamps();

            $table->index(['place_id', 'voyage_id']);
        });


        // 5. Nouvelle structure pour les jours de circulation
        // Schema::create('jours_semaine', function (Blueprint $table) {
        //     $table->id();
        //     $table->string('nom', 10); // Lundi, Mardi...
        //     $table->timestamps();
        // });

        // 6. Voyages récurrents modifiés
        // Schema::create('voyage_recurrents', function (Blueprint $table) {
        //     $table->id();
        //     $table->string('name');
        //     $table->foreignId('train_id')->constrained('trains');
        //     $table->foreignId('ligne_id')->constrained('lignes');
        //     $table->time('heure_depart');
        //     $table->foreignId('tarif_id')->constrained('tarifs_gares');
        //     $table->string('statut')->default('actif');
        //     $table->timestamps();
        // });

        // Table pivot pour les jours
        // Schema::create('voyage_recurrent_jour', function (Blueprint $table) {
        //     $table->foreignId('voyage_recurrent_id')->constrained()->cascadeOnDelete();
        //     $table->foreignId('jour_semaine_id')->constrained('jours_semaine')->cascadeOnDelete();
        //     $table->primary(['voyage_recurrent_id', 'jour_semaine_id']);
        // });

        // 7. Tables annexes inchangées
        Schema::create('bagages', function (Blueprint $table) {
            $table->id();
            $table->foreignId('vente_id')->constrained('ventes')->onDelete('cascade');
            $table->decimal('poids', 8, 2);
            $table->decimal('tarif', 10, 2);
            $table->string('description')->nullable();
            $table->timestamps();
        });

        Schema::create('categorie_colis', function (Blueprint $table) {
            $table->id();
            $table->string('nom')->unique();
            $table->text('description')->nullable();
            $table->timestamps();
        });

        Schema::create('colis', function (Blueprint $table) {
            $table->id();
            $table->string('user1');
            $table->string('user2');
            $table->decimal('poids', 8, 2);
            $table->decimal('tarif', 10, 2);
            $table->foreignId('categorie_colis_id')->constrained('categorie_colis')->onDelete('cascade');
            $table->string('description')->nullable();
            $table->enum('statut', ['enregistré', 'perdu', 'livré']);
            $table->timestamps();
        });

        // Schema::create('rapports', function (Blueprint $table) {
        //     $table->id();
        //     $table->foreignId('chef_gare_id')->constrained('users')->onDelete('cascade');
        //     $table->text('contenu');
        //     $table->dateTime('date');
        //     $table->timestamps();
        // });

        Schema::create('parametres', function (Blueprint $table) {
            $table->id();
            $table->foreignId('categorie_id')->constrained('categorie_colis')->onDelete('cascade');
            $table->decimal('poids_min', 8, 2);
            $table->decimal('poids_max', 8, 2);
            $table->decimal('prix_par_kg', 10, 2);
            $table->timestamps();
        });

        Schema::create('system_settings', function (Blueprint $table) {
            $table->id();
            $table->enum('mode_vente', ['par_voyage', 'par_kilometrage'])->default('par_voyage');
            $table->decimal('tarif_kilometrique', 10, 2)->nullable(); // exemple : 20.32
            $table->decimal('tarif_minimum', 10, 2)->nullable(); // montant minimal d’un billet
            $table->json('coefficients_classes')->nullable(); // ex: {"1": 1.2, "2": 1.0, "3": 0.8}
            $table->timestamps();
        });
    }

    public function down()
    {
        // Ordre inverse avec les nouvelles tables
        Schema::dropIfExists('system_settings');
        Schema::dropIfExists('parametres');
        Schema::dropIfExists('rapports');
        Schema::dropIfExists('colis');
        Schema::dropIfExists('categorie_colis');
        Schema::dropIfExists('bagages');
        Schema::dropIfExists('voyage_recurrent_jour');
        Schema::dropIfExists('voyage_recurrents');
        Schema::dropIfExists('jours_semaine');
        Schema::dropIfExists('ventes');
        Schema::dropIfExists('voyages');
        Schema::dropIfExists('places');
        Schema::dropIfExists('wagons');
        Schema::dropIfExists('trains');
        Schema::dropIfExists('gares');
    }
};
