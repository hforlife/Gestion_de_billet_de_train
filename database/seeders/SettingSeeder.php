<?php

namespace Database\Seeders;

use App\Models\SystemSetting;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;

class SettingSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        SystemSetting::create([
            "mode_vente" => "par_kilometrage",
            "tarif_kilometrique" => "20.00",
            "tarif_minimum" => "3050.00",
            "coefficients_classes" => [
                1 => 1.2,  // Utilisation de nombres décimaux directement
                2 => 1.0,
                3 => 0.8
            ],
            "created_at" => "2025-08-06T12:16:13.000000Z",
            "updated_at" => "2025-08-06T12:21:01.000000Z"
        ]);
    }
}
