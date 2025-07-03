<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('arrets', function (Blueprint $table) {
            $table->id();
            $table->foreignId('voyage_id')->constrained('voyages')->onDelete('cascade');
            $table->foreignId('gare_id')->constrained('gares')->onDelete('cascade');
            $table->time('heure_arrivee')->nullable();
            $table->time('heure_depart')->nullable();
            $table->integer('ordre'); // ordre de passage
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('arrets');
    }
};
