<?php

namespace App\Http\Controllers\Ventes;

use App\Models\Vente;
use App\Models\Voyage;
use App\Models\ModesPaiement;
use App\Models\Place;
use App\Models\PointsVente;
use App\Models\SystemSetting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;
use Exception;
use SalePriceCalculator;

class VenteController
{
    public function index(Request $request)
    {
        $search = trim($request->input('search'));
        $voyageId = $request->input('voyage_id');

        $voyages = Voyage::whereIn('statut', ['programme', 'en_cours'])->get();

        $ventes = Vente::filtrer($search, $voyageId)
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
            'voyages' => Voyage::with([
                'ligne.arrets.gare',
                'train.wagons.classeWagon',
                'ligne.gareDepart',
                'ligne.gareArrivee',
            ])->get(),
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
            'quantite' => 'required|integer|min:1|max:10',
            'bagage' => 'required|boolean',
            'poids_bagage' => 'nullable|numeric|min:0|max:30|required_if:bagage,true',
            'reference' => 'nullable|string|max:255|unique:ventes,reference',
            'statut' => 'required|in:payé,réservé',
        ]);

        DB::beginTransaction();

        try {
            $voyage = Voyage::with(['train.wagons.places', 'ligne'])->findOrFail($validated['voyage_id']);
            $train = $voyage->train;

            // Trouver une place libre dans un wagon (sans distinction de classe pour l'instant)
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
                return back()->withErrors(['place' => 'Aucune place disponible dans ce train.'])->withInput();
            }

            // Récupérer le paramètre système actif
            $setting = SystemSetting::first();
            if (!$setting) {
                return back()->withErrors(['system' => 'Configuration système introuvable.'])->withInput();
            }

            // Calcul du prix selon le mode de vente
            $prixFinal = 0;

            // Si on a un demi tarif, on appliquera plus tard sur le prix calculé
            $isDemi = $validated['demi_tarif'] ?? false;

            // Identifier les gares de départ / arrivée pour le calcul kilométrique
            $gareDepartId = $voyage->ligne->gare_depart_id;
            $gareArriveeId = $voyage->ligne->gare_arrivee_id;

            // Classe du wagon choisie
            $classeWagonId = $validated['classe_wagon_id'];

            if ($setting->mode_vente === 'par_kilometrage') {
                // Calcul par kilométrage : utilise SalePriceCalculator (à implémenter)
                $prixFinal = SalePriceCalculator::computePriceByKilometrage(
                    $gareDepartId,
                    $gareArriveeId,
                    $classeWagonId,
                    $setting
                );
            } else {
                // Mode par voyage : on essaie de trouver un tarif applicable entre ces deux gares pour la classe
                // En supposant que tu as un modèle TarifVoyage ou TarifGare selon structure
                $tarif = \App\Models\TarifsGare::where('gare_depart_id', $gareDepartId)
                    ->where('gare_arrivee_id', $gareArriveeId)
                    ->where('classe_wagon_id', $classeWagonId)
                    ->where('date_effet', '<=', now())
                    ->where(function ($q) {
                        $q->where('date_expiration', '>=', now())
                          ->orWhereNull('date_expiration');
                    })->first();

                $prixFinal = $tarif ? $tarif->prix : 0;
            }

            // Appliquer demi-tarif si pertinent
            if ($isDemi) {
                $prixFinal = $prixFinal / 2;
            }

            // Créer la vente avec le prix calculé (on trust le calcul, override si nécessaire)
            $vente = Vente::create([
                'client_nom' => $validated['client_nom'],
                'voyage_id' => $validated['voyage_id'],
                'mode_paiement_id' => $validated['mode_paiement_id'],
                'point_vente_id' => $validated['point_vente_id'],
                'place_id' => $placeLibre->id,
                'prix' => $prixFinal,
                'quantite' => $validated['quantite'],
                'bagage' => $validated['bagage'],
                'poids_bagage' => $validated['bagage'] ? ($validated['poids_bagage'] ?? 0) : 0,
                'classe_wagon_id' => $classeWagonId,
                'demi_tarif' => $isDemi,
                'statut' => $validated['statut'],
                'reference' => $validated['reference'] ?? null,
                'date_vente' => now(),
            ]);

            DB::commit();

            return Redirect::route('vente.index')
                ->with('success', 'Billet vendu avec succès !')
                ->with('vente_id', $vente->id);
        } catch (Exception $e) {
            DB::rollBack();
            return back()
                ->withInput()
                ->withErrors(['error' => $e->getMessage()]);
        }
    }

    public function show(Vente $vente)
    {
        $vente->load([
            'voyage.ligne.gareDepart',
            'voyage.ligne.gareArrivee',
            'voyage.train',
            'place.wagon.classeWagon',
            'modePaiement',
            'pointVente.gare',
            'classeWagon',
        ]);

        return Inertia::render('Ventes/Show', [
            'vente' => $vente,
        ]);
    }

    public function destroy(Vente $vente)
    {
        DB::transaction(function () use ($vente) {
            // Si des items liés existent
            if (method_exists($vente, 'items')) {
                $vente->items()->delete();
            }
            $vente->delete();
        });

        return Redirect::route('vente.index')
            ->with('success', 'Vente supprimée avec succès');
    }
}
