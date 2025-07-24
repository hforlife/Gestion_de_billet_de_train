<?php

namespace App\Http\Controllers\Voyages;

use App\Models\Ligne;
use App\Models\Tarif;
use App\Models\ClassesWagon;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class TarifController 
{
    // Liste des tarifs
    public function index(Request $request): Response
    {
        $filters = $request->only(['search', 'ligne_id', 'classe_id']);

        $tarifs = Tarif::with(['ligne', 'classeWagon'])
            ->when($filters['search'] ?? null, fn($query, $search) =>
                $query->whereHas('ligne', fn($q) =>
                    $q->where('nom', 'like', "%{$search}%")
                )
            )
            ->when($filters['ligne_id'] ?? null, fn($query, $ligneId) =>
                $query->where('ligne_id', $ligneId)
            )
            ->when($filters['classe_id'] ?? null, fn($query, $classeId) =>
                $query->where('classe_wagon_id', $classeId)
            )
            ->orderBy('date_effet', 'desc')
            ->paginate(15)
            ->withQueryString();

        return Inertia::render('Tarifs/Index', [
            'tarifs' => $tarifs,
            'filters' => $filters,
            'lignes' => Ligne::all(),
            'classes' => ClassesWagon::all(),
        ]);
    }

    // Formulaire de création
    public function create(): Response
    {
        return Inertia::render('Tarifs/Create', [
            'lignes' => Ligne::all(),
            'classes' => ClassesWagon::all(),
        ]);
    }

    // Enregistrement d'un nouveau tarif
    public function store(Request $request)
    {
        $validated = $request->validate([
            'ligne_id' => 'required|exists:lignes,id',
            'classe_wagon_id' => 'required|exists:classes_wagon,id',
            'prix_base' => 'required|numeric|min:0',
            'date_effet' => 'required|date|after_or_equal:today',
            'date_expiration' => 'nullable|date|after:date_effet',
        ]);

        // Vérifier qu'il n'y a pas de chevauchement de dates
        $existing = Tarif::where('ligne_id', $validated['ligne_id'])
            ->where('classe_wagon_id', $validated['classe_wagon_id'])
            ->where(function($query) use ($validated) {
                $query->whereNull('date_expiration')
                    ->orWhere('date_expiration', '>=', $validated['date_effet']);
            })
            ->exists();

        if ($existing) {
            return back()->withErrors([
                'date_effet' => 'Un tarif existe déjà pour cette période'
            ]);
        }

        Tarif::create($validated);

        return redirect()->route('tarif.index')
            ->with('success', 'Tarif créé avec succès');
    }

    // Formulaire d'édition
    public function edit(Tarif $tarif): Response
    {
        return Inertia::render('Tarifs/Edit', [
            'tarif' => $tarif->load(['ligne', 'classeWagon']),
            'lignes' => Ligne::all(),
            'classes' => ClassesWagon::all(),
        ]);
    }

    // Mise à jour d'un tarif
    public function update(Request $request, Tarif $tarif)
    {
        $validated = $request->validate([
            'prix_base' => 'required|numeric|min:0',
            'date_effet' => 'required|date',
            'date_expiration' => 'nullable|date|after:date_effet',
        ]);

        $tarif->update($validated);

        return redirect()->route('tarif.index')
            ->with('success', 'Tarif mis à jour avec succès');
    }

    // Suppression d'un tarif
    public function destroy(Tarif $tarif)
    {
        $tarif->delete();

        return redirect()->route('tarif.index')
            ->with('success', 'Tarif supprimé avec succès');
    }
}
