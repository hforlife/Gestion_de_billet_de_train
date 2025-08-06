<?php

namespace Database\Seeders;

use App\Models\ArretsLigne;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ArretLigneSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        ArretsLigne::create([
            'ligne_id' => 1,
            'gare_id' => 1
        ]);
    }
}
