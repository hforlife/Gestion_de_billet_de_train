<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up() {
            Schema::create('gares', function (Blueprint $table) {
            $table->id();
            $table->string('nom');
            $table->string('localisation');
            $table->timestamps();
        });

        Schema::create('trains', function (Blueprint $table) {
            $table->id();
            $table->string('nom');
            $table->integer('capacite');
            $table->enum('etat', ['actif', 'en_maintenance']);
            $table->timestamps();
        });

        Schema::create('voyages', function (Blueprint $table) {
            $table->id();
            $table->foreignId('train_id')->constrained('trains')->onDelete('cascade');
            $table->foreignId('gare_depart')->constrained('gares')->onDelete('cascade');
            $table->foreignId('gare_arrivee')->constrained('gares')->onDelete('cascade');
            $table->dateTime('date_depart');
            $table->dateTime('date_arrivee')->nullable();
            $table->enum('statut', ['programmé', 'en_cours', 'terminé', 'annulé']);
            $table->timestamps();
        });

        Schema::create('tickets', function (Blueprint $table) {
            $table->id();
            $table->string('numero')->unique();
            $table->foreignId('voyage_id')->constrained('voyages')->onDelete('cascade');
            $table->foreignId('user_id')->nullable()->constrained('users')->onDelete('set null');
            $table->decimal('prix', 10, 2);
            $table->enum('statut', ['valide', 'annulé', 'utilisé']);
            $table->timestamps();
        });

        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('ticket_id')->constrained('tickets')->onDelete('cascade');
            $table->decimal('montant', 10, 2);
            $table->enum('type_paiement', ['cash', 'carte', 'mobile_money']);
            $table->enum('statut', ['en_attente', 'effectué', 'échoué']);
            $table->timestamps();
        });

        Schema::create('bagages', function (Blueprint $table) {
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

        Schema::create('sections', function (Blueprint $table) {
            $table->id();
            $table->String('name');
            $table->text('description');
            $table->timestamps();
        });
    }

    public function down() {
        Schema::dropIfExists('rapports');
        Schema::dropIfExists('bagages');
        Schema::dropIfExists('transactions');
        Schema::dropIfExists('tickets');
        Schema::dropIfExists('voyages');
        Schema::dropIfExists('trains');
        Schema::dropIfExists('gares');
        Schema::dropIfExists('sections');
    }
};
