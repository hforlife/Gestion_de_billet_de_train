<?php

namespace App\Http\Controllers\Trains;

use App\Models\Train;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class TrainController
{
    // Affichage de la liste des trains
    public function index(Request $request): Response
    {
        $filters = $request->only('search');

        $trains = Train::orderBy('numero')
            ->when($filters['search'] ?? null, function ($query, $search) {
                $query->where('numero', 'like', "%{$search}%");
            })
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Trains/Index', [
            'filters' => $filters,
            'trains' => $trains->through(fn ($train) => [
                'id' => $train->id,
                'numero' => $train->numero,
                'sens' => $train->sens,
                'etat' => $train->etat,
                'nombre_agents' => $train->nombre_agents,
            ]),
        ]);
    }

    // Formulaire de création
    public function create(): Response
    {
        return Inertia::render('Trains/Create');
    }

    // Enregistrement d'un train
    public function store(Request $request)
    {
        $validated = $request->validate([
            'numero' => ['required', 'string', 'max:255', 'unique:trains,numero'],
            'sens' => ['required', 'in:Bamako-Kayes,Kayes-Bamako'],
            'etat' => ['required', 'in:actif,en_maintenance'],
            'nombre_agents' => ['required', 'string', 'max:255', 'regex:/^\d+$/'], // Assure que c'est un nombre entier
        ]);

        Train::create($validated);

        return redirect()->route('train.index')->with('success', 'Ajout effectué avec succès');
    }

    // Formulaire d’édition
    public function edit(string $id): Response
    {
        $train = Train::findOrFail($id);

        return Inertia::render('Trains/Edit', [
            'trains' => $train,
        ]);
    }

    // Mise à jour d’un train
    public function update(Request $request, string $id)
    {
        $train = Train::findOrFail($id);

        $validated = $request->validate([
            'numero' => ['required', 'string', 'max:255', 'unique:trains,numero,' . $train->id],
            'etat' => ['required', 'in:actif,en_maintenance'],
            'nombre_agents' => ['required', 'string', 'max:255', 'regex:/^\d+$/'], // Assure que c'est un nombre entier
        ]);

        $train->update($validated);

        return redirect()->route('train.index')->with('success', 'Modification effectuée avec succès');
    }

    // Suppression d’un train
    public function destroy(string $id)
    {
        $train = Train::findOrFail($id);
        $train->delete();

        return redirect()->route('train.index')->with('success', 'Suppression effectuée avec succès');
    }
}
