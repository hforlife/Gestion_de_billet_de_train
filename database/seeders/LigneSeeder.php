<?php

namespace Database\Seeders;

use App\Models\Ligne;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class LigneSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Ligne de train
        Ligne::create([
            'nom' => 'Bamako-Kayes',
            'gare_depart_id' => 1,
            'gare_arrivee_id' => 27,
            'distance_totale' => 492, // Exemple de distance en km
            'created_at' => now(),
            'updated_at' => now()
        ]);
        Ligne::create([
            'nom' => 'kayes-Bamako',
            'gare_depart_id' => 27,
            'gare_arrivee_id' => 1,
            'distance_totale' => 492, // Exemple de distance en km
            'created_at' => now(),
            'updated_at' => now()
        ]);
    }
}
