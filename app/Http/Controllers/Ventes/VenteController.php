<?php

namespace App\Http\Controllers\Ventes;

use Exception;
use App\Models\Gare;
use Inertia\Inertia;
use App\Models\Place;
use App\Models\Vente;
use App\Models\Voyage;
use App\Models\Distance;
use SalePriceCalculator;
use App\Models\PointsVente;
use App\Models\ClassesWagon;
use Illuminate\Http\Request;
use App\Models\ModesPaiement;
use App\Models\SystemSetting;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Redirect;
use SimpleSoftwareIO\QrCode\Facades\QrCode;
use Illuminate\Validation\ValidationException;
use Illuminate\Database\Eloquent\ModelNotFoundException;


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
        'train.wagons.classeWagon', // Correction du nom de la relation
        'ligne.gareDepart',
        'ligne.gareArrivee',
        'tarifs.classeWagon' // Chargement explicite des tarifs
    ])->get();

    $modesPaiement = ModesPaiement::all();
    $pointsVente = PointsVente::with('gare')->get();

    return Inertia::render('Ventes/SaleByPredefined', [
        'voyages' => $voyages->map(function ($voyage) {
            return [
                ...$voyage->toArray(),
                'tarifs' => $voyage->tarifs->map(function ($tarif) {
                    return [
                        'id' => $tarif->id,
                        'prix' => $tarif->prix,
                        'classe_wagon_id' => $tarif->classe_wagon_id,
                        'classe_wagon' => $tarif->classeWagon
                    ];
                })
            ];
        }),
        'modesPaiement' => $modesPaiement,
        'pointsVente' => $pointsVente,
    ]);
}

    public function createKilometrage()
    {
        $voyages = Voyage::with([
            'ligne.arrets.gare',
            'train.wagons.classeWagon',
            'ligne.gareDepart',
            'ligne.gareArrivee',
        ])
            ->get();
        $classeWagons = ClassesWagon::all();
        $gares = Gare::all();
        $modesPaiement = ModesPaiement::all();
        $pointsVente = PointsVente::with('gare')->get();
        $systemSettings = SystemSetting::first();

        return Inertia::render('Ventes/SaleByKilometrage', [
            'voyages' => $voyages,
            // 'arrets' => $voyages->flatMap(fn($v) => $v->ligne->arrets),
            'gares' => $gares,
            'classeWagons' => $classeWagons,
            'modesPaiement' => $modesPaiement,
            'pointsVente' => $pointsVente,
            'systemSettings' => $systemSettings,
        ]);
    }

    public function store(Request $request)
    {
        // Validation des données
        $validated = $request->validate([
            'client_nom' => 'required|string|max:255',
            'voyage_id' => 'required|exists:voyages,id',
            'mode_paiement_id' => 'required|exists:modes_paiement,id',
            'point_vente_id' => 'required|exists:points_ventes,id',
            'classe_wagon_id' => 'required|exists:classes_wagon,id',
            'quantite' => 'required|integer|min:1|max:10',
            'demi_tarif' => 'boolean',
            'prix' => 'required|numeric|min:0',
            'bagage' => 'boolean',
            'poids_bagage' => 'nullable|numeric|min:0|max:30|required_if:bagage,true',
            'statut' => 'required|in:payé,réservé',
        ]);
    
        $user = Auth::user();
        $validated['created_by'] = $user->id;
    
        DB::beginTransaction();
    
        try {
            // Log de début de transaction
            Log::info('Début de la création de vente', [
                'user_id' => $user->id,
                'input_data' => $validated
            ]);
    
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
                Log::warning('Aucune place disponible', ['voyage_id' => $validated['voyage_id']]);
                return back()->withErrors(['place' => 'Aucune place disponible dans ce train.']);
            }
    
            // Génération de référence
            do {
                $reference = 'TICKET_'.strtoupper(string: uniqid()).'_'.rand(100, 999);
            } while (Vente::where('reference', operator: $reference)->exists());
    
            // Tentative de génération du QR code
            try {
                $qrData = [
                    'reference' => $reference,
                    // 'client' => $validated['client_nom'],
                    // 'voyage_id' => $validated['voyage_id'],
                    // 'place_id' => $placeLibre->id,
                    // 'date' => now()->toDateTimeString()
                ];
    
                $qrCode = QrCode::format('svg') // Utilisation de SVG comme fallback
                    ->size(200)
                    ->generate(json_encode($qrData));
    
                $qrPath = 'qrcodes/'.$reference.'.svg';
                Storage::disk('public')->put($qrPath, $qrCode);
            } catch (\Exception $e) {
                Log::error('Erreur génération QR Code', [
                    'error' => $e->getMessage(),
                    'reference' => $reference,
                    'qr_data' => $qrData ?? null
                ]);
                $qrPath = null;
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
                'poids_bagage' => $validated['bagage'] ? $validated['poids_bagage'] : 0,
                'classe_wagon_id' => $validated['classe_wagon_id'],
                'demi_tarif' => $validated['demi_tarif'],
                'statut' => $validated['statut'],
                'reference' => $reference,
                'qrcode' => $qrPath ?? null,
                'date_vente' => now(),
                'created_by' => $user->id,
            ]);
    
            DB::commit();
    
            Log::info('Vente créée avec succès', ['vente_id' => $vente->id]);
    
            return Redirect::route('vente.index')
                ->with('success', 'Billet vendu avec succès !')
                ->with('vente_id', $vente->id);
    
        } catch (\Illuminate\Validation\ValidationException $e) {
            DB::rollBack();
            Log::error('Erreur de validation', ['errors' => $e->errors()]);
            return back()->withErrors($e->errors())->withInput();
    
        } catch (\Illuminate\Database\QueryException $e) {
            DB::rollBack();
            Log::error('Erreur base de données', [
                'error' => $e->getMessage(),
                'sql' => $e->getSql(),
                'bindings' => $e->getBindings()
            ]);
            return back()->withInput()->withErrors(['error' => 'Erreur base de données']);
    
        } catch (Exception $e) {
            DB::rollBack();
            Log::error('Erreur inattendue', [
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString()
            ]);
            return back()->withInput()->withErrors(['error' => 'Une erreur inattendue est survenue']);
        }
    }

