<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Str;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
         // Création d'un admin par défaut
    $admin = User::create([
        'name' => 'Admin SOPAFER',
        'email' => 'admin@example.com',
        'password' => bcrypt('password'),
        'email_verified_at' => now(),
        'remember_token' => Str::random(10),
    ]);

    // Lui assigner le rôle d'admin
    // $admin->assignRole('admin');

    $adminRole = Role::firstWhere('name', 'admin');

    // Donne toutes les permissions à l'admin
    $adminRole->syncPermissions(Permission::all());

    // Donne le rôle admin à l'utilisateur
    $admin->assignRole($adminRole);
    }
}
