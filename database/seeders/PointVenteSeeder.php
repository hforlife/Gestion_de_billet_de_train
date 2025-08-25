<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\PointsVente;
use App\Models\Gare;

class PointVenteSeeder extends Seeder
{
    public function run(): void
    {
        $garesVente = [
            'Bamako',
            'Kati',
            'Négala',
            'Sébécoro',
            'Badinko',
            'Kita',
            'Toukoto',
            'Oualia',
            'Mahina',
            'Diamou',
            'Kayes',
        ];

        foreach ($garesVente as $nom) {
            $gare = Gare::where('nom', $nom)->first();
            if ($gare) {
                PointsVente::create([
                    'gare_id' => $gare->id,
                    'type' => 'gare', // toujours "gare" pour ces points
                    'actif' => true,
                ]);
            }
        }

        // Exemple d’un point externe (facultatif pour l’instant)
        // PointsVente::create([
        //     'gare_id' => null, // pas lié à une gare
        //     'type' => 'externe',
        //     'actif' => true,
        // ]);
    }
}
