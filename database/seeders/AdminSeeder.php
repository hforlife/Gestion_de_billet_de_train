<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Str;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
         // Création d'un admin par défaut
    $admin = User::create([
        'name' => 'admin',
        'email_verified_at' => now(),
        'email' => 'admin@example.com',
        'password' => bcrypt('password'),
        'remember_token' => Str::random(10),
    ]);

    // Lui assigner le rôle d'admin
    $admin->assignRole('admin');
    }
}
