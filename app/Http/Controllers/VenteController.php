<?php

namespace App\Http\Controllers;

use App\Models\Place;
use App\Models\Train;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;
use App\Models\Vente;
use App\Models\VoyageRecurrent;
use App\Models\Voyage;

class VenteController extends Controller
{
    public function index(Request $request)
    {
        $search = trim($request->input('search'));
        $voyageId = $request->input('voyage_id');

        $voyages = Voyage::whereIn('statut', ['programmé', 'en_cours'])->get();

        $ventes = Vente::with(['voyage', 'train', 'place.wagon.train'])
            ->when($search, function ($query, $search) {
                $query->where('client_nom', 'like', "%{$search}%");
            })
            ->when($voyageId, function ($query, $voyageId) {
                $query->where('voyage_id', $voyageId);
            })
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
        $voyagesClassiques = Voyage::with(['gare_depart', 'gare_arrivee', 'train'])->get();
        $voyagesReccurents = VoyageRecurrent::with(['gare_depart', 'gare_arrivee', 'train'])->get();


        return Inertia::render('Ventes/Create', [
            'voyages' => $voyagesClassiques,
            'voyages_rec' => $voyagesReccurents,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'client_nom' => 'required|string|max:255',
            'voyage_id' => 'required|exists:voyages,id',
            'prix' => 'required|numeric|min:0',
            'quantite' => 'required|numeric|min:1',
            'bagage' => 'boolean',
            'poids_bagage' => 'nullable|numeric|min:0|required_if:bagage,true',
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
            return back()->withErrors(['place' => 'Aucune place disponible dans ce train.']);
        }

        Vente::create([
            'client_nom' => $validated['client_nom'],
            'voyage_id' => $validated['voyage_id'],
            'place_id' => $placeLibre->id,
            'prix' => $validated['prix'],
            'quantite' => $validated['quantite'],
            'bagage' => $validated['bagage'],
            'poids_bagage' => $validated['bagage'] ? $validated['poids_bagage'] : 0,
        ]);

        return Redirect::route('vente.index')->with('success', 'Billet vendu avec succès !');
    }

    public function show($id)
    {
        $items = Vente::with([
            'voyage.gare_depart',
            'voyage.gare_arrivee',
            'voyage.train',
            'place.wagon.train'
        ])->findOrFail($id);

        return Inertia::render('Ventes/Show', [
            'vente' => $items,
        ]);
    }

    public function edit($id)
    {
        $vente = Vente::with([
            'voyage.gare_depart',
            'voyage.gare_arrivee',
            'voyage.train',
            'place.wagon.train'
        ])->findOrFail($id);

        // Récupérer tous les voyages disponibles (réguliers et récurrents)
        $voyages = Voyage::whereIn('statut', ['programmé', 'en_cours'])
            ->with(['gare_depart', 'gare_arrivee', 'train'])
            ->get();

        $voyagesRecurrents = VoyageRecurrent::whereIn('statut', ['programmé', 'en_cours'])
            ->with(['gare_depart', 'gare_arrivee', 'train'])
            ->get();

        return Inertia::render('Ventes/Edit', [
            'ventes' => $vente,
            'voyages' => $voyages,
            'voyages_rec' => $voyagesRecurrents,
            'trainInfo' => $vente->voyage->train ?? null,
        ]);
    }

    public function update(Request $request, $id)
    {
        $vente = Vente::with(['voyage.train'])->findOrFail($id);

        $validated = $request->validate([
            'client_nom' => 'required|string|max:255',
            'voyage_id' => 'required|exists:voyages,id',
            'prix' => 'required|numeric|min:0',
            'quantite' => 'required|integer|min:1',
            'bagage' => 'boolean',
            'poids_bagage' => 'nullable|numeric|min:0|required_if:bagage,true',
            'place_id' => 'nullable|exists:places,id',
        ]);

        // Vérifier si le voyage a changé
        if ($vente->voyage_id != $validated['voyage_id']) {
            $newVoyage = Voyage::with('train.wagons.places')->findOrFail($validated['voyage_id']);

            // Trouver une nouvelle place disponible si nécessaire
            if (!$request->place_id) {
                $placeLibre = Place::whereIn('id', function ($query) use ($newVoyage) {
                    $query->select('places.id')
                        ->from('places')
                        ->join('wagons', 'places.wagon_id', '=', 'wagons.id')
                        ->whereIn('wagons.id', $newVoyage->train->wagons->pluck('id'))
                        ->whereNotIn('places.id', function ($sub) {
                            $sub->select('place_id')->from('ventes')->whereNotNull('place_id');
                        });
                })->first();

                if (!$placeLibre) {
                    return back()->withErrors([
                        'train_id' => 'Aucune place disponible dans le train associé à ce nouveau voyage'
                    ]);
                }

                $validated['place_id'] = $placeLibre->id;
            }
        }

        try {
            $vente->update([
                'client_nom' => $validated['client_nom'],
                'voyage_id' => $validated['voyage_id'],
                'prix' => $validated['prix'],
                'quantite' => $validated['quantite'],
                'bagage' => $validated['bagage'],
                'poids_bagage' => $validated['bagage'] ? $validated['poids_bagage'] : 0,
                'place_id' => $validated['place_id'] ?? $vente->place_id,
            ]);

            return redirect()->route('vente.index')
                ->with('success', 'Vente mise à jour avec succès');
        } catch (\Exception $e) {
            return back()->withErrors([
                'error' => 'Une erreur est survenue lors de la mise à jour: ' . $e->getMessage()
            ]);
        }
    }

    public function destroy(Vente $vente)
    {
        $vente->delete();
        return back()->with('success', 'Vente supprimée avec succès.');
    }
}
