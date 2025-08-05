<?php

namespace App\Http\Controllers\Ventes;

use App\Models\ClassesWagon;
use App\Models\Distance;
use App\Models\Gare;
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
use Illuminate\Support\Facades\Auth;

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
        $systemSettings = SystemSetting::first(); // ou via singleton
        if ($systemSettings?->mode_vente === 'par_kilometrage') {
            return redirect()->route('vente.create.kilometrage');
        }
        return redirect()->route('vente.create.predefined');
    }

    public function createPredefined()
    {
        $voyages = Voyage::with([
            'ligne.arrets.gare',
            'train.wagons.classeWagon',
            'ligne.gareDepart',
            'ligne.gareArrivee',
        ])
            ->get();
        $modesPaiement = ModesPaiement::all();
        $pointsVente = PointsVente::with('gare')->get();

        return Inertia::render('Ventes/SaleByPredefined', [
            'voyages' => $voyages,
            'modesPaiement' => $modesPaiement,
            'pointsVente' => $pointsVente,
            // autres props si besoin
        ]);
    }

    public function createKilometrage()
    {
        $voyages = Voyage::with([
            'ligne.arrets.gare',
            'train.wagons.classe',
            'ligne.gareDepart',
            'ligne.gareArrivee',
            ])
            ->get();
        $classeWagons = ClassesWagon::all();
        $gares = Gare::all();
        $modesPaiement = ModesPaiement::all();
        $pointsVente = PointsVente::with('gare')->get();
        $systemSettings = SystemSetting::first();
        $distance = Distance::all();

        return Inertia::render('Ventes/SaleByKilometrage', [
            'voyages' => $voyages,
            // 'arrets' => $voyages->flatMap(fn($v) => $v->ligne->arrets),
            'gares' => $gares,
            'classeWagons' => $classeWagons,
            'modesPaiement' => $modesPaiement,
            'pointsVente' => $pointsVente,
            'systemSettings' => $systemSettings,
            'distance' => $distance,
        ]);
    }

    public function store(Request $request)
    {

        $validated = $request->validate([
            'client_nom' => 'required|string|max:255',
            'voyage_id' => 'required|exists:voyages,id',
            'mode_paiement_id' => 'required|exists:modes_paiement,id',
            'point_vente_id' => 'required|exists:points_ventes,id',
            'classe_wagon_id' => 'required|exists:classes_wagon,id',
            // 'gare_depart_id' => 'required|exists:gares,id',
            // 'gare_arrivee_id' => 'required|exists:gares,id',
            // 'distance_km' => 'required|numeric|min:0',
            'quantite' => 'required|integer|min:1|max:10',
            'demi_tarif' => 'boolean',
            'prix' => 'required|numeric|min:0',
            'bagage' => 'boolean',
            'poids_bagage' => 'nullable|numeric|min:0|max:30|required_if:bagage,true',
            'statut' => 'required|in:payé,réservé',
            'reference' => 'required|string|unique:ventes,reference',
        ]);
        $user = Auth::user();

        $validated['created_by'] = $user->id;

        DB::beginTransaction();
        dd($validated);
        
        try {
            $voyage = Voyage::with(['train.wagons.places', 'ligne.arrets'])->findOrFail($validated['voyage_id']);
            $setting = SystemSetting::first();

            // Trouver une place libre dans un wagon de la classe sélectionnée
            $placeLibre = Place::whereIn('wagon_id', function ($query) use ($validated) {
                $query->select('id')
                    ->from('wagons')
                    ->where('classe_wagon_id', $validated['classe_wagon_id']);
            })
                ->whereNotIn('id', function ($query) {
                    $query->select('place_id')->from('ventes')->whereNotNull('place_id');
                })
                ->first();

            if (!$placeLibre) {
                return back()->withErrors(['place' => 'Aucune place disponible dans cette classe.'])->withInput();
            }

             $qrData = [
                'reference' => $reference,
                'client' => $validated['client_nom'],
                'voyage_id' => $validated['voyage_id'],
                'place_id' => $placeLibre->id,
                'date' => now()->toDateTimeString()
            ];
    
            $qrCode = QrCode::format('png')
                ->size(200)
                ->generate(json_encode($qrData));
        
            $qrPath = 'qrcodes/'.$reference.'.png';
            Storage::disk('public')->put($qrPath, $qrCode);
            

            // // Calcul du prix selon le mode de vente
            // $prixFinal = 0;
            // $isDemi = $validated['demi_tarif'] ?? false;


            // $voyage = Voyage::with(['ligne.arrets'])->findOrFail($validated['voyage_id']);
            // if ($setting->mode_vente === 'par_kilometrage') {
            //     $prixFinal = SalePriceCalculator::computePriceByKilometrage(
            //         $voyage->ligne,
            //         $voyage->ligne->gare_depart_id,
            //         $voyage->ligne->gare_arrivee_id,
            //         $validated['classe_wagon_id'],
            //         $setting,
            //     );
            // } else {
            //     // Mode par voyage - utiliser les tarifs prédéfinis
            //     $tarif = $voyage->tarifs()->where('classe_wagon_id', $validated['classe_wagon_id'])->first();

            //     if (!$tarif) {
            //         return back()->withErrors(['tarif' => 'Aucun tarif disponible pour cette classe.'])->withInput();
            //     }

            //     $prixFinal = $tarif->prix;
            // }

            // // Appliquer demi-tarif si pertinent
            // if ($isDemi) {
            //     $prixFinal = $prixFinal / 2;
            // }

            // // Calcul supplémentaire pour les bagages si nécessaire
            // if ($validated['bagage'] && $validated['poids_bagage'] > 0) {
            //     $prixFinal += self::calculateBaggagePrice($validated['poids_bagage']);
            // }

            $vente = Vente::create([
                'client_nom' => $validated['client_nom'],
                'voyage_id' => $validated['voyage_id'],
                'mode_paiement_id' => $validated['mode_paiement_id'],
                'point_vente_id' => $validated['point_vente_id'],
                'place_id' => $placeLibre->id,
                'prix' => $validated['prix'],
                'quantite' => $validated['quantite'],
                'bagage' => $validated['bagage'],
                'poids_bagage' => $validated['bagage'] ? $validated['poids_bagage'] : 0,
                'classe_wagon_id' => $validated['classe_wagon_id'],
                'gare_depart_id' => $validated['gare_depart_id'],
                'gare_arrivee_id' => $validated['gare_arrivee_id'],
                'distance_km' => $validated['distance_km'],
                'demi_tarif' => $validated['demi_tarif'],
                'statut' => $validated['statut'],
                'reference' => $validated['reference'],
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
                ->withErrors(['error' => 'Une erreur est survenue: ' . $e->getMessage()]);
        }
    }

    private static function calculateBaggagePrice(float $poids): float
    {
        // Implémentez votre logique de calcul des bagages ici
        // Par exemple : 500 FCFA par kg au-dessus de 10kg
        $poidsGratuit = 10;
        if ($poids <= $poidsGratuit) {
            return 0;
        }

        return ($poids - $poidsGratuit) * 500;
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
