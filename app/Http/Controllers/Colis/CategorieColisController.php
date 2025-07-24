<?php

namespace App\Http\Controllers\Colis;

use Inertia\Inertia;
use Illuminate\Http\Request;
use Inertia\Response;
use App\Models\CategorieColis;

class CategorieColisController
{
    // Index
    public function index(Request $request): Response
    {
        $filters = $request->only('search');

        return Inertia::render('Colis/CategoriesColis/Index', [
            'filters' => $filters,
            'categories' => CategorieColis::orderBy('nom')
                ->when($filters['search'] ?? null, function ($query, $search) {
                    $query->where('nom', 'like', "%{$search}%");
                })
                ->paginate(10)
                ->withQueryString()
                ->through(fn ($cat) => [
                    'id' => $cat->id,
                    'nom' => $cat->nom,
                    'description' => $cat->description,
                ]),
        ]);
    }

    // Formulaire de création
    public function create(): Response
    {
        return Inertia::render('Colis/CategoriesColis/Create');
    }

    // Enregistrement
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nom' => 'required|string|unique:categorie_colis,nom',
            'description' => 'nullable|string',
        ]);

        CategorieColis::create($validated);

        return redirect()->route('categories-colis.index')->with('success', 'Catégorie ajoutée avec succès.');
    }

    // Formulaire de modification
    public function edit(CategorieColis $categorie): Response
    {
        return Inertia::render('Colis/CategoriesColis/Edit', [
            'categorie' => [
                'id' => $categorie->id,
                'nom' => $categorie->nom,
                'description' => $categorie->description,
            ],
        ]);
    }

    // Mise à jour
    public function update(Request $request, CategorieColis $categorie)
    {
        $validated = $request->validate([
            'nom' => 'required|string|unique:categorie_colis,nom,' . $categorie->id,
            'description' => 'nullable|string',
        ]);

        $categorie->update($validated);

        return redirect()->route('categories-colis.index')->with('success', 'Catégorie modifiée avec succès.');
    }

    // Suppression
    public function destroy(CategorieColis $categorie)
    {
        $categorie->delete();

        return redirect()->route('categories-colis.index')->with('success', 'Catégorie supprimée avec succès.');
    }
}
