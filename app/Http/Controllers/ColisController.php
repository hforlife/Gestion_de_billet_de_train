<?php

namespace App\Http\Controllers;

use App\Models\categorieColis;
use App\Models\Colis;
use App\Models\Parametres;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;
use Inertia\Response;

class ColisController extends Controller
{
    // Affichage de la liste des colis
    public function index(Request $request): Response
    {
        $filters = $request->only('search');

        return Inertia::render('Colis/Index', [
            'filters' => $filters,
            'bagages' => Colis::orderBy('user1')
                ->filter($filters)
                ->paginate(10)
                ->withQueryString()
                ->through(fn($bagage) => [
                    'id' => $bagage->id,
                    'user1' => $bagage->user1,
                    'user2' => $bagage->user2,
                    'poids' => $bagage->poids,
                    'tarif' => $bagage->tarif,
                    'statut' => $bagage->statut,
                    'categorie_colis_id' => $bagage->categorie_colis_id, 
                ]),
        ]);
    }

    // Formulaire de création
    public function create(): Response {
    return Inertia::render('Colis/Create', [
        'categories' => categorieColis::with('parametres')->get()->map(fn ($cat) => [
            'id' => $cat->id,
            'nom' => $cat->nom,
            'tarifs' => $cat->parametres->map(fn ($p) => [
                'poids_min' => $p->poids_min,
                'poids_max' => $p->poids_max,
                'prix_par_kg' => $p->prix_par_kg,
            ]),
        ]),
    ]);
}


    // Stockage d'un colis
public function store(Request $request)
{
    $validated = $request->validate([
        'user1' => ['required'],
        'user2' => ['required'],
        'categorie_colis_id' => ['required', 'exists:categorie_colis,id'],
        'poids' => ['required', 'numeric'],
        'tarif' => ['required', 'numeric'],
        'statut' => ['required'],
    ]);

    // dd($validated);
    Colis::create($validated);

    return Redirect::route('bagage.index')->with('success', 'Ajout effectué avec succès');
}


    // Formulaire d'édition
    public function edit(string $id): Response
    {
        $item = Colis::findOrFail($id);

        return Inertia::render('Colis/Edit', [
            'colis' => $item,
            'categories' => categorieColis::all()->map(fn($cat) => [
                'id' => $cat->id,
                'nom' => $cat->nom,
            ]),
        ]);
    }

    // Mise à jour
    public function update(Request $request, int $id)
    {
        $validated = $request->validate([
            'user1' => ['required', 'string'],
            'user2' => ['required', 'string'],
            'categorie_colis_id' => ['required', 'exists:categorie_colis,id'], // ✅ corrigé
            'poids' => ['required', 'numeric'],
            'tarif' => ['required', 'numeric'],
            'statut' => ['required'],
        ]);

        $item = Colis::findOrFail($id);
        $item->update($validated);

        return redirect()->route('bagage.index')->with('success', 'Modification effectuée avec succès');
    }

    // Suppression
    public function destroy(Colis $colis)
    {
        $colis->delete();

        return Redirect::back()->with('success', 'Suppression effectuée avec succès.');
    }
}
