<?php

namespace App\Http\Api\V1;

use App\Models\PointsVente;
use App\Models\Gare;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class PointVenteController
{
    public function index()
    {
 
        return response()->json([
            'status' => true,
            'message' => 'Liste des pointsVentes récupérée avec succès.',
            'pointsVentes' => PointsVente::all(),
        ], 200); 
    }

    public function create(): Response
    {
        return Inertia::render('PointsVente/Create', [
            'gares' => Gare::query()->get()->map(fn($gare) => [
                'id' => $gare->id,
                'nom' => $gare->nom,
                'type' => $gare->type,
            ]),
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'gare_id' => ['required', 'exists:gares,id'],
            'type' => ['required'],
            'actif' => ['required', 'boolean'],
        ]);

        PointsVente::create($validated);

        return redirect()->route('points-vente.index')
            ->with('success', 'Point de vente créé avec succès');
    }

    public function edit(PointsVente $pointsVente): Response
    {
        return Inertia::render('PointsVente/Edit', [
            'pointVente' => [
                'id' => $pointsVente->id,
                'gare_id' => $pointsVente->gare_id,
                'type' => $pointsVente->type,
                'actif' => $pointsVente->actif,
            ],
            'gares' => Gare::with('typeGare')->get()->map(fn($gare) => [
                'id' => $gare->id,
                'nom' => $gare->nom,
                'type' => $gare->typeGare->type,
            ]),
        ]);
    }

    public function update(Request $request, PointsVente $pointsVente)
    {
        $validated = $request->validate([
            'gare_id' => ['required', 'exists:gares,id'],
            'type' => ['required'],
            'actif' => ['required', 'boolean'],
        ]);

        $pointsVente->update($validated);

        return redirect()->route('points-vente.index')
            ->with('success', 'Point de vente mis à jour');
    }

    public function destroy(PointsVente $pointsVente)
    {
        $pointsVente->delete();

        return redirect()->back()
            ->with('success', 'Point de vente supprimé');
    }
}
