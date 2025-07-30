<?php

namespace App\Http\Controllers\Ventes;

use App\Models\Vente;
use App\Models\Voyage;
use App\Models\ModesPaiement;
use App\Models\Place;
use App\Models\PointsVente;
use App\Models\TarifVoyage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class VenteController
{
    public function index(Request $request)
    {
        $search = trim($request->input('search'));
        $voyageId = $request->input('voyage_id');

        $voyages = Voyage::whereIn('statut', ['programmé', 'en_cours'])->get();

        $ventes = Vente::with(['voyage', 'train', 'place.wagon.train'])
            ->filtrer($search, $voyageId)
            ->latest()
            ->paginate(10)
            ->withQueryString();


        return Inertia::render('Ventes/Index', [
            'ventes' => $ventes,
            'voyages' => $voyages,
            'filters' => [
                'search' => $search,
                'voyage_id' => $voyageId,
            ],
        ]);
    }

    public function create()
    {
        return Inertia::render('Ventes/Create', [
            'voyages' => Voyage::with(['tarifs.classeWagon', 'ligne.arrets.gare', 'train', 'ligne.gareDepart', 'ligne.gareArrivee'])->get(),
            'modesPaiement' => ModesPaiement::all(),
            'pointsVente' => PointsVente::with('gare')->get(),
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'client_nom' => 'required|string|max:255',
            'voyage_id' => 'required|exists:voyages,id',
            'mode_paiement_id' => 'required|exists:modes_paiement,id',
            'classe_wagon_id' => 'required|exists:classes_wagon,id',
            'point_vente_id' => 'required|exists:points_ventes,id',
            'demi_tarif' => 'boolean',
            'prix' => 'required|numeric|min:0',
            'quantite' => 'required|integer|min:1|max:10', // Limite de 10 billets par transaction
            'bagage' => 'required|boolean',
            'poids_bagage' => 'nullable|numeric|min:0|max:30|required_if:bagage,true', // Max 30kg
            'statut' => 'required|in:payé,réservé',
        ]);

        // DB::beginTransaction();

        try {
        $voyage = Voyage::with('train.wagons.places')->findOrFail($validated['voyage_id']);
        $train = $voyage->train;

        $placeLibre = Place::whereIn('id', function ($query) use ($train) {
            $query->select('places.id')
                ->from('places')
                ->join('wagons', 'places.wagon_id', '=', 'wagons.id')
                ->whereIn('wagons.id', $train->wagons->pluck('id'))
                ->whereNotIn('places.id', function ($sub) {
                    $sub->select('place_id')->from('ventes')->whereNotNull('place_id');
                });
        })->first();

        if (!$placeLibre) {
            return back()->withErrors(['place' => 'Aucune place disponible dans ce train.']);
        }
            // Création de la vente
            $vente = Vente::create([
                'client_nom' => $validated['client_nom'],
                'voyage_id' => $validated['voyage_id'],
                'mode_paiement_id' => $validated['mode_paiement_id'],
                'point_vente_id' => $validated['point_vente_id'],
                'place_id' => $placeLibre->id,
                'prix' => $validated['prix'],
                'quantite' => $validated['quantite'],
                'bagage' => $validated['bagage'],
                'poids_bagage' => $validated['bagage'] ? ($validated['poids_bagage'] ?? 0) : 0,
                'classe_wagon_id' => $validated['classe_wagon_id'],
                'demi_tarif' => $validated['demi_tarif'] ?? false,
                'statut' => $validated['statut'],
                'date_vente' => now(),
            ]);

            DB::commit();

            return redirect()
                ->route('vente.index')
                ->with('success', 'Billet vendu avec succès !')
                ->with('vente_id', $vente->id);
        } catch (\Exception $e) {
            DB::rollBack();
            return back()
                ->withInput()
                ->withErrors(['error' => $e->getMessage()]);
        }
    }



 public function show($id)
    {
        $voyages = Voyage::with([
            'ligne.gareDepart',
            'ligne.gareArrivee',
            'train',
        ])->get();

        return Inertia::render('Ventes/Show', [
            'ventes' => $voyages,
        ]);
    }

    // public function edit(Vente $vente)
    // {
    //     $vente->load($this->getVenteRelations());

    //     return Inertia::render('Ventes/Edit', [
    //         'vente' => $vente,
    //         'voyages' => Voyage::with(['ligne.arrets.gare', 'train'])->get(),
    //         'modesPaiement' => ModesPaiement::all(),
    //         'pointsVente' => PointsVente::with('gare')->get(),
    //         'tarifs' => TarifVoyage::with(['tarifGare.classeWagon', 'tarifGare.gareDepart', 'tarifGare.gareArrivee'])->get()
    //     ]);
    // }

    // public function update(Request $request, Vente $vente)
    // {
    //     $validated = $this->validateVenteRequest($request, true);

    //     DB::beginTransaction();

    //     try {
    //         $this->updateVente($vente, $validated);
    //         $this->syncVenteItems($vente, $validated['items']);

    //         DB::commit();

    //         return redirect()
    //             ->route('vente.show', $vente->id)
    //             ->with('success', 'Vente mise à jour avec succès');
    //     } catch (\Exception $e) {
    //         DB::rollBack();
    //         return back()
    //             ->with('error', 'Erreur lors de la mise à jour: ' . $e->getMessage());
    //     }
    // }

    public function destroy(Vente $vente)
    {
        DB::transaction(function () use ($vente) {
            $vente->items()->delete();
            $vente->delete();
        });

        return redirect()
            ->route('vente.index')
            ->with('success', 'Vente supprimée avec succès');
    }
}
