<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

class PermissionSeeder extends Seeder
{
    public function run(): void
    {
        // Réinitialiser les caches
        app()[\Spatie\Permission\PermissionRegistrar::class]->forgetCachedPermissions();

        // Permissions pour chaque module
        $permissions = [
            // Dashboard
            'view dashboard',

            // Ventes
            'view ventes',
            'create ventes',
            'edit ventes',
            'delete ventes',
            'export ventes',

            // Gares
            'view gares',
            'manage gares',

            // Arrêts
            'view arrets',
            'manage arrets',

            // Trains
            'view trains',
            'manage trains',

            // Wagons
            'view wagons',
            'manage wagons',

            // Colis
            'view colis',
            'manage colis',

            // Voyages
            'view voyages',
            'manage voyages',
            'planifier voyages',

            // Utilisateurs
            'view users',
            'manage users',

            // Paramètres
            'manage settings',

            // Rapports
            'view reports',
            'generate reports'
        ];

        // Création des permissions
        foreach ($permissions as $permission) {
            Permission::create(['name' => $permission]);
        }

        // Attribution des permissions aux rôles
        $admin = Role::findByName('admin');
        $admin->givePermissionTo(
            'view dashboard',
            'view ventes',
            'create ventes',
            'edit ventes',
            'delete ventes',
            'export ventes',
            'view gares',
            'manage gares',
            'view arrets',
            'manage arrets',
            'view trains',
            'manage trains',
            'view wagons',
            'manage wagons',
            'view colis',
            'manage colis',
            'view voyages',
            'manage voyages',
            'planifier voyages',
            'view users',
            'manage users',
            'manage settings',
            'view reports',
            'generate reports'
        );

        $chef = Role::findByName('chef');
        $chef->givePermissionTo([
            'view dashboard',
            'view ventes',
            'create ventes',
            'edit ventes',
            'view gares',
            'manage gares',
            'view arrets',
            'manage arrets',
            'view trains',
            'manage trains',
            'view wagons',
            'manage wagons',
            'view colis',
            'manage colis',
            'view voyages',
            'manage voyages',
            'planifier voyages',
            'view reports'
        ]);

        $caissier = Role::findByName('caissier');
        $caissier->givePermissionTo([
            'view dashboard',
            'view ventes',
            'create ventes',
            'view reports'
        ]);
    }
}
