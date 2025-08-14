<?php

namespace Database\Seeders;

use App\Models\ClassesWagon;
use App\Models\Gare;
use App\Models\JoursSemaine;
use App\Models\ModesPaiement;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class GareSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {

        // Jour de la semaine
        // JoursSemaine::create([
        //     'nom' => 'Lundi',
        //     'created_at' => now(),
        //     'updated_at' => now()
        // ]);
        // JoursSemaine::create([
        //     'nom' => 'Mardi',
        //     'created_at' => now(),
        //     'updated_at' => now()
        // ]);
        // JoursSemaine::create([
        //     'nom' => 'Mercredi',
        //     'created_at' => now(),
        //     'updated_at' => now()
        // ]);
        // JoursSemaine::create([
        //     'nom' => 'Jeudi',
        //     'created_at' => now(),
        //     'updated_at' => now()
        // ]);
        // JoursSemaine::create([
        //     'nom' => 'Vendredi',
        //     'created_at' => now(),
        //     'updated_at' => now()
        // ]);
        // JoursSemaine::create([
        //     'nom' => 'Samedi',
        //     'created_at' => now(),
        //     'updated_at' => now()
        // ]);
        // JoursSemaine::create([
        //     'nom' => 'Dimanche',
        //     'created_at' => now(),
        //     'updated_at' => now()
        // ]);

        // Gares
        Gare::create([
            'nom' => 'Gare de Bamako',
            'adresse' => 'Bamako',
            'type' => 'principale',
            'distance_km' => '0',
            'electricite' => true,
            'internet' => true,
            'nombre_guichets' => 2,
            'controle_bagage' => 'physique',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        Gare::create([
            'nom' => 'Gare de Kayes',
            'adresse' => 'Kayes',
            'type' => 'principale',
            'distance_km' => '492',
            'electricite' => true,
            'internet' => false,
            'nombre_guichets' => 2,
            'controle_bagage' => 'physique',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        Gare::create([
            'nom' => 'Gare de Kati',
            'adresse' => 'Kati',
            'type' => 'passage',
            'distance_km' => '14',
            'electricite' => true,
            'internet' => true,
            'nombre_guichets' => 1,
            'controle_bagage' => 'physique',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        Gare::create([
            'nom' => 'Gare de Négala',
            'adresse' => 'Négala',
            'type' => 'passage',
            'distance_km' => '61',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 1,
            'controle_bagage' => 'physique',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        Gare::create([
            'nom' => 'Gare de Nafadié',
            'adresse' => 'Nafadié',
            'type' => 'fermee',
            'distance_km' => '98',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        Gare::create([
            'nom' => 'Gare de Kassaro',
            'adresse' => 'Kassaro',
            'type' => 'fermee',
            'distance_km' => '113',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
            'created_at' => now(),
            'updated_at' => now()
        ]);
    }
}
