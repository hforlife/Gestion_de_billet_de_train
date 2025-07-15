<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        // 1. Tables de base inchangées
        Schema::create('gares', function (Blueprint $table) {
            $table->id();
            $table->string('nom');
            $table->string('adresse');
            $table->timestamps();
        });

        Schema::create('trains', function (Blueprint $table) {
            $table->id();
            $table->string('numero')->unique();
            $table->enum('etat', ['actif', 'en_maintenance'])->default('actif');
            $table->timestamps();
        });

        // 2. Structure modifiée pour les wagons et places
        Schema::create('wagons', function (Blueprint $table) {
            $table->id();
            $table->foreignId('train_id')->constrained('trains')->onDelete('cascade');
            $table->string('nom');
            $table->integer('nombre_places');
            $table->timestamps();
            
            $table->index(['train_id']); // Index pour les performances
        });

        Schema::create('places', function (Blueprint $table) {
            $table->id();
            $table->foreignId('wagon_id')->constrained('wagons')->onDelete('cascade');
            $table->integer('numero');
            $table->timestamps();
            
            // Suppression du champ 'occupee' redondant
            $table->unique(['wagon_id', 'numero']); // Contrainte d'unicité
        });

        // 3. Voyages standard (inchangé)
        Schema::create('voyages', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->foreignId('train_id')->constrained('trains')->onDelete('cascade');
            $table->foreignId('gare_depart_id')->constrained('gares')->onDelete('cascade');
            $table->foreignId('gare_arrivee_id')->constrained('gares')->onDelete('cascade');
            $table->dateTime('date_depart');
            $table->dateTime('date_arrivee')->nullable();
            $table->decimal('prix', 10, 2);
            $table->enum('statut', ['programmé', 'en_cours', 'terminé', 'annulé'])->default('programmé');
            $table->timestamps();
            
            $table->index(['train_id', 'date_depart']); // Pour les requêtes fréquentes
        });

        // 4. Ventes - Suppression du train_id redondant
        Schema::create('ventes', function (Blueprint $table) {
            $table->id();
            $table->string('client_nom');
            $table->foreignId('voyage_id')->constrained('voyages')->onDelete('cascade');
            $table->decimal('prix', 8, 2);
            $table->integer('quantite')->default(1);
            $table->boolean('bagage')->default(false);
            $table->decimal('poids_bagage', 8, 2)->nullable();
            $table->foreignId('place_id')->nullable()->constrained('places')->nullOnDelete();
            $table->enum('statut', ['payé', 'réservé'])->default('payé');
            $table->timestamps();
            
            // Index pour les recherches de places occupées
            $table->index(['place_id', 'voyage_id']);
        });

        // 5. Nouvelle structure pour les jours de circulation
        Schema::create('jours_semaine', function (Blueprint $table) {
            $table->id();
            $table->string('nom', 10); // Lundi, Mardi...
            $table->string('code', 10)->unique(); // lundi, mardi...
            $table->timestamps();
        });

        // 6. Voyages récurrents modifiés
        Schema::create('voyage_recurrents', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->foreignId('train_id')->constrained('trains')->onDelete('cascade');
            $table->foreignId('gare_depart_id')->constrained('gares');
            $table->foreignId('gare_arrivee_id')->constrained('gares');
            $table->time('heure_depart');
            $table->decimal('prix', 10, 2);
            $table->string('statut')->default('actif');
            $table->timestamps();
        });

        // Table pivot pour les jours
        Schema::create('voyage_recurrent_jour', function (Blueprint $table) {
            $table->foreignId('voyage_recurrent_id')->constrained()->cascadeOnDelete();
            $table->foreignId('jour_semaine_id')->constrained('jours_semaine')->cascadeOnDelete();
            $table->primary(['voyage_recurrent_id', 'jour_semaine_id']);
        });

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

        Schema::create('rapports', function (Blueprint $table) {
            $table->id();
            $table->foreignId('chef_gare_id')->constrained('users')->onDelete('cascade');
            $table->text('contenu');
            $table->dateTime('date');
            $table->timestamps();
        });

        Schema::create('parametres', function (Blueprint $table) {
            $table->id();
            $table->foreignId('categorie_id')->constrained('categorie_colis')->onDelete('cascade');
            $table->decimal('poids_min', 8, 2);
            $table->decimal('poids_max', 8, 2);
            $table->decimal('prix_par_kg', 10, 2);
            $table->timestamps();
        });
    }

    public function down()
    {
        // Ordre inverse avec les nouvelles tables
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