<?php

namespace App\Http\Controllers\Voyages;

use App\Models\Gare;
use App\Models\Train;
use App\Models\VoyageRecurrent;
use App\Models\JoursSemaine;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class ReccuringVoyageController
{
    // Index
    public function index(Request $request): Response
    {
        $filters = $request->only('search');

        return Inertia::render('Voyages/Voyages_Recurrents/Index', [
            'filters' => $filters,
            'voyages' => VoyageRecurrent::with(['train', 'gare_depart', 'gare_arrivee', 'jours'])
                ->when($filters['search'] ?? null, function ($query, $search) {
                    $query->where('name', 'like', "%{$search}%");
                })
                ->orderBy('name')
                ->paginate(10)
                ->withQueryString()
                ->through(fn($voyage) => [
                    'id' => $voyage->id,
                    'name' => $voyage->name,
                    'train' => [
                        'numero' => optional($voyage->train)->numero,
                    ],
                    'gare_depart' => [
                        'nom' => optional($voyage->gare_depart)->nom,
                    ],
                    'gare_arrivee' => [
                        'nom' => optional($voyage->gare_arrivee)->nom,
                    ],
                    'jours' => $voyage->jours->pluck('nom'), // Liste des jours
                    'heure_depart' => $voyage->heure_depart,
                    'prix' => $voyage->prix,
                    'statut' => $voyage->statut,
                ]),
        ]);
    }

    // Formulaire de création
    public function create(): Response
    {
        return Inertia::render('Voyages/Voyages_Recurrents/Create', [
            'gares' => Gare::all(),
            'trains' => Train::where('etat', 'actif')->get(),
            'joursSemaine' => JoursSemaine::all(['id', 'nom', 'code']),
        ]);
    }

    // Enregistrement
    public function store(Request $request)
    {
        // dd($request);
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'train_id' => 'required|exists:trains,id',
            'gare_depart_id' => 'required|exists:gares,id',
            'gare_arrivee_id' => 'required|exists:gares,id',
            'jours' => 'required|array|min:1',
            'jours.*' => ['integer', 'exists:jours_semaine,id'],
            'heure_depart' => 'required|date_format:H:i',
            'prix' => 'required|numeric|min:0',
        ]);

        $voyage = VoyageRecurrent::create([
            'name' => $validated['name'],
            'train_id' => $validated['train_id'],
            'gare_depart_id' => $validated['gare_depart_id'],
            'gare_arrivee_id' => $validated['gare_arrivee_id'],
            'heure_depart' => $validated['heure_depart'],
            'prix' => $validated['prix'],
            'statut' => 'actif',
        ]);

           // Attachement des jours via la relation
            $voyage->jours()->attach($validated['jours']);

        return redirect()->route('voyage-reccurent.index')->with('success', 'Voyage récurrent créé avec succès.');
    }

    // Formulaire d’édition
    public function edit($id): Response
    {
        $voyage = VoyageRecurrent::with('jours')->findOrFail($id);

        return Inertia::render('Voyages/Voyages_Recurrents/Edit', [
            'voyage' => $voyage,
            'trains' => Train::where('etat', 'actif')->get(),
            'gares' => Gare::all(),
            'jours' => JoursSemaine::all(),
        ]);
    }

    // Mise à jour
    public function update(Request $request, $id)
    {
        $voyage = VoyageRecurrent::findOrFail($id);

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'train_id' => 'required|exists:trains,id',
            'gare_depart_id' => 'required|exists:gares,id',
            'gare_arrivee_id' => 'required|exists:gares,id',
            'jours' => 'required|array|min:1',
            'jours.*' => 'exists:jours_semaine,id',
            'heure_depart' => 'required|date_format:H:i',
            'prix' => 'required|numeric|min:0',
            'statut' => 'required|in:actif,inactif',
        ]);

        $voyage->update([
            'name' => $validated['name'],
            'train_id' => $validated['train_id'],
            'gare_depart_id' => $validated['gare_depart_id'],
            'gare_arrivee_id' => $validated['gare_arrivee_id'],
            'heure_depart' => $validated['heure_depart'],
            'prix' => $validated['prix'],
            'statut' => $validated['statut'],
        ]);

        $voyage->jours()->sync($validated['jours']);

        return redirect()->route('voyage-reccurent.index')->with('success', 'Voyage récurrent mis à jour avec succès.');
    }

    // Suppression
    public function destroy($id)
    {
        $voyage = VoyageRecurrent::findOrFail($id);
        $voyage->jours()->detach();
        $voyage->delete();

        return redirect()->route('voyage-reccurent.index')->with('success', 'Voyage récurrent supprimé avec succès.');
    }
}
