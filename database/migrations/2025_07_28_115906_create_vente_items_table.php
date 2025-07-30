<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('vente_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('vente_id')->constrained('ventes')->onDelete('cascade');
            $table->foreignId('tarif_gare_id')->constrained('tarifs_gares')->onDelete('cascade');
            $table->integer('quantite')->default(1);
            $table->decimal('prix_unitaire', 8, 2);
            // $table->decimal('prix_total', 8, 2)->virtualAs('quantite * prix_unitaire');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('vente_items');
    }
};
