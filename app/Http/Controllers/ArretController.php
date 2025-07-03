<?php

namespace App\Http\Controllers;

use App\Models\Arrets;
use App\Models\Gares;
use App\Models\Voyages;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;

class ArretController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $filters = $request->only('search');

        $arrets = Arrets::with(['voyage', 'gare'])
            ->orderBy('ordre')
            ->filter($filters)
            ->paginate(10)
            ->withQueryString()
            ->through(fn($arret) => [
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


    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return Inertia::render('Arrets/Create', [
            'voyages' => Voyages::where('statut', 'programmé')->get(['id', 'name']),
            'gares' => Gares::all(['id', 'nom']),
        ]);
    }


    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'voyage_id' => ['required', 'exists:voyages,id'],
            'gare_id' => ['required', 'exists:gares,id'],
            'heure_arrivee' => ['nullable', 'date_format:H:i'],
            'heure_depart' => ['nullable', 'date_format:H:i'],
        ]);

        // Calcul de l'ordre : on prend le plus grand ordre + 1 pour le voyage donné
        $ordre = Arrets::where('voyage_id', $validated['voyage_id'])->max('ordre') + 1;

        Arrets::create([
            'voyage_id' => $validated['voyage_id'],
            'gare_id' => $validated['gare_id'],
            'heure_arrivee' => $validated['heure_arrivee'],
            'heure_depart' => $validated['heure_depart'],
            'ordre' => $ordre,
        ]);

        return redirect()->route('arret.index')->with('success', 'Arrêt ajouté avec succès');
    }


    /**
     * Display the specified resource.
     */
    public function show(Arrets $arrets)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id)
    {
        $arret = Arrets::findOrFail($id);

        return Inertia::render('Arrets/Edit', [
            'arret' => [
                'id' => $arret->id,
                'voyage_id' => $arret->voyage_id,
                'gare_id' => $arret->gare_id,
                'heure_arrivee' => $arret->heure_arrivee,
                'heure_depart' => $arret->heure_depart,
                'ordre' => $arret->ordre,
            ],
            'voyages' => Voyages::where('statut', 'programmé')->get(['id', 'name']),
            'gares' => Gares::all(['id', 'nom']),
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Arrets $arrets)
    {
        $validated = $request->validate([
            'voyage_id' => ['required', 'exists:voyages,id'],
            'gare_id' => ['required', 'exists:gares,id'],
            'heure_arrivee' => ['nullable'],
            'heure_depart' => ['nullable'],
            'ordre' => ['nullable'],
        ]);

        $arrets->update($validated);

        return Redirect::route('arret.index')->with('success', 'Modification effectuée avec succès');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $items = Arrets::find($id);
        $items->delete();

        return redirect()->route('arret.index')->with('success', 'Suppression effectué avec succes.');
    }
}
