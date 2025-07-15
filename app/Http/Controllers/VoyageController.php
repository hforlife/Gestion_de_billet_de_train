<?php

namespace App\Http\Controllers;

use App\Models\Gare;
use App\Models\Train;
use App\Models\Voyage;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class VoyageController extends Controller
{
    // Index
    public function index(Request $request): Response
    {
        $filters = $request->only('search');

        $voyages = Voyage::with(['train', 'gare_depart', 'gare_arrivee'])
            ->when($filters['search'] ?? null, function ($query, $search) {
                $query->where('name', 'like', "%{$search}%");
            })
            ->orderByDesc('date_depart')
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Voyages/Index', [
            'filters' => $filters,
            'voyages' => $voyages->through(fn ($voyage) => [
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
            ])
        ]);
    }

    // Create
    public function create(): Response
    {
        return Inertia::render('Voyages/Create', [
            'trains' => Train::select('id', 'numero')->get(),
            'gares' => Gare::select('id', 'nom')->get(),
        ]);
    }

    // Store
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'train_id' => ['required', 'exists:trains,id'],
            'gare_depart_id' => ['required', 'exists:gares,id', 'different:gare_arrivee_id'],
            'gare_arrivee_id' => ['required', 'exists:gares,id'],
            'date_depart' => ['required', 'date'],
            'date_arrivee' => ['nullable', 'date', 'after_or_equal:date_depart'],
            'prix' => ['required', 'numeric', 'min:0'],
            'statut' => ['required', 'in:programmé,en_cours,terminé,annulé'],
        ]);

        Voyage::create($validated);

        return redirect()->route('voyage.index')->with('success', 'Ajout effectué avec succès');
    }

    // Edit
    public function edit(string $id): Response
    {
        $voyage = Voyage::findOrFail($id);

        return Inertia::render('Voyages/Edit', [
            'voyages' => $voyage,
            'trains' => Train::select('id', 'numero')->get(),
            'gares' => Gare::select('id', 'nom')->get(),
        ]);
    }

    // Update
    public function update(Request $request, Voyage $voyage)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'train_id' => ['required', 'exists:trains,id'],
            'gare_depart_id' => ['required', 'exists:gares,id', 'different:gare_arrivee_id'],
            'gare_arrivee_id' => ['required', 'exists:gares,id'],
            'date_depart' => ['required', 'date'],
            'date_arrivee' => ['nullable', 'date', 'after_or_equal:date_depart'],
            'prix' => ['required', 'numeric', 'min:0'],
            'statut' => ['required', 'in:programmé,en_cours,terminé,annulé'],
        ]);

        $voyage->update($validated);

        return redirect()->route('voyage.index')->with('success', 'Modification effectuée avec succès');
    }

    // Destroy
    public function destroy(Voyage $voyage)
    {
        $voyage->delete();

        return redirect()->route('voyage.index')->with('success', 'Suppression effectuée avec succès.');
    }
}
