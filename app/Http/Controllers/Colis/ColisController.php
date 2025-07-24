<?php

namespace App\Http\Controllers\Colis;

use App\Models\CategorieColis;
use App\Models\Colis;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;
use Inertia\Response;

class ColisController
{
    // Affichage de la liste des colis
    public function index(Request $request): Response
{
    $filters = $request->only('search');

    return Inertia::render('Colis/Index', [
        'filters' => $filters,
        'colis' => Colis::with('categorieColis') // ⬅️ Charger la relation
            ->orderBy('user1')
            ->when($filters['search'] ?? null, function ($query, $search) {
                $query->where('user1', 'like', "%{$search}%")
                      ->orWhere('user2', 'like', "%{$search}%");
            })
            ->paginate(10)
            ->through(fn ($item) => [
                'id' => $item->id,
                'user1' => $item->user1,
                'user2' => $item->user2,
                'categorie' => $item->categorieColis,
                'poids' => $item->poids,
                'tarif' => $item->tarif,
                'statut' => $item->statut,

            ]),
    ]);
}

    // Formulaire de création
    public function create(): Response
    {
        return Inertia::render('Colis/Create', [
            'categories' => CategorieColis::with('parametre')->get()->map(fn ($cat) => [
                'id' => $cat->id,
                'nom' => $cat->nom,
                'tarifs' => $cat->parametre->map(fn ($p) => [
                    'poids_min' => $p->poids_min,
                    'poids_max' => $p->poids_max,
                    'prix_par_kg' => $p->prix_par_kg,
                ]),
            ]),
        ]);
    }

    // Enregistrement du colis
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user1' => ['required', 'string'],
            'user2' => ['required', 'string'],
            'categorie_colis_id' => ['required', 'exists:categorie_colis,id'],
            'poids' => ['required', 'numeric'],
            'tarif' => ['required', 'numeric'],
            'statut' => ['required', 'in:enregistré,perdu,livré'],
        ]);

        Colis::create($validated);

        return Redirect::route('colis.index')->with('success', 'Ajout effectué avec succès.');
    }

    // Formulaire de modification
    public function edit(string $id): Response
    {
        $item = Colis::findOrFail($id);

        return Inertia::render('Colis/Edit', [
            'colis' => $item,
            'categories' => CategorieColis::select('id', 'nom')->get(),
        ]);
    }

    // Mise à jour
    public function update(Request $request, int $id)
    {
        $validated = $request->validate([
            'user1' => ['required', 'string'],
            'user2' => ['required', 'string'],
            'categorie_colis_id' => ['required', 'exists:categorie_colis,id'],
            'poids' => ['required', 'numeric'],
            'tarif' => ['required', 'numeric'],
            'statut' => ['required', 'in:enregistré,perdu,livré'],
        ]);

        $colis = Colis::findOrFail($id);
        $colis->update($validated);

        return redirect()->route('colis.index')->with('success', 'Modification effectuée avec succès.');
    }

    // Suppression
    public function destroy(Colis $colis)
    {
        $colis->delete();

        return Redirect::back()->with('success', 'Suppression effectuée avec succès.');
    }
}
