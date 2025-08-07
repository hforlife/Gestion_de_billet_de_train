<?php

namespace App\Http\Controllers\Trains;

use App\Models\Train;
use App\Models\Wagon;
use App\Models\ClassesWagon;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class WagonController
{
    // Liste des wagons
    public function index(Request $request): Response
    {
        $filters = $request->only('search');

        $wagons = Wagon::with(['train', 'classeWagon'])
            ->filter($filters)        // scopeFilter dans le modèle Wagon
            ->orderBy('numero_wagon')
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Trains/Wagons/Index', [
            'filters' => $filters,
            'wagons' => $wagons->through(fn($wagon) => [
                'id' => $wagon->id,
                'train_id' => $wagon->train_id,
                'train_numero' => optional($wagon->train)->numero,
                'classe_id' => $wagon->classe_id,
                'classe_nom' => optional($wagon->classe)->classe,
                'numero_wagon' => $wagon->numero_wagon,
                'nombre_sieges' => $wagon->nombre_sieges,
                'sieges_disponibles' => $wagon->sieges_disponibles,
            ]),
        ]);
    }

    // Formulaire de création
    public function create(): Response
    {
        return Inertia::render('Trains/Wagons/Create', [
            'trains' => Train::where('etat', 'actif')->get(),
            'classes' => ClassesWagon::all(),
        ]);
    }

    // Enregistrement du wagon
    public function store(Request $request)
    {
        $validated = $request->validate([
            'train_id' => 'required|exists:trains,id',
            'classe_id' => 'required|exists:classes_wagon,id',
            'numero_wagon' => ['required', 'string', 'regex:/^2020\d{3}$/'],
            'nombre_sieges' => 'required|integer|min:1',
        ]);

        $validated['sieges_disponibles'] = $validated['nombre_sieges'] - 2;

        $wagon = Wagon::create($validated);

        for ($i = 1; $i <= $validated['nombre_sieges']; $i++) {
            $wagon->places()->create(['numero' => $i]);
        }

        return redirect()->route('wagon.index')->with('success', 'Wagon et sièges créés avec succès.');
    }

    // Formulaire d'édition
    public function edit(int $id): Response
    {
        $wagon = Wagon::with('train', 'classeWagon')->findOrFail($id);

        return Inertia::render('Trains/Wagons/Edit', [
            'wagon' => $wagon,
            'trains' => Train::where('etat', 'actif')->get(),
            'classes' => ClassesWagon::all(),
        ]);
    }

    // Mise à jour
    public function update(Request $request, int $id)
    {
        $wagon = Wagon::findOrFail($id);

        $validated = $request->validate([
            'train_id' => 'required|exists:trains,id',
            'classe_id' => 'required|exists:classes_wagon,id',
            'numero_wagon' => ['required', 'string', 'regex:/^2020\d{3}$/'],
            'nombre_sieges' => 'required|integer|min:1',
        ]);

        $oldCount = $wagon->nombre_sieges;
        $newCount = $validated['nombre_sieges'];

        $validated['sieges_disponibles'] = $newCount; // Reset

        $wagon->update($validated);

        if ($oldCount !== $newCount) {
            $wagon->places()->delete();
            for ($i = 1; $i <= $newCount; $i++) {
                $wagon->places()->create(['numero' => $i]);
            }
        }

        return redirect()->route('wagon.index')->with('success', 'Wagon mis à jour avec succès.');
    }

    // Suppression
    public function destroy(int $id)
    {
        $wagon = Wagon::findOrFail($id);
        $wagon->places()->delete();
        $wagon->delete();

        return redirect()->route('wagon.index')->with('success', 'Suppression effectuée avec succès.');
    }
}
