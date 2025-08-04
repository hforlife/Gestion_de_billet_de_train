<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;

class RoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
      // Création des rôles (Administrateur, Chef de Gare & Caissier)
      Role::create(['name' => 'admin']);
      Role::create(['name' => 'chef']);
      Role::create(['name' => 'caissier']);
    }
}
