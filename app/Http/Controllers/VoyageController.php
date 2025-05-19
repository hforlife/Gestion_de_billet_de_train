<?php

namespace App\Http\Controllers;

// use App\Enum\statusVoyage;
// use Illuminate\Validation\Rules\Enum;
use App\Http\Controllers\Controller;
use App\Models\Gares;
use App\Models\Trains;
use App\Models\Voyages;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class VoyageController extends Controller
{
    // Index
    public function index(Request $request): Response
    {
        $filters = $request->only('search');

        return Inertia::render('Voyages/Index', props: [
            'filters' => $filters,
            'voyages' => Voyages::orderBy('name')
                ->with(['train', 'gare_depart', 'gare_arrivee'])
                ->filter($filters)
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
                    'date_depart' => $voyage->date_depart,
                    'date_arrivee' => $voyage->date_arrivee,
                    'prix' => $voyage->prix,
                    'statut' => $voyage->statut,
                ]),
        ]);
    }

    // Create
    public function create(): Response
    {
        return Inertia::render('Voyages/Create', [
            'trains' => Trains::all(),
            'gares' => Gares::all(),
        ]);
    }

    // Store
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required'],
            'train_id' => ['required'],
            'gare_depart_id' => ['required'],
            'gare_arrivee_id' => ['required'],
            'date_depart' => ['required'],
            'date_arrivee' => ['nullable'],
            'prix' => ['required'],
            'statut' => ['required'],
        ]);

        Voyages::create($validated);

        return redirect()->route('voyage.index')->with('success', 'Ajout effectué avec succès');
    }

    // Edit
    public function edit(string $id)
    {
        //
        $item = Voyages::findOrFail($id);
        $train = Trains::all();
        $gare = Gares::all();
        return Inertia::render('Voyages/Edit', [
            'voyages' => $item,
            'trains' => $train,
            'gares' => $gare,
        ]);
    }

    // Update
    public function update(Request $request, Voyages $voyage)
    {
        $validated = $request->validate([
            'name' => ['required'],
            'train_id' => ['required'],
            'gare_depart_id' => ['required'],
            'gare_arrivee_id' => ['required'],
            'date_depart' => ['required'],
            'date_arrivee' => ['nullable'],
            'prix' => ['required'],
            'statut' => ['required'],
        ]);

        $voyage->update($validated);

        return redirect()->route('voyage.index')->with('success', 'Modification effectuée avec succès');
    }

    // Destroy
    public function destroy(Voyages $voyage)
    {
        $voyage->delete();

        return redirect()->route('voyage.index')->with('success', 'Suppression effectuée avec succès.');
    }
}
