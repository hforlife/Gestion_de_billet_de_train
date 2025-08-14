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
        'name' => 'Super Admin',
        'username' => 'admin',
        'email' => 'admin@doucsoft.com',
        'password' => bcrypt('password'),
        'email_verified_at' => now(),
        'remember_token' => Str::random(10),
    ]);
    $admin1 = User::create([
        'name' => 'Abdoulaye Y HAIDARA',
        'username' => 'abdoul',
        'email' => 'abdoulayeyoro.haidara@doucsoft.com',
        'password' => bcrypt('Animeh920'),
        'email_verified_at' => now(),
        'remember_token' => Str::random(10),
    ]);
    $admin2 = User::create([
        'name' => 'Moussa DOUCOURE',
        'username' => 'doucsoft',
        'email' => 'moussdouc@doucsoft.tech',
        'password' => bcrypt('Admin@2025'),
        'email_verified_at' => now(),
        'remember_token' => Str::random(10),
    ]);
    $admin3 = User::create([
        'name' => 'Malle MAGASSA',
        'username' => 'kizza',
        'email' => 'mallemagass@doucsoft.tech',
        'password' => bcrypt('Kizza@2025'),
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
    $admin1->assignRole($adminRole);
    $admin2->assignRole($adminRole);
    $admin3->assignRole($adminRole);
    }
}
