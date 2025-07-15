<?php

namespace App\Http\Controllers;

use App\Models\Arret;
use App\Models\Gare;
use App\Models\Voyage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;
use Inertia\Response;

class ArretController extends Controller
{
    // Liste des arrêts
    public function index(Request $request): Response
    {
        $filters = $request->only('search');

        $arrets = Arret::with(['voyage', 'gare'])
            ->orderBy('ordre')
            ->when($filters['search'] ?? null, function ($query, $search) {
                $query->whereHas('gare', function ($q) use ($search) {
                    $q->where('nom', 'like', "%{$search}%");
                });
            })
            ->paginate(10)
            ->withQueryString()
            ->through(fn ($arret) => [
                'id' => $arret->id,
                'voyage' => [
                    'id' => $arret->voyage->id,
                    'name' => $arret->voyage->name,
                ],
                'gare' => [
                    'id' => $arret->gare->id,
                    'nom' => $arret->gare->nom,
                ],
                'heure_arrivee' => $arret->heure_arrivee,
                'heure_depart' => $arret->heure_depart,
                'ordre' => $arret->ordre,
            ]);

        return Inertia::render('Arrets/Index', [
            'filters' => $filters,
            'arrets' => $arrets,
        ]);
    }

    // Formulaire de création
    public function create(): Response
    {
        return Inertia::render('Arrets/Create', [
            'voyages' => Voyage::where('statut', 'programmé')->get(['id', 'name']),
            'gares' => Gare::all(['id', 'nom']),
        ]);
    }

    // Enregistrement
    public function store(Request $request)
    {
        $validated = $request->validate([
            'voyage_id' => ['required', 'exists:voyages,id'],
            'gare_id' => ['required', 'exists:gares,id'],
            'heure_arrivee' => ['nullable', 'date_format:H:i'],
            'heure_depart' => ['nullable', 'date_format:H:i'],
        ]);

        $ordre = Arret::where('voyage_id', $validated['voyage_id'])->max('ordre') + 1;

        Arret::create([
            'voyage_id' => $validated['voyage_id'],
            'gare_id' => $validated['gare_id'],
            'heure_arrivee' => $validated['heure_arrivee'],
            'heure_depart' => $validated['heure_depart'],
            'ordre' => $ordre,
        ]);

        return redirect()->route('arret.index')->with('success', 'Arrêt ajouté avec succès.');
    }

    // Formulaire d’édition
    public function edit(int $id): Response
    {
        $arret = Arret::findOrFail($id);

        return Inertia::render('Arrets/Edit', [
            'arret' => [
                'id' => $arret->id,
                'voyage_id' => $arret->voyage_id,
                'gare_id' => $arret->gare_id,
                'heure_arrivee' => $arret->heure_arrivee,
                'heure_depart' => $arret->heure_depart,
                'ordre' => $arret->ordre,
            ],
            'voyages' => Voyage::where('statut', 'programmé')->get(['id', 'name']),
            'gares' => Gare::all(['id', 'nom']),
        ]);
    }

    // Mise à jour
    public function update(Request $request, Arret $arret)
    {
        $validated = $request->validate([
            'voyage_id' => ['required', 'exists:voyages,id'],
            'gare_id' => ['required', 'exists:gares,id'],
            'heure_arrivee' => ['nullable', 'date_format:H:i'],
            'heure_depart' => ['nullable', 'date_format:H:i'],
            'ordre' => ['nullable', 'integer|min:1'],
        ]);

        $arret->update($validated);

        return redirect()->route('arret.index')->with('success', 'Modification effectuée avec succès.');
    }

    // Suppression
    public function destroy(int $id)
    {
        $arret = Arret::findOrFail($id);
        $arret->delete();

        return redirect()->route('arret.index')->with('success', 'Suppression effectuée avec succès.');
    }
}
