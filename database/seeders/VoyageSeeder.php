<?php

namespace Database\Seeders;

use App\Models\Voyage;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class VoyageSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        Voyage::create([
            'ligne_id' => 1,
            'train_id' => 1,
            'numero_voyage' => 'VOY-950-000001',
            'gare_depart_id' => 1,
            'gare_arrivee_id' => 2,
            'date_depart' => now(),
            'date_arrivee' => now(),
            'nom' => 'Bamako-Kayes Express',
            'statut' => 'programme',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        Voyage::create([
            'ligne_id' => 1,
            'train_id' => 1,
            'numero_voyage' => 'VOY-950-000002',
            'gare_depart_id' => 2,
            'gare_arrivee_id' => 3,
            'date_depart' => now(),
            'date_arrivee' => now(),
            'nom' => 'Bamako-Kita Express',
            'statut' => 'programme',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        Voyage::create([
            'ligne_id' => 2,
            'train_id' => 2,
            'numero_voyage' => 'VOY-950-000003',
            'gare_depart_id' => 1,
            'gare_arrivee_id' => 2,
            'date_depart' => now(),
            'date_arrivee' => now(),
            'nom' => 'Kayes-Bamako Express',
            'statut' => 'programme',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        Voyage::create([
            'ligne_id' => 2,
            'train_id' => 2,
            'numero_voyage' => 'VOY-950-000004',
            'gare_depart_id' => 2,
            'gare_arrivee_id' => 1,
            'date_depart' => now(),
            'date_arrivee' => now(),
            'nom' => 'Kayes-Kita Express',
            'statut' => 'programme',
            'created_at' => now(),
            'updated_at' => now()
        ]);
    }
}
