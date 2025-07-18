<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;


class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call(RoleSeeder::class);
        $this->call(AdminSeeder::class);
        $this->call(PermissionSeeder::class);

        // Optionnel : créer des utilisateurs de test
        User::factory(5)->create()->each(function ($user) {
            $user->assignRole('caissier');
        });

        User::factory(3)->create()->each(function ($user) {
            $user->assignRole('chef');
        });
    }
}
