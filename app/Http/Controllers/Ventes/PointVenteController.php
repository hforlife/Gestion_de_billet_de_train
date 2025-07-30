<?php

namespace App\Http\Controllers\Ventes;

use App\Models\PointsVente;
use App\Models\Gare;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class PointVenteController
{
    public function index(Request $request): Response
    {
        $filters = $request->only('search');

        $pointsVente = PointsVente::with('gare')
            ->orderBy('created_at', 'desc')
            ->when($filters['search'] ?? null, function ($query, $search) {
                $query->whereHas('gare', function($q) use ($search) {
                    $q->where('nom', 'like', "%{$search}%");
                });
            })
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('PointsVente/Index', [
            'filters' => $filters,
            'pointsVente' => $pointsVente->through(fn ($point) => [
                'id' => $point->id,
                'type' => $point->type,
                'actif' => $point->actif ? 'Actif' : 'Inactif',
                'gare_nom' => $point->gare->nom,
            ]),
        ]);
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
