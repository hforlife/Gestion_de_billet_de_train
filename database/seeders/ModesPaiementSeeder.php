<?php

namespace Database\Seeders;

use App\Models\ModesPaiement;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ModesPaiementSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //

        // Mode de Paiement
        ModesPaiement::create([
            'type' => 'especes',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        ModesPaiement::create([
            'type' => 'banque',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        ModesPaiement::create([
            'type' => 'electronique',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        

    }
}
