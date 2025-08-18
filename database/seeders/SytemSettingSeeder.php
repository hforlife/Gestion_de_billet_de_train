<?php

namespace Database\Seeders;

use App\Models\SystemSetting;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class SytemSettingSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        SystemSetting::create([
            'mode_vente' => 'par_kilometrage',
            'tarif_kilometrique' => 20.32, // sans guillemets
            'tarif_minimum' => 3050,
            'bagage_kg' => 500,
            'penalite' => 5,
        ]);
    }
}
