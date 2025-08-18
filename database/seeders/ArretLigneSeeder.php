<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\ArretsLigne;
use App\Models\Gare;

class ArretLigneSeeder extends Seeder
{
    public function run(): void
    {
        $arrets = [
            ['nom' => 'Gare de Bamako', 'ordre' => 1, 'distance' => 0, 'chef_train' => false],
            ['nom' => 'Gare de Kati', 'ordre' => 2, 'distance' => 14, 'chef_train' => false],
            ['nom' => 'Gare de Négala', 'ordre' => 3, 'distance' => 61, 'chef_train' => false],
            ['nom' => 'Nafadié', 'ordre' => 4, 'distance' => 98, 'chef_train' => true],
            ['nom' => 'Kassaro', 'ordre' => 5, 'distance' => 113, 'chef_train' => true],
            ['nom' => 'Gare de Sébécoro', 'ordre' => 6, 'distance' => 127, 'chef_train' => true],
            ['nom' => 'Gare de Badinko', 'ordre' => 7, 'distance' => 154, 'chef_train' => false],
            ['nom' => 'Gare de Kita', 'ordre' => 8, 'distance' => 185, 'chef_train' => false],
            ['nom' => 'Boulouli', 'ordre' => 9, 'distance' => 220, 'chef_train' => true],
            ['nom' => 'Gare de Toukoto', 'ordre' => 10, 'distance' => 254, 'chef_train' => false],
            ['nom' => 'Fangala', 'ordre' => 11, 'distance' => 281, 'chef_train' => true],
            ['nom' => 'Badumbé', 'ordre' => 12, 'distance' => 301, 'chef_train' => true],
            ['nom' => 'Soukoutaly', 'ordre' => 13, 'distance' => 311, 'chef_train' => true],
            ['nom' => 'Gare de Oualia', 'ordre' => 14, 'distance' => 320, 'chef_train' => false],
            ['nom' => 'Solinta', 'ordre' => 15, 'distance' => 329, 'chef_train' => true],
            ['nom' => 'Dioubéba', 'ordre' => 16, 'distance' => 335, 'chef_train' => true],
            ['nom' => 'PK 880', 'ordre' => 17, 'distance' => 349, 'chef_train' => true],
            ['nom' => 'Kalé', 'ordre' => 18, 'distance' => 358, 'chef_train' => true],
            ['nom' => 'Gare de Mahina', 'ordre' => 19, 'distance' => 377, 'chef_train' => false],
            ['nom' => 'Galougo', 'ordre' => 20, 'distance' => 405, 'chef_train' => true],
            ['nom' => 'Tambacoundafara', 'ordre' => 21, 'distance' => 417, 'chef_train' => true],
            ['nom' => 'Bagouko', 'ordre' => 22, 'distance' => 432, 'chef_train' => true],
            ['nom' => 'Gare de Diamou', 'ordre' => 23, 'distance' => 445, 'chef_train' => false],
            ['nom' => 'Dinguira', 'ordre' => 24, 'distance' => 456, 'chef_train' => true],
            ['nom' => 'Tintiba', 'ordre' => 25, 'distance' => 471, 'chef_train' => true],
            ['nom' => 'Kaffa', 'ordre' => 26, 'distance' => 477, 'chef_train' => true],
            ['nom' => 'Gare de Kayes', 'ordre' => 27, 'distance' => 492, 'chef_train' => false],
        ];

        foreach ($arrets as $arret) {
            $gare = Gare::where('nom', $arret['nom'])->first();
            if ($gare) {
                // Ligne Bamako → Kayes
                ArretsLigne::create([
                    'ligne_id' => 1,
                    'gare_id' => $gare->id,
                    'ordre' => $arret['ordre'],
                    'distance_depart' => $arret['distance'],
                    'vente_chef_train' => $arret['chef_train'],
                ]);

                // Ligne Kayes → Bamako (ordre inversé)
                ArretsLigne::create([
                    'ligne_id' => 2,
                    'gare_id' => $gare->id,
                    'ordre' => count($arrets) - $arret['ordre'] + 1,
                    'distance_depart' => 492 - $arret['distance'],
                    'vente_chef_train' => $arret['chef_train'],
                ]);
            }
        }
    }
}
