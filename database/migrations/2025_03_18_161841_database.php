<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up() {
            Schema::create('gares', function (Blueprint $table) {
            $table->id();
            $table->string('nom');
            $table->string('adresse');
            $table->timestamps();
        });

        Schema::create('trains', function (Blueprint $table) {
            $table->id();
            $table->string('numero');
            $table->integer('capacite');
            $table->enum('etat', ['actif', 'en_maintenance']);
            $table->timestamps();
        });

        Schema::create('voyages', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->foreignId('train_id')->constrained('trains')->onDelete('cascade');
            $table->foreignId('gare_depart_id')->constrained('gares')->onDelete('cascade');
            $table->foreignId('gare_arrivee_id')->constrained('gares')->onDelete('cascade');
            $table->dateTime('date_depart');
            $table->dateTime('date_arrivee')->nullable();
            $table->decimal('prix', 10, 2);
            $table->enum('statut', ['programmé', 'en_cours', 'terminé', 'annulé']);
            $table->timestamps();
        });
        
        Schema::create('ventes', function (Blueprint $table) {
            $table->id();
            $table->string('client_nom')->nullable();
            $table->foreignId('voyage_id')->constrained('voyages')->onDelete('cascade');
            $table->foreignId('train_id')->constrained('trains')->onDelete('cascade');
            $table->decimal('prix', 8, 2);
            $table->boolean('bagage')->default(false);
            $table->decimal('poids_bagage', 8, 2);
            $table->enum('statut', ['payé', 'annulé', 'réservé'])->default('payé');
            $table->timestamps();
        });

        Schema::create('bagages', function (Blueprint $table) {
            $table->id();
            $table->foreignId('vente_id')->constrained()->onDelete('cascade');
            $table->decimal('poids', 8, 2);
            $table->decimal('tarif', 10, 2);
            $table->string('description')->nullable();
            $table->timestamps();
        });
        
        Schema::create('colis', function (Blueprint $table) {
            $table->id();
            $table->string('user1');
            $table->string('user2');
            $table->decimal('poids', 8, 2);
            $table->decimal('tarif', 10, 2);
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
    }

    public function down() {
        Schema::dropIfExists('rapports');
        Schema::dropIfExists('bagages');
        Schema::dropIfExists('colis');
        Schema::dropIfExists('transactions');
        Schema::dropIfExists('ventes');
        Schema::dropIfExists('voyages');
        Schema::dropIfExists('trains');
        Schema::dropIfExists('gares');
    }
};
