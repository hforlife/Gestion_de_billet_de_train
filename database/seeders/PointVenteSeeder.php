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
            'Gare de Bamako',
            'Gare de Kati',
            'Gare de Négala',
            'Gare de Sébécoro',
            'Gare de Badinko',
            'Gare de Kita',
            'Gare de Toukoto',
            'Gare de Oualia',
            'Gare de Mahina',
            'Gare de Diamou',
            'Gare de Kayes',
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
