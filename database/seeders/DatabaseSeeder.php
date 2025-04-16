<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Gares;
use App\Models\Trains;
use App\Models\Voyages;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        // User::factory()->create([
        //     'name' => 'Test User',
        //     'email' => 'test@example.com',
        // ]);

         // Création des rôles (Administrateur, Chef de Gare & Caissier)
       $adminRole = Role::create([
        'name' => 'admin',
        'guard_name' => 'admin',
    ]);
       $chefRole = Role::create([
        'name' => 'chef',
        'guard_name' => 'chef',
    ]);
       $caissierRole = Role::create([
        'name' => 'caissier',
        'guard_name' => 'web',
    ]);

    // Création d'un admin par défaut
    $admin = User::create([
        'name' => 'admin',
        'email' => 'admin@example.com',
        'password' => bcrypt('password'),
    ]);

    // // Lui assigner le rôle d'admin
    $admin->assignRole($adminRole);

    //  Gares::factory(10)->create();
    //  Trains::factory(10)->create();
    //  Voyages::factory(10)->create();
    }
}
