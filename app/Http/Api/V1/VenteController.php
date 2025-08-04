<?php

namespace App\Http\Api\V1;
use Exception;
use App\Models\Place;
use App\Models\Vente;
use App\Models\Voyage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;
use App\Http\Resources\VenteResource;
use Illuminate\Support\Facades\Storage;
use SimpleSoftwareIO\QrCode\Facades\QrCode;


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


        
        return response()->json([
            'status' => true,
            'message' => 'Ventes récupérées avec succès',
            'data' => VenteResource::collection($ventes),
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
            } catch (Exception $e) {
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
    
            return response()->json([
                'status' => true,
                'message' => 'Billet vendu avec succès !',
                'data' => VenteResource::make($vente),
                'qrcode' => asset('storage/'.$qrPath)
            ]);
    
        } catch (\Illuminate\Validation\ValidationException $e) {
            DB::rollBack();
            Log::error('Erreur de validation', ['errors' => $e->errors()]);
            return response()->json([
                'status' => false,
                'message' => 'Erreur de validation',
                'errors' => $e->errors()
            ], 422);
    
        } catch (\Illuminate\Database\QueryException $e) {
            DB::rollBack();
            Log::error('Erreur base de données', [
                'error' => $e->getMessage(),
                'sql' => $e->getSql(),
                'bindings' => $e->getBindings()
            ]);
            return response()->json([
                'status' => false,
                'message' => 'Erreur de validation',
                'errors' => $e->getMessage()
            ], 422);
    
        } catch (Exception $e) {
            DB::rollBack();
            Log::error('Erreur inattendue', [
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString()
            ]);
            return response()->json([
                'status' => false,
                'message' => 'Erreur de validation',
                'errors' => $e->getMessage()
            ], 422);
        }
    }

    // public function store(Request $request)
    // {
    //     try {
    //         $validated = $request->validate([
    //             'client_nom' => 'required|string|max:255',
    //             'voyage_id' => 'required|exists:voyages,id',
    //             'mode_paiement_id' => 'required|exists:modes_paiement,id',
    //             'classe_wagon_id' => 'required|exists:classes_wagon,id',
    //             'point_vente_id' => 'required|exists:points_ventes,id',
    //             'demi_tarif' => 'boolean',
    //             'prix' => 'required|numeric|min:0',
    //             'quantite' => 'required|integer|min:1|max:10',
    //             'bagage' => 'required|boolean',
    //             'poids_bagage' => 'nullable|numeric|min:0|max:30|required_if:bagage,true',
    //             'statut' => 'required|in:payé,réservé',
    //         ]);
    
    //         $voyage = Voyage::with('train.wagons.places')->findOrFail($validated['voyage_id']);
    //         $train = $voyage->train;
    
    //         $placeLibre = Place::whereIn('id', function ($query) use ($train) {
    //             $query->select('places.id')
    //                 ->from('places')
    //                 ->join('wagons', 'places.wagon_id', '=', 'wagons.id')
    //                 ->whereIn('wagons.id', $train->wagons->pluck('id'))
    //                 ->whereNotIn('places.id', function ($sub) {
    //                     $sub->select('place_id')->from('ventes')->whereNotNull('place_id');
    //                 });
    //         })->first();
    
    //         if (!$placeLibre) {
    //             return response()->json([
    //                 'status' => false,
    //                 'message' => 'Aucune place disponible dans ce train.',
    //                 'errors' => ['place' => ['Aucune place disponible dans ce train.']]
    //             ], 422);
    //         }
    
    //         do {
    //             $reference = 'TICKET_'.strtoupper(uniqid()).'_'.rand(100, 999);
    //         } while (Vente::where('reference', $reference)->exists());
    
    //         $qrData = [
    //             'reference' => $reference,
    //             'client' => $validated['client_nom'],
    //             'voyage_id' => $validated['voyage_id'],
    //             'place_id' => $placeLibre->id,
    //             'date' => now()->toDateTimeString()
    //         ];
    
    //         $qrCode = QrCode::format('png')
    //             ->size(200)
    //             ->generate(json_encode($qrData));
        
    //         $qrPath = 'qrcodes/'.$reference.'.png';
    //         Storage::disk('public')->put($qrPath, $qrCode);

    //         $vente = Vente::create([
    //             'client_nom' => $validated['client_nom'],
    //             'voyage_id' => $validated['voyage_id'],
    //             'train_id' => $validated['train_id'],
    //             'gare_depart_id' => $validated['gare_depart_id'],
    //             'gare_arrivee_id' => $validated['gare_arrivee_id'],
    //             'mode_paiement_id' => $validated['mode_paiement_id'],
    //             'point_vente_id' => $validated['point_vente_id'],
    //             'place_id' => $placeLibre->id,
    //             'prix' => $validated['prix'],
    //             'quantite' => $validated['quantite'],
    //             'bagage' => $validated['bagage'],
    //             'poids_bagage' => $validated['bagage'] ? ($validated['poids_bagage'] ?? 0) : 0,
    //             'classe_wagon_id' => $validated['classe_wagon_id'],
    //             'demi_tarif' => $validated['demi_tarif'] ?? false,
    //             'statut' => $validated['statut'],
    //             'reference' => $reference,
    //             'qrcode' => $qrPath,
    //             'date_vente' => now(),
    //         ]);
    
    //         DB::commit();
    
    //         return response()->json([
    //             'status' => true,
    //             'message' => 'Billet vendu avec succès !',
    //             'data' => VenteResource::make($vente),
    //             'qrcode' => asset('storage/'.$qrPath)
    //         ]);
    
    //     } catch (\Illuminate\Validation\ValidationException $e) {
    //         // Gestion spécifique des erreurs de validation
    //         return response()->json([
    //             'status' => false,
    //             'message' => 'Erreur de validation',
    //             'errors' => $e->errors()
    //         ], 422);
            
    //     } catch (\Exception $e) {
    //         DB::rollBack();
    //         return response()->json([
    //             'status' => false,
    //             'message' => 'Erreur lors de la création du billet',
    //             'error' => $e->getMessage()
    //         ], 500);
    //     }
    // }


    // public function create()
    // {
    //     return Inertia::render('Ventes/Create', [
    //         'voyages' => Voyage::with(['tarifs.classeWagon', 'ligne.arrets.gare', 'train', 'ligne.gareDepart', 'ligne.gareArrivee'])->get(),
    //         'modesPaiement' => ModesPaiement::all(),
    //         'pointsVente' => PointsVente::with('gare')->get(),
    //     ]);
    // }



    // public function show($id)
    //     {
    //         $voyages = Voyage::with([
    //             'ligne.gareDepart',
    //             'ligne.gareArrivee',
    //             'train',
    //         ])->get();

    //         return Inertia::render('Ventes/Show', [
    //             'ventes' => $voyages,
    //         ]);
    //     }

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

    // public function destroy(Vente $vente)
    // {
    //     DB::transaction(function () use ($vente) {
    //         $vente->items()->delete();
    //         $vente->delete();
    //     });

    //     return redirect()
    //         ->route('vente.index')
    //         ->with('success', 'Vente supprimée avec succès');
    // }
}