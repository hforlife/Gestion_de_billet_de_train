<?php

namespace App\Http\Controllers\Voyages;

use App\Models\Train;
use App\Models\Ligne;
use App\Models\TarifsGare;
use App\Models\Voyage;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Http\JsonResponse;

class VoyageController
{
    public function index(Request $request): Response
    {
        $filters = $request->only('search');

        $voyages = Voyage::with([
            'train',
            'ligne',
            'depart.gare',
            'arrivee.gare',
            'tarifs.gareDepart',
            'tarifs.gareArrivee',
            'tarifs.classeWagon',
        ])
            ->when($filters['search'] ?? null, function ($query, $search) {
                $query->where(function ($q) use ($search) {
                    $q->where('nom', 'like', "%{$search}%")
                        ->orWhereHas('train', fn($q) => $q->where('numero', 'like', "%{$search}%"))
                        ->orWhereHas('ligne', fn($q) => $q->where('nom', 'like', "%{$search}%"));
                });
            })
            ->orderByDesc('date_depart')
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Voyages/Index', [
            'trains' => Train::select('id', 'numero')->get(),
            'lignes' => Ligne::with(['arrets.gare'])->get(),
            'tarifs' => TarifsGare::with(['classeWagon', 'gareDepart', 'gareArrivee'])->active()->get(),
            'filters' => $filters,
            'voyages' => $voyages,
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Voyages/Create', [
            'trains' => Train::select('id', 'numero')->get(),
            'lignes' => Ligne::with(['arrets.gare'])->get(),
            // 'tarifs' => TarifsGare::with(['classeWagon', 'gareDepart', 'gareArrivee'])->active()->get(),
        ]);
    }

    // public function tarifs($voyageId): JsonResponse
    // {
    //     $voyage = Voyage::with([
    //         'tarifsVoyage.tarifGare.gareDepart',
    //         'tarifsVoyage.tarifGare.gareArrivee',
    //         'tarifsVoyage.tarifGare.classeWagon'
    //     ])->findOrFail($voyageId);

    //     $tarifs = $voyage->tarifsVoyage->map(function ($tv) {
    //         $tarif = $tv->tarifGare;

    //         return [
    //             'id' => $tarif->id,
    //             'gare_depart' => $tarif->gareDepart->nom,
    //             'gare_arrivee' => $tarif->gareArrivee->nom,
    //             'classe' => $tarif->classeWagon->nom,
    //             'classe_id' => $tarif->classeWagon->id,
    //             'prix' => $tarif->prix,
    //         ];
    //     });

    //     return response()->json([
    //         'tarifs' => $tarifs,
    //     ]);
    // }

    public function store(Request $request)
    {
        $data = $request->validate([
            'nom' => 'required|string|max:255',
            'train_id' => 'required|exists:trains,id',
            'ligne_id' => 'required|exists:lignes,id',
            'date_depart' => 'required|date',
            'date_arrivee' => 'required|date|after:date_depart',
            'statut' => 'required|in:programme,en_cours,terminé,annulé',
            // 'tarif_ids' => 'required|array|min:1',
            // 'tarif_ids.*' => 'exists:tarifs_gares,id',
        ]);

        $voyage = Voyage::create([
            'nom' => $data['nom'],
            'train_id' => $data['train_id'],
            'ligne_id' => $data['ligne_id'],
            'date_depart' => $data['date_depart'],
            'date_arrivee' => $data['date_arrivee'],
            'statut' => $data['statut'],
        ]);
        // $voyage->tarifs()->attach($data['tarif_ids']);

        return redirect()->route('voyage.index')->with('success', 'Voyage créé avec succès');
    }


    public function edit(Voyage $voyage): Response
    {
        return Inertia::render('Voyages/Edit', [
            'voyage' => $voyage->load([
                'ligne.arrets.gare',
                'depart.gare',
                'arrivee.gare',
                'train',
                'tarif.classeWagon',
                'tarif.gareDepart',
                'tarif.gareArrivee',
            ]),
            'trains' => Train::select('id', 'numero')->get(),
            'lignes' => Ligne::with(['arrets.gare'])->get(),
            'tarifs' => TarifsGare::with(['classeWagon', 'gareDepart', 'gareArrivee'])->active()->get(),
        ]);
    }

    public function update(Request $request, Voyage $voyage)
    {
        $validated = $request->validate([
            'nom' => ['required', 'string', 'max:255'],
            'train_id' => ['required', 'exists:trains,id'],
            'ligne_id' => ['required', 'exists:lignes,id'],
            'depart_id' => ['required', 'exists:arrets_ligne,id'],
            'arrivee_id' => ['required', 'exists:arrets_ligne,id'],
            'tarif_ids' => 'required|array|min:1',
            'tarif_ids.*' => 'exists:tarifs_gares,id',
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