//     public function store(Request $request)
//     {
//         // dd($request);

//         $validated = $request->validate([
//             'client_nom' => 'required|string|max:255',
//             'voyage_id' => 'required|exists:voyages,id',
//             'mode_paiement_id' => 'required|exists:modes_paiement,id',
//             'point_vente_id' => 'required|exists:points_ventes,id',
//             'classe_wagon_id' => 'required|exists:classes_wagon,id',
//             'quantite' => 'required|integer|min:1|max:10',
//             'demi_tarif' => 'boolean',
//             'prix' => 'required|numeric|min:0',
//             'bagage' => 'boolean',
//             'poids_bagage' => 'nullable|numeric|min:0|max:30|required_if:bagage,true',
//             'statut' => 'required|in:payé,réservé',
//         ]);
//         $user = Auth::user();

//         $validated['created_by'] = $user->id;


//         DB::beginTransaction();

//         try {
//              $voyage = Voyage::with('train.wagons.places')->findOrFail($validated['voyage_id']);
//         $train = $voyage->train;

//         $placeLibre = Place::whereIn('id', function ($query) use ($train) {
//             $query->select('places.id')
//                 ->from('places')
//                 ->join('wagons', 'places.wagon_id', '=', 'wagons.id')
//                 ->whereIn('wagons.id', $train->wagons->pluck('id'))
//                 ->whereNotIn('places.id', function ($sub) {
//                     $sub->select('place_id')->from('ventes')->whereNotNull('place_id');
//                 });
//             })->first();

//             if (!$placeLibre) {
//                 return back()->withErrors(['place' => 'Aucune place disponible dans ce train.']);
//             }



//             // QR Code
//            do {
//                 $reference = 'TICKET_'.strtoupper(uniqid()).'_'.rand(100, 999);
//             } while (Vente::where('reference', $reference)->exists());

