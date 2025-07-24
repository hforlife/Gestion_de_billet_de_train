<?php

namespace App\Http\Controllers\Voyages;

use App\Models\Ligne;
use App\Models\Tarif;
use App\Models\Train;
use App\Models\Voyage;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class VoyageController
{
    public function index(Request $request): Response
    {
        $filters = $request->only('search');

        $voyages = Voyage::with(['train', 'ligne', 'tarif.classeWagon'])
            ->when($filters['search'] ?? null, function ($query, $search) {
                $query->where(function($q) use ($search) {
                    $q->where('nom', 'like', "%{$search}%")
                      ->orWhereHas('train', fn($q) => $q->where('numero', 'like', "%{$search}%"))
                      ->orWhereHas('ligne', fn($q) => $q->where('nom', 'like', "%{$search}%"));
                });
            })
            ->orderByDesc('date_depart')
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Voyages/Index', [
            'filters' => $filters,
            'voyages' => $voyages,
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Voyages/Create', [
            'trains' => Train::select('id', 'numero')->get(),
            'lignes' => Ligne::with('arrets.gare')->get(),
            'tarifs' => Tarif::with('classeWagon')->active()->get(),
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'nom' => ['required', 'string', 'max:255'],
            'train_id' => ['required', 'exists:trains,id'],
            'ligne_id' => ['required', 'exists:lignes,id'],
            'tarif_id' => ['required', 'exists:tarifs,id'],
            'date_depart' => ['required', 'date', 'after_or_equal:now'],
            'date_arrivee' => ['required', 'date', 'after:date_depart'],
            'statut' => ['required', 'in:programmé,en_cours,terminé,annulé'],
        ]);

        Voyage::create($validated);

        return redirect()->route('voyage.index')->with('success', 'Voyage créé avec succès');
    }

    public function edit(Voyage $voyage): Response
    {
        return Inertia::render('Voyages/Edit', [
            'voyage' => $voyage->load('ligne.arrets.gare'),
            'trains' => Train::select('id', 'numero')->get(),
            'lignes' => Ligne::with('arrets.gare')->get(),
            'tarifs' => Tarif::with('classeWagon')->active()->get(),
        ]);
    }

    public function update(Request $request, Voyage $voyage)
    {
        $validated = $request->validate([
            'nom' => ['required', 'string', 'max:255'],
            'train_id' => ['required', 'exists:trains,id'],
            'ligne_id' => ['required', 'exists:lignes,id'],
            'tarif_id' => ['required', 'exists:tarifs,id'],
            'date_depart' => ['required', 'date'],
            'date_arrivee' => ['required', 'date', 'after:date_depart'],
            'statut' => ['required', 'in:programmé,en_cours,terminé,annulé'],
        ]);

        $voyage->update($validated);

        return redirect()->route('voyage.index')->with('success', 'Voyage mis à jour avec succès');
    }

    public function destroy(Voyage $voyage)
    {
        $voyage->delete();
        return redirect()->route('voyage.index')->with('success', 'Voyage supprimé avec succès');
    }
}
