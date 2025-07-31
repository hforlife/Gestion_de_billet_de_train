<?php

namespace Database\Seeders;

use App\Models\CategorieColis;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CategorieColisSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        // Categorie Colis
        CategorieColis::create([
            'nom' => 'Documents',
            'description' => 'Colis contenant des documents importants',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Paquets',
            'description' => 'Colis contenant des paquets',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Bagages',
            'description' => 'Colis contenant des bagages personnels',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Fret',
            'description' => 'Colis de fret pour le transport de marchandises',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Autres',
            'description' => 'Colis de catégorie non spécifiée',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Fragile',
            'description' => 'Colis contenant des objets fragiles',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Alimentaire',
            'description' => 'Colis contenant des produits alimentaires',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Vêtements',
            'description' => 'Colis contenant des vêtements',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Électronique',
            'description' => 'Colis contenant des appareils électroniques',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Meubles',
            'description' => 'Colis contenant des meubles',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Outils',
            'description' => 'Colis contenant des outils et équipements',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Livres',
            'description' => 'Colis contenant des livres et publications',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Jouets',
            'description' => 'Colis contenant des jouets et jeux',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Animaux',
            'description' => 'Colis contenant des animaux vivants',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Véhicules',
            'description' => 'Colis contenant des pièces ou véhicules',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Matériel de construction',
            'description' => 'Colis contenant des matériaux de construction',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Produits chimiques',
            'description' => 'Colis contenant des produits chimiques',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Produits pharmaceutiques',
            'description' => 'Colis contenant des médicaments et produits de santé',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Art et antiquités',
            'description' => 'Colis contenant des œuvres d’art et antiquités',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Instruments de musique',
            'description' => 'Colis contenant des instruments de musique',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        CategorieColis::create([
            'nom' => 'Matériel informatique',
            'description' => 'Colis contenant des composants et accessoires informatiques',
            'created_at' => now(),
            'updated_at' => now()
        ]);
    }
}
