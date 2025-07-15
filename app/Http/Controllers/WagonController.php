<?php

namespace App\Http\Controllers;

use App\Models\Train;
use App\Models\Wagon;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class WagonController extends Controller
{
    // Liste des wagons
    public function index(Request $request): Response
    {
        $filters = $request->only('search');

        $wagons = Wagon::with('train')
            ->when($filters['search'] ?? null, function ($query, $search) {
                $query->where('nom', 'like', "%{$search}%");
            })
            ->orderBy('nom')
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Trains/Wagons/Index', [
            'filters' => $filters,
            'wagons' => $wagons->through(fn ($wagon) => [
                'id' => $wagon->id,
                'train_id' => $wagon->train_id,
                'train_numero' => optional($wagon->train)->numero,
                'nom' => $wagon->nom,
                'nombre_places' => $wagon->nombre_places,
            ]),
        ]);
    }

    // Formulaire de création
    public function create(): Response
    {
        return Inertia::render('Trains/Wagons/Create', [
            'trains' => Train::where('etat', 'actif')->get(),
        ]);
    }

    // Enregistrement du wagon
    public function store(Request $request)
    {
        $validated = $request->validate([
            'train_id' => 'required|exists:trains,id',
            'nom' => 'required|string|max:255',
            'nombre_places' => 'required|integer|min:1',
        ]);

        $wagon = Wagon::create($validated);

        for ($i = 1; $i <= $validated['nombre_places']; $i++) {
            $wagon->places()->create(['numero' => $i]);
        }

        return redirect()->route('wagon.index')->with('success', 'Wagon et places créés avec succès.');
    }

    // Formulaire d'édition
    public function edit(int $id): Response
    {
        $wagon = Wagon::findOrFail($id);

        return Inertia::render('Trains/Wagons/Edit', [
            'wagons' => $wagon,
            'trains' => Train::where('etat', 'actif')->get(),
        ]);
    }

    // Mise à jour
    public function update(Request $request, int $id)
    {
        $wagon = Wagon::findOrFail($id);

        $validated = $request->validate([
            'train_id' => 'required|exists:trains,id',
            'nom' => 'required|string|max:255',
            'nombre_places' => 'required|integer|min:1',
        ]);

        $oldPlaceCount = $wagon->nombre_places;
        $newPlaceCount = $validated['nombre_places'];

        $wagon->update($validated);

        if ($newPlaceCount != $oldPlaceCount) {
            $wagon->places()->delete();

            for ($i = 1; $i <= $newPlaceCount; $i++) {
                $wagon->places()->create(['numero' => $i]);
            }
        }

        return redirect()->route('wagon.index')->with('success', 'Wagon mis à jour avec succès.');
    }

    // Suppression
    public function destroy(int $id)
    {
        $wagon = Wagon::findOrFail($id);
        $wagon->delete();

        return redirect()->route('wagon.index')->with('success', 'Suppression effectuée avec succès.');
    }
}
