<?php

namespace App\Http\Controllers;

use App\Models\CategorieColis;
use App\Models\Parametre;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class ParametreController extends Controller
{
    use AuthorizesRequests;
    public function index(): Response
    {
        $this->authorize('viewAny parametre');
        return Inertia::render('Setting/Parametre/Index', [
            'parametres' => Parametre::orderBy('poids_min')->get()->map(fn ($param) => [
                'id' => $param->id,
                'categorie_id' => $param->categorie_id,
                'poids_min' => $param->poids_min,
                'poids_max' => $param->poids_max,
                'prix_par_kg' => $param->prix_par_kg,
                'categorie' => [
                    'id' => $param->categorie->id ?? null,
                    'nom' => $param->categorie->nom ?? 'Inconnue',
                ],
            ]),
            'categories' => CategorieColis::orderBy('nom')->get()->map(fn ($cat) => [
                'id' => $cat->id,
                'nom' => $cat->nom,
                'description' => $cat->description,
            ]),
        ]);
    }

    public function store(Request $request)
    {
        $this->authorize('create parametre');
        $validated = $request->validate([
            'categorie_id' => ['required', 'exists:categorie_colis,id'],
            'poids_min' => ['required', 'numeric'],
            'poids_max' => ['required', 'numeric', 'gt:poids_min'],
            'prix_par_kg' => ['required', 'numeric', 'min:0'],
        ]);

        // Facultatif : vérifier chevauchement avec d'autres plages pour la même catégorie
        $exists = Parametre::where('categorie_id', $validated['categorie_id'])
            ->where(function ($query) use ($validated) {
                $query->whereBetween('poids_min', [$validated['poids_min'], $validated['poids_max']])
                      ->orWhereBetween('poids_max', [$validated['poids_min'], $validated['poids_max']]);
            })
            ->exists();

        if ($exists) {
            return back()->withErrors([
                'poids_min' => 'Cette plage de poids est déjà couverte pour cette catégorie.',
            ]);
        }

        Parametre::create($validated);

        return redirect()->back()->with('success', 'Tarif enregistré avec succès.');
    }
}
