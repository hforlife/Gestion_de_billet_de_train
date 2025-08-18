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
        // JoursSemaine::create([ournir
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
            'nom' => 'Nafadié',
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
            'nom' => 'Kassaro',
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

        Gare::create([
            'nom' => 'Gare de Sébécoro',
            'adresse' => 'Sébécoro',
            'type' => 'passage',
            'distance_km' => '127',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 1,
            'controle_bagage' => 'physique',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Gare de Badinko',
            'adresse' => 'Badinko',
            'type' => 'passage',
            'distance_km' => '154',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 1,
            'controle_bagage' => 'physique',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Gare de Kita',
            'adresse' => 'Kita',
            'type' => 'passage',
            'distance_km' => '185',
            'electricite' => true,
            'internet' => false,
            'nombre_guichets' => 1,
            'controle_bagage' => 'physique',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Boulouli',
            'adresse' => 'Boulouli  ',
            'type' => 'fermee',
            'distance_km' => '220',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Gare de Toukoto',
            'adresse' => 'Toukoto',
            'type' => 'passage',
            'distance_km' => '254',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 1,
            'controle_bagage' => 'physique',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Fangala',
            'adresse' => 'Fangala',
            'type' => 'fermee',
            'distance_km' => '281',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Badumbé',
            'adresse' => 'Badumbé',
            'type' => 'fermee',
            'distance_km' => '301',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Soukoutaly',
            'adresse' => 'Soukoutaly',
            'type' => 'halte',
            'distance_km' => '311',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
            'created_at' => now(),
            'updated_at' => now()
        ]);

         Gare::create([
            'nom' => 'Gare de Oualia',
            'adresse' => 'Oualia',
            'type' => 'passage',
            'distance_km' => '320',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 1,
            'controle_bagage' => 'physique',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Solinta',
            'adresse' => 'Solinta',
            'type' => 'halte',
            'distance_km' => '329',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Dioubéba',
            'adresse' => 'Dioubéba',
            'type' => 'fermee',
            'distance_km' => '335',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'PK 880',
            'adresse' => 'PK 880',
            'type' => 'halte',
            'distance_km' => '349',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Kalé',
            'adresse' => 'Kalé',
            'type' => 'fermee',
            'distance_km' => '358',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Gare de Mahina',
            'adresse' => 'Mahina',
            'type' => 'passage',
            'distance_km' => '377',
            'electricite' => true,
            'internet' => false,
            'nombre_guichets' => 1,
            'controle_bagage' => 'physique',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Galougo',
            'adresse' => 'Galougo',
            'type' => 'fermee',
            'distance_km' => '405',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Tambacoundafara',
            'adresse' => 'Tambacoundafara',
            'type' => 'halte',
            'distance_km' => '417',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Bagouko',
            'adresse' => 'Bagouko',
            'type' => 'fermee',
            'distance_km' => '432',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Gare de Diamou',
            'adresse' => 'Diamou',
            'type' => 'passage',
            'distance_km' => '445',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 1,
            'controle_bagage' => 'physique',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Dinguira',
            'adresse' => 'Dinguira',
            'type' => 'halte',
            'distance_km' => '456',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Tintiba',
            'adresse' => 'Tintiba',
            'type' => 'fermee',
            'distance_km' => '471',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        Gare::create([
            'nom' => 'Kaffa',
            'adresse' => 'Kaffa',
            'type' => 'halte',
            'distance_km' => '477',
            'electricite' => false,
            'internet' => false,
            'nombre_guichets' => 0,
            'controle_bagage' => 'aucun',
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
    }
}