// //           try {
// //     $qrData = [
// //         'reference' => $reference,
// //         'client' => $validated['client_nom'],
// //         'voyage_id' => $validated['voyage_id'],
// //         'place_id' => $placeLibre->id,
// //         'date' => now()->toDateTimeString()
// //     ];

// //     $qrCode = \QrCode::format('png')
// //         ->size(200)
// //         ->generate(json_encode($qrData));

// //     $qrPath = 'qrcodes/' . $reference . '.png';

// //     \Storage::disk('public')->put($qrPath, $qrCode);

// // } catch (\Exception $e) {
// //     \Log::error('Erreur lors de la génération du QR code : ' . $e->getMessage(), [
// //         'reference' => $reference ?? null,
// //         'validated' => $validated ?? null,
// //         'qrData' => $qrData ?? null,
// //     ]);

// //     // Tu peux aussi afficher une erreur à l'utilisateur ou faire un redirect avec message
// //     return back()->with('error', 'Une erreur est survenue lors de la génération du billet.');
// // }
// // dd($validated);

//             // // Calcul du prix selon le mode de vente
//             // $prixFinal = 0;
//             // $isDemi = $validated['demi_tarif'] ?? false;


//             // $voyage = Voyage::with(['ligne.arrets'])->findOrFail($validated['voyage_id']);
//             // if ($setting->mode_vente === 'par_kilometrage') {
//             //     $prixFinal = SalePriceCalculator::computePriceByKilometrage(
//             //         $voyage->ligne,
//             //         $voyage->ligne->gare_depart_id,
//             //         $voyage->ligne->gare_arrivee_id,
//             //         $validated['classe_wagon_id'],
//             //         $setting,
//             //     );
//             // } else {
//             //     // Mode par voyage - utiliser les tarifs prédéfinis
//             //     $tarif = $voyage->tarifs()->where('classe_wagon_id', $validated['classe_wagon_id'])->first();

//             //     if (!$tarif) {
//             //         return back()->withErrors(['tarif' => 'Aucun tarif disponible pour cette classe.'])->withInput();
//             //     }

//             //     $prixFinal = $tarif->prix;
//             // }

//             // // Appliquer demi-tarif si pertinent
//             // if ($isDemi) {
//             //     $prixFinal = $prixFinal / 2;
//             // }

//             // // Calcul supplémentaire pour les bagages si nécessaire
//             // if ($validated['bagage'] && $validated['poids_bagage'] > 0) {
//             //     $prixFinal += self::calculateBaggagePrice($validated['poids_bagage']);
//             // }

//             $vente = Vente::create([
//                 'client_nom' => $validated['client_nom'],
//                 'voyage_id' => $validated['voyage_id'],
//                 'mode_paiement_id' => $validated['mode_paiement_id'],
//                 'point_vente_id' => $validated['point_vente_id'],
//                 'place_id' => $placeLibre->id,
//                 'prix' => $validated['prix'],
//                 'quantite' => $validated['quantite'],
//                 'bagage' => $validated['bagage'],
//                 'poids_bagage' => $validated['bagage'] ? $validated['poids_bagage'] : 0,
//                 'classe_wagon_id' => $validated['classe_wagon_id'],
//                 'demi_tarif' => $validated['demi_tarif'],
//                 'statut' => $validated['statut'],
//                 'reference' => $reference,
//                 // 'qrcode' => $qrPath,
//                 'date_vente' => now(),
//                 'created_by' => $user->id,
//             ]);

//             DB::commit();

//             return Redirect::route('vente.index')
//                 ->with('success', 'Billet vendu avec succès !')
//                 ->with('vente_id', $vente->id);
//         } catch (Exception $e) {
//             DB::rollBack();
//             return back()
//                 ->withInput()
//                 ->withErrors(['error' => 'Une erreur est survenue: ' . $e->getMessage()]);
//         }
//     }

    // private static function calculateBaggagePrice(float $poids): float
    // {
    //     // Implémentez votre logique de calcul des bagages ici
    //     // Par exemple : 500 FCFA par kg au-dessus de 10kg
    //     $poidsGratuit = 10;
    //     if ($poids <= $poidsGratuit) {
    //         return 0;
    //     }

    //     return ($poids - $poidsGratuit) * 500;
    // }

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