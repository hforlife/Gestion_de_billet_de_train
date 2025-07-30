<?php

namespace Database\Seeders;

use App\Models\Train;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class TrainSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        Train::create([
            'numero' => 'N°12',
            'sens' => 'Bamako-Kayes',
            'etat' => 'actif',
            'nombre_agents' => '20',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        Train::create([
            'numero' => 'N°13',
            'sens' => 'Kayes-Bamako',
            'etat' => 'actif',
            'nombre_agents' => '20',
            'created_at' => now(),
            'updated_at' => now()
        ]);
    }
}
