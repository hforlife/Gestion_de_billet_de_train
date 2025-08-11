<?php

namespace App\Http\Controllers\Colis;

use Inertia\Inertia;
use Illuminate\Http\Request;
use Inertia\Response;
use App\Models\CategorieColis;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class CategorieColisController
{
    use AuthorizesRequests;
    // Index
    public function index(Request $request): Response
    {
        $this->authorize('viewAny categorie_colis');
        $filters = $request->only('search');

        return Inertia::render('Colis/CategoriesColis/Index', [
            'filters' => $filters,
            'categories' => CategorieColis::orderBy('nom')
                ->when($filters['search'] ?? null, function ($query, $search) {
                    $query->where('nom', 'like', "%{$search}%");
                })
                ->paginate(10)
                ->withQueryString()
                ->through(fn($cat) => [
                    'id' => $cat->id,
                    'nom' => $cat->nom,
                    'description' => $cat->description,
                ]),
        ]);
    }

    // Formulaire de création
    public function create(): Response
    {
        $this->authorize('create categorie_colis');
        return Inertia::render('Colis/CategoriesColis/Create');
    }

    // Enregistrement
    public function store(Request $request)
    {
        $this->authorize('create categorie_colis');
        $validated = $request->validate([
            'nom' => 'required|string|unique:categorie_colis,nom',
            'description' => 'nullable|string',
        ]);

        CategorieColis::create($validated);

        return redirect()->route('categories-colis.index')->with('success', 'Catégorie ajoutée avec succès.');
    }

    // Formulaire de modification
    public function edit($id): Response
    {
        $this->authorize('update categorie_colis');
        $categorie = CategorieColis::find($id);
        return Inertia::render('Colis/CategoriesColis/Edit', [
            'categorie' => $categorie,
        ]);
    }

    // Mise à jour
    public function update(Request $request, CategorieColis $categorie)
    {
        $this->authorize('update categorie_colis');
        $validated = $request->validate([
            'nom' => 'required|string',
            'description' => 'nullable|string',
        ]);

        $categorie->update($validated);

        return redirect()->route('categories-colis.index')->with('success', 'Catégorie modifiée avec succès.');
    }

    // Suppression
    public function destroy(CategorieColis $categorie)
    {
        $this->authorize('delete categorie_colis');
        if ($categorie->colis()->count() > 0) {
            return redirect()->back()->with('error', 'Cette catégorie ne peut pas être supprimée car elle est liée à des colis.');
        }
        $categorie->delete();

        return redirect()->route('categories-colis.index')->with('success', 'Catégorie supprimée avec succès.');
    }
}
