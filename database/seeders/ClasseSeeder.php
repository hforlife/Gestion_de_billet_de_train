<?php

namespace Database\Seeders;

use App\Models\ClassesWagon;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ClasseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
                // Classes de Wagon
        ClassesWagon::create([
            'classe' => 'premiere',
            'prix_multiplier' => 1.5, // Multiplier pour le prix de la première classe
            'created_at' => now(),
            'updated_at' => now()
        ]);
        ClassesWagon::create([
            'classe' => 'deuxieme',
            'prix_multiplier' => 1.0, // Multiplier pour le prix de la deuxième classe
            'created_at' => now(),
            'updated_at' => now()
        ]);

    }
}
