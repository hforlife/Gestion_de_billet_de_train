<?php

namespace App\Http\Api\V1;

use App\Models\ArretsLigne;
use App\Models\Gare;
use App\Models\SystemSetting;
use App\Models\TypesGare;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;
use Inertia\Response;

class SettingController
{
    public function index()
    {
        return response()->json([
            'status' => true,
            'message' => 'Liste des Setting systeme récupérée avec succès.',
            'setting' => SystemSetting::first(),
        ], 200); 
    }
    

    public function create(): Response
    {
        return Inertia::render('Gares/Create');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'nom' => ['required', 'string', 'max:255'],
            'adresse' => ['required', 'string', 'max:255'],
            'type' => ['required', 'in:principale,passage,halte,fermee'],
            'distance_km' => ['required', 'numeric', 'min:0'],
            'internet' => ['boolean'],
            'electricite' => ['boolean'],
            'nombre_guichets' => ['required', 'integer', 'min:0'],
            'controle_bagage' => ['required', 'in:physique,electronique,aucun'],
        ]);
        // dd($validated);

        Gare::create($validated);

        return Redirect::route('gare.index')->with('success', 'Gare créée avec succès.');
    }

    public function edit(Gare $gare): Response
    {
        return Inertia::render('Gares/Edit', [
            'gare' => [
                'id' => $gare->id,
                'nom' => $gare->nom,
                'adresse' => $gare->adresse,
                'type' => $gare->type,
                'distance_km' => $gare->distance_km,
                'internet' => $gare->internet,
                'electricite' => $gare->electricite,
                'nombre_guichets' => $gare->nombre_guichets,
                'controle_bagage' => $gare->controle_bagage,
            ],
        ]);
    }

    public function update(Request $request, Gare $gare)
    {
        $validated = $request->validate([
            'nom' => ['required', 'string', 'max:255'],
            'adresse' => ['required', 'string', 'max:255'],
            'type' => ['required', 'in:principale,passage,halte,fermee'],
            'distance_km' => ['required', 'numeric', 'min:0'],
            'internet' => ['boolean'],
            'electricite' => ['boolean'],
            'nombre_guichets' => ['required', 'integer', 'min:0'],
            'controle_bagage' => ['required', 'in:physique,electronique,aucun'],
        ]);

        $gare->update($validated);

        return Redirect::route('gare.index')->with('success', 'Gare mise à jour avec succès.');
    }

    public function destroy(Gare $gare)
    {
        if ($gare->pointsVente()->exists() || $gare->arretsLigne()->exists()) {
            return Redirect::back()->with('error', 'Impossible de supprimer : la gare est utilisée dans le système.');
        }

        $gare->delete();

        return Redirect::back()->with('success', 'Gare supprimée avec succès.');
    }
}
