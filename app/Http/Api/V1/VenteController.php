<?php

namespace App\Http\Api\V1;
use App\Models\Place;
use App\Models\Vente;
use App\Models\Voyage;
use Illuminate\Http\Request;
use App\Http\Resources\VenteResource;
use Illuminate\Support\Facades\DB;
use SimpleSoftwareIO\QrCode\Facades\QrCode;
use Illuminate\Support\Facades\Storage;


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
        $validated = $request->validate([
            'client_nom' => 'required|string|max:255',
            'voyage_id' => 'required|exists:voyages,id',
            'mode_paiement_id' => 'required|exists:modes_paiement,id',
            'classe_wagon_id' => 'required|exists:classes_wagon,id',
            'point_vente_id' => 'required|exists:points_ventes,id',
            'demi_tarif' => 'boolean',
            'prix' => 'required|numeric|min:0',
            'quantite' => 'required|integer|min:1|max:10',
            'bagage' => 'required|boolean',
            'poids_bagage' => 'nullable|numeric|min:0|max:30|required_if:bagage,true',
            'reference' => 'nullable|string|max:255|unique:ventes,reference',
            'statut' => 'required|in:payé,réservé',
        ]);
    
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
    
            // Générer une référence si elle n'existe pas
            $reference = $validated['reference'] ?? uniqid('TICKET_');
    
            // Données à encoder dans le QR code
            $qrData = [
                'reference' => $reference,
                'client' => $validated['client_nom'],
                'voyage_id' => $validated['voyage_id'],
                'place_id' => $placeLibre->id,
                'date' => now()->toDateTimeString()
            ];
    
            // Générer le QR code
            $qrCode = QrCode::format('png')
                ->size(200)
                ->generate(json_encode($qrData));
    
            // Sauvegarder le QR code
            $qrPath = 'qrcodes/'.$reference.'.png';
            Storage::disk('public')->put($qrPath, $qrCode);
    
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
                'reference' => $reference,
                'qrcode' => $qrPath, // Ajout du chemin du QR code
                'date_vente' => now(),
            ]);
    
            DB::commit();
    
            return response()->json([
                'status' => true,
                'message' => 'Billet vendu avec succès !',
                'data' => VenteResource::make($vente),
                'qrcode' => asset('storage/'.$qrPath) // URL du QR code
            ]);
    
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => false,
                'message' => 'Erreur de la creation de billet',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}