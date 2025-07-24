<?php

namespace App\Http\Controllers\Gares;

use App\Models\ArretsLigne;
use App\Models\Gare;
use App\Models\Ligne;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class ArretController
{
    // Liste des arrêts
    public function index(Request $request): Response
    {
        $filters = $request->only(['search', 'ligne_id']);

        $arrets = ArretsLigne::with(['ligne', 'gare'])
            ->orderBy('ordre')
            ->when($filters['search'] ?? null, function ($query, $search) {
                $query->whereHas('gare', function ($q) use ($search) {
                    $q->where('nom', 'like', "%{$search}%");
                });
            })
            ->when($filters['ligne_id'] ?? null, function ($query, $ligneId) {
                $query->where('ligne_id', $ligneId);
            })
            ->paginate(10)
            ->withQueryString()
            ->through(fn ($arret) => [
                'id' => $arret->id,
                'ligne' => [
                    'id' => $arret->ligne->id,
                    'nom' => $arret->ligne->nom,
                ],
                'gare' => [
                    'id' => $arret->gare->id,
                    'nom' => $arret->gare->nom,
                ],
                'distance_depart' => $arret->distance_depart,
                'vente_chef_train' => $arret->vente_chef_train,
                'ordre' => $arret->ordre,
            ]);

        return Inertia::render('Arrets/Index', [
            'filters' => $filters,
            'arrets' => $arrets,
            'lignes' => Ligne::all(['id', 'nom']),
        ]);
    }

    // Formulaire de création
    public function create(): Response
    {
        return Inertia::render('Arrets/Create', [
            'lignes' => Ligne::all(['id', 'nom']),
            'gares' => Gare::all(['id', 'nom']),
        ]);
    }

    // Enregistrement
    public function store(Request $request)
    {
        $validated = $request->validate([
            'ligne_id' => ['required', 'exists:lignes,id'],
            'gare_id' => ['required', 'exists:gares,id'],
            'distance_depart' => ['required', 'numeric', 'min:0'],
            // 'vente_chef_train' => ['required', 'boolean'],
        ]);

        // Calcul de l'ordre automatique
        $ordre = ArretsLigne::where('ligne_id', $validated['ligne_id'])
            ->max('ordre') ?? 0;

        ArretsLigne::create([
            ...$validated,
            'ordre' => $ordre + 1,
        ]);

        return redirect()->route('arret.index')
            ->with('success', 'Arrêt en gare ajouté avec succès.');
    }

    // Formulaire d'édition
    public function edit(ArretsLigne $arret): Response
    {
        return Inertia::render('Arrets/Edit', [
            'arret' => [
                'id' => $arret->id,
                'ligne_id' => $arret->ligne_id,
                'gare_id' => $arret->gare_id,
                'distance_depart' => $arret->distance_depart,
                'vente_chef_train' => $arret->vente_chef_train,
                'ordre' => $arret->ordre,
            ],
            'lignes' => Ligne::all(['id', 'nom']),
            'gares' => Gare::all(['id', 'nom']),
        ]);
    }

    // Mise à jour
    public function update(Request $request, ArretsLigne $arret)
    {
        $validated = $request->validate([
            'ligne_id' => ['required', 'exists:lignes,id'],
            'gare_id' => ['required', 'exists:gares,id'],
            'distance_depart' => ['required', 'numeric', 'min:0'],
            'vente_chef_train' => ['required', 'boolean'],
            'ordre' => ['required', 'integer', 'min:1'],
        ]);

        $arret->update($validated);

        return redirect()->route('arret.index')
            ->with('success', 'Arrêt en gare mis à jour avec succès.');
    }

    // Suppression
    public function destroy(ArretsLigne $arret)
    {
        $arret->delete();

        // Réorganiser l'ordre des arrêts restants
        ArretsLigne::where('ligne_id', $arret->ligne_id)
            ->where('ordre', '>', $arret->ordre)
            ->decrement('ordre');

        return redirect()->route('arret.index')
            ->with('success', 'Arrêt en gare supprimé avec succès.');
    }
}
