<?php

namespace App\Http\Api\V1;

use Illuminate\Http\Request;
use App\Models\ModesPaiement;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;
use Inertia\Response;

class PaiementController
{
    public function index(Request $request)
    {

        return response()->json([
            'status' => true,
            'message' => 'Liste des paiements récupérée avec succès.',
            'paiements' => ModesPaiement::all(),
        ], 200); 
    }

    public function create(): Response
    {
        return Inertia::render('Paiements/Create');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'type' => ['required', 'string', 'max:255'],
        ]);

        ModesPaiement::create($validated);

        return Redirect::route('paiement.index')->with('success', 'Mode de paiement créé avec succès.');
    }

    public function edit(ModesPaiement $modesPaiement): Response
    {
        return Inertia::render('Paiements/Edit', [
            'mode' => $modesPaiement->only('id', 'type'),
        ]);
    }

    public function update(Request $request, ModesPaiement $modesPaiement)
    {
        $validated = $request->validate([
            'type' => ['required', 'string', 'max:255'],
        ]);

        $modesPaiement->update($validated);

        return Redirect::route('paiement.index')->with('success', 'Mode de paiement mis à jour avec succès.');
    }

    public function destroy(ModesPaiement $modesPaiement)
    {
        $modesPaiement->delete();

        return Redirect::back()->with('success', 'Mode de paiement supprimé avec succès.');
    }
}
