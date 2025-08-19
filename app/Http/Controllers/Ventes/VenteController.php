<?php

namespace App\Http\Controllers\Ventes;

use App\Models\ClassesWagon;
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
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use SimpleSoftwareIO\QrCode\Facades\QrCode;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class VenteController
{
    use AuthorizesRequests;
    public function index(Request $request)
    {
        $this->authorize('viewAny vente');
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

    protected function calculateAvailableSeats(Voyage $voyage)
    {
        $placesOccupees = $voyage->ventes->pluck('place_id')->filter();

        return $voyage->train->wagons->groupBy('classe_id')
            ->map(function ($wagons, $classeId) use ($placesOccupees) {
                $totalPlaces = $wagons->sum(function ($wagon) {
                    return $wagon->places->count();
                });

                $placesOccupeesClasse = $placesOccupees->filter(function ($placeId) use ($wagons) {
                    return $wagons->pluck('places.*.id')->flatten()->contains($placeId);
                })->count();

                return $totalPlaces - $placesOccupeesClasse;
            });
    }

    public function create()
    {
        $this->authorize('create vente');
        $systemSettings = SystemSetting::first(); // ou via singleton
        if ($systemSettings?->mode_vente === 'par_kilometrage') {
            return redirect()->route('vente.create.kilometrage');
        }
        return redirect()->route('vente.create.predefined');
    }

    public function createPredefined()
    {
        $this->authorize('create vente');
        $this->authorize('createPredefined vente');

        $voyages = Voyage::with([
            'ligne.arrets.gare',
            'train.wagons.classeWagon',
            'train.wagons.places', // Charger les places
            'ligne.gareDepart',
            'ligne.gareArrivee',
            'tarifs.classeWagon',
            'ventes.place' // Charger les ventes avec leurs places
        ])
            ->whereNotIn('statut', ['terminé', 'annulé'])
            ->get()
            ->map(function ($voyage) {
                // Calcul des places disponibles par classe
                $placesParClasse = $this->calculateAvailableSeats($voyage);

                return [
                    ...$voyage->toArray(),
                    'places_par_classe' => $placesParClasse,
                    'tarifs' => $voyage->tarifs->map(function ($tarif) use ($placesParClasse) {
                        $disponibles = $placesParClasse[$tarif->classe_wagon_id] ?? 0;

                        return [
                            'id' => $tarif->id,
                            'prix' => $tarif->prix,
                            'classe_wagon_id' => $tarif->classe_wagon_id,
                            'classe_wagon' => $tarif->classeWagon,
                            'places_disponibles' => $disponibles
                        ];
                    })
                ];
            });

        $modesPaiement = ModesPaiement::all();
        $pointsVente = PointsVente::with('gare')->get();

        return Inertia::render('Ventes/SaleByPredefined', [
            'voyages' => $voyages,
            'modesPaiement' => $modesPaiement,
            'pointsVente' => $pointsVente,
        ]);
    }

    public function createKilometrage()
    {
        $this->authorize('create vente');
        $this->authorize('createKilometrage vente');

        $voyages = Voyage::with([
            'ligne.arrets.gare',
            'train.wagons.classeWagon',
            'train.wagons.places', // Charger les places
            'ligne.gareDepart',
            'ligne.gareArrivee',
            'tarifs.classeWagon',
            'ventes.place' // Charger les ventes avec leurs places
        ])
            ->whereNotIn('statut', ['terminé', 'annulé'])
            ->get()
            ->map(function ($voyage) {
                // Calcul des places disponibles par classe
                $placesParClasse = $this->calculateAvailableSeats($voyage);

                return [
                    ...$voyage->toArray(),
                    'places_par_classe' => $placesParClasse,
                    'tarifs' => $voyage->tarifs->map(function ($tarif) use ($placesParClasse) {
                        $disponibles = $placesParClasse[$tarif->classe_wagon_id] ?? 0;

                        return [
                            'id' => $tarif->id,
                            'prix' => $tarif->prix,
                            'classe_wagon_id' => $tarif->classe_wagon_id,
                            'classe_wagon' => $tarif->classeWagon,
                            'places_disponibles' => $disponibles
                        ];
                    })
                ];
            });
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
        $this->authorize('create vente');

        // Validation des données
        $validated = $request->validate([
            'client_nom' => 'nullable|string|max:255',
            'voyage_id' => 'required|exists:voyages,id',
            'mode_paiement_id' => 'required|exists:modes_paiement,id',
            'point_vente_id' => 'required|exists:points_ventes,id',
            'classe_wagon_id' => 'required|exists:classes_wagon,id',
            'quantite' => 'required|integer|min:1|max:10',
            'quantite_demi_tarif' => 'nullable|integer',
            'demi_tarif' => 'boolean',
            'prix' => 'required|numeric|min:0',
            'bagage' => 'boolean',
            'poids_bagage' => 'nullable|numeric|min:0|max:30|required_if:bagage,true',
            'penalite' => 'boolean',
            'statut' => 'required|in:payé,réservé',
        ]);

        DB::beginTransaction();

        try {
            $user = Auth::user();
            $voyage = Voyage::with(['train.wagons' => function ($query) use ($validated) {
                $query->where('classe_id', $validated['classe_wagon_id']);
            }])->findOrFail($validated['voyage_id']);

            // Vérification des places disponibles
            $placeLibre = Place::whereHas('wagon', function ($query) use ($voyage, $validated) {
                $query->where('train_id', $voyage->train_id)
                    ->where('classe_id', $validated['classe_wagon_id']);
            })
                ->whereDoesntHave('ventes', function ($query) use ($voyage) {
                    $query->where('voyage_id', $voyage->id);
                })
                ->first();

            if ($placeLibre->count() < $validated['quantite']) {
                return back()
                    ->withErrors(['place' => 'Pas assez de places disponibles pour cette classe.'])
                    ->withInput();
            }

            if (!$placeLibre) {
                Log::warning('Aucune place disponible', [
                    'voyage_id' => $validated['voyage_id'],
                    'classe_id' => $validated['classe_wagon_id']
                ]);
                return back()
                    ->withErrors(['place' => 'Aucune place disponible pour cette classe.'])
                    ->withInput();
            }

            // Génération de référence unique
            $reference = 'TKT_' . strtoupper(uniqid()) . '_' . rand(100, 999);
            while (Vente::where('reference', $reference)->exists()) {
                $reference = 'TKT_' . strtoupper(uniqid()) . '_' . rand(100, 999);
            }

            // Génération QR Code
            $qrPath = null;
            try {
                $qrData = [
                    'reference' => $reference,
                    'voyage_id' => $voyage->id,
                    'client' => $validated['client_nom']
                ];

                $qrCode = QrCode::format('svg')
                    ->size(200)
                    ->generate(json_encode($qrData));

                $qrPath = 'qrcodes/' . $reference . '.svg';
                Storage::disk('public')->put($qrPath, $qrCode);
            } catch (\Exception $e) {
                Log::error('Erreur génération QR Code', [
                    'error' => $e->getMessage(),
                    'reference' => $reference
                ]);
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
                'quantite_demi_tarif' => $validated['quantite_demi_tarif'],
                'bagage' => $validated['bagage'],
                'poids_bagage' => $validated['bagage'] ? $validated['poids_bagage'] : null,
                'classe_wagon_id' => $validated['classe_wagon_id'],
                'demi_tarif' => $validated['demi_tarif'],
                'statut' => $validated['statut'],
                'penalite' => $validated['penalite'],
                'reference' => $reference,
                'qrcode' => $qrPath,
                'date_vente' => now(),
                'created_by' => $user->id,
            ]);

            DB::commit();

            Log::info('Vente créée avec succès', [
                'vente_id' => $vente->id,
                'reference' => $reference
            ]);

            return redirect()->route('vente.show', $vente->id)
                ->with('success', 'Billet vendu avec succès !');
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Erreur lors de la création de vente', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return back()
                ->withInput()
                ->withErrors(['error' => 'Une erreur est survenue lors de la création.']);
        }
    }

    public function show($id)
    {
        $vente = Vente::with([
            'voyage.gareDepart',
            'voyage.gareArrivee',
            'voyage.train',
            'place.wagon.classeWagon',
            'modePaiement',
            'pointVente.gare',
            'classeWagon',
            'creator'
        ])->findOrFail($id);

        // Debug: Vérifiez les données chargées
        logger('Vente data:', [
            'mode_paiement' => optional($vente->modePaiement)->type,
            'point_vente' => optional($vente->pointVente)->nom,
            'gare' => optional($vente->pointVente?->gare)->nom
        ]);

        return Inertia::render('Ventes/Show', [
            'vente' => $vente,
            'qrcode_url' => $vente->qrcode ? asset('storage/' . $vente->qrcode) : null,
        ]);
    }

    public function destroy(Vente $vente)
    {
        $this->authorize('delete vente');
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
