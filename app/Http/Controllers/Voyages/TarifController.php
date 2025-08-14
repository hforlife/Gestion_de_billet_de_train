<?php

namespace App\Http\Controllers\Voyages;

use App\Models\Ligne;
use App\Models\Tarif;
use App\Models\ClassesWagon;
use App\Models\Gare;
use App\Models\TarifsGare;
use App\Models\Voyage;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class TarifController
{
    use AuthorizesRequests;
    // Liste des tarifs
    public function index(Request $request): Response
    {
        $this->authorize('viewAny tarif');
        $filters = $request->only(['search', 'gare_depart_id', 'gare_arrivee_id', 'classe_id']);

        $tarifs = TarifsGare::with(['voyage', 'classeWagon'])
            ->when(
                $filters['search'] ?? null,
                fn($query, $search) =>
                $query->whereHas(
                    'voyage',
                    fn($q) =>
                    $q->where('nom', 'like', "%{$search}%")
                )->orWhereHas(
                    'gareArrivee',
                    fn($q) =>
                    $q->where('nom', 'like', "%{$search}%")
                )
            )
            ->when(
                $filters['gare_depart_id'] ?? null,
                fn($query, $gareId) =>
                $query->where('gare_depart_id', $gareId)
            )
            ->when(
                $filters['gare_arrivee_id'] ?? null,
                fn($query, $gareId) =>
                $query->where('gare_arrivee_id', $gareId)
            )
            ->when(
                $filters['classe_id'] ?? null,
                fn($query, $classeId) =>
                $query->where('classe_wagon_id', $classeId)
            )
            ->paginate(15)
            ->withQueryString();

        return Inertia::render('Tarifs/Index', [
            'tarifs' => $tarifs,
            'filters' => $filters,
            'gares' => Gare::all(),
            'classes' => ClassesWagon::all(),
            'voyages' => Voyage::all(),
        ]);
    }

    // Formulaire de création
    public function create(): Response
    {
        $this->authorize('create tarif');
        return Inertia::render('Tarifs/Create', [
            'voyages' => Voyage::all(),
            'gares' => Gare::all(),
            'classes' => ClassesWagon::all(),
        ]);
    }

    // Enregistrement d'un nouveau tarif
    public function store(Request $request)
    {
        $this->authorize('create tarif');
        $validated = $request->validate([
            'voyage_id' => 'nullable|exists:voyages,id',
            'classe_wagon_id' => 'required|exists:classes_wagon,id',
            'prix' => 'required|numeric|min:0',
            'date_effet' => 'required|date|after_or_equal:today',
            'date_expiration' => 'nullable|date|after:date_effet',
        ]);


        TarifsGare::create($validated);

        return redirect()->route('tarif.index')->with('success', 'Tarif créé avec succès.');
    }


    // Formulaire d'édition
    public function edit(TarifsGare $tarif): Response
    {
        $this->authorize('update tarif');
        return Inertia::render('Tarifs/Edit', [
            'tarif' => $tarif->load(['voyage']),
            'voyages' => Voyage::all(),
            'gares' => Gare::all(),
            'classes' => ClassesWagon::all(),
        ]);
    }

    // Mise à jour d'un tarif
    public function update(Request $request, TarifsGare $tarif)
    {
        $this->authorize('update tarif');
        $validated = $request->validate([
            'voyage_id' => 'nullable|exists:voyages,id',
            'classe_wagon_id' => 'required|exists:classes_wagon,id',
            'prix' => 'required|numeric|min:0',
            'date_effet' => 'required|date|after_or_equal:today',
            'date_expiration' => 'nullable|date|after:date_effet',
        ]);

        $tarif->update($validated);

        return redirect()->route('tarif.index')->with('success', 'Tarif mis à jour.');
    }


    // Suppression d'un tarif
    public function destroy(Tarif $tarif)
    {
        $this->authorize('delete tarif');
        $tarif->delete();

        return redirect()->route('tarif.index')
            ->with('success', 'Tarif supprimé avec succès');
    }
}
