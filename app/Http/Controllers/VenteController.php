<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Trains;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;
use App\Models\Ventes;
use App\Models\Voyages;


class VenteController extends Controller
{
    //
    public function index(Request $request)
    {
        $search = trim($request->input('search'));
        $voyageId = $request->input('voyage_id');

        $voyages = Voyages::where('statut', ['programmé', 'en_cours'])->get(); // Utilise le bon modèle

        $ventes = Ventes::with(['voyage', 'train'])
            ->when($search, function ($query, $search) {
                $query->where('client_nom', 'like', "%{$search}%");
            })
            ->when($voyageId, function ($query, $voyageId) {
                $query->where('voyage_id', $voyageId);
            })
            ->latest() // équivalent à orderBy('created_at', 'desc')
            ->paginate(10)
            ->withQueryString(); // conserve les paramètres dans l'URL

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
        $voyage = Voyages::all();
        $train = Trains::all();
        return Inertia::render('Ventes/Create', [
            'voyages' => $voyage,
            'trains' => $train
        ]);
    }
    public function store(Request $request)
    {
        // Validation
        $validated = $request->validate([
            'client_nom' => 'required|string|max:255',
            'voyage_id' => 'required|exists:voyages,id',
            'train_id' => 'required|exists:trains,id',
            'prix' => 'required|numeric|min:0',
            'bagage' => 'boolean',
            'poids_bagage' => 'nullable|numeric|min:0|required_if:bagage,true',
        ]);

        // Récupération du train
        $train = Trains::findOrFail($request->train_id);

        // Compter le nombre de billets déjà vendus pour ce train et ce voyage
        $ventesCount = Ventes::where('train_id', $train->id)
            ->where('voyage_id', $request->voyage_id)
            ->count();

        // Vérifier la capacité
        if ($ventesCount >= $train->capacite) {
            return back()->withErrors(['train_id' => 'La capacité maximale du train est atteinte pour ce voyage.']);
        }

        // Création de la vente
        Ventes::create([
            'client_nom' => $validated['client_nom'],
            'voyage_id' => $validated['voyage_id'],
            'train_id' => $validated['train_id'],
            'prix' => $validated['prix'],
            'bagage' => $validated['bagage'],
            'poids_bagage' => $validated['bagage'] ? $validated['poids_bagage'] : 0,
        ]);

        // Retour avec succès
        return Redirect::route('vente.index')->with('success', 'Billet vendu avec succès !');
    }

    public function show($id)
    {
        $items = Ventes::with(['voyage', 'train'])->findOrFail($id);
        return Inertia::render('Ventes/Show', props: [
            'vente' => $items,
        ]);
    }

    // Afficher le formulaire d'édition
    public function edit($id)
    {
        $items = Ventes::findOrFail($id);
        $voyage = Voyages::all();
        $train = Trains::all();
        return Inertia::render('Ventes/Edit', [
            'ventes' => $items,
            'voyages' => $voyage,
            'trains' => $train
        ]);
    }

    public function update(Request $request, $id)
    {
        $vente = Ventes::findOrFail($id);
        // Validation
        $validated = $request->validate([
            'client_nom' => 'required|string|max:255',
            'voyage_id' => 'required|exists:voyages,id',
            'train_id' => 'required|exists:trains,id',
            'prix' => 'required|numeric|min:0',
            'bagage' => 'boolean',
            'poids_bagage' => 'nullable|numeric|min:0|required_if:bagage,true',
        ]);

        // Modification de la vente
        $vente->update([
            'client_nom' => $validated['client_nom'],
            'voyage_id' => $validated['voyage_id'],
            'train_id' => $validated['train_id'],
            'prix' => $validated['prix'],
            'bagage' => $validated['bagage'],
            'poids_bagage' => $validated['bagage'] ? $validated['poids_bagage'] : 0,
        ]);

        // Retour avec succès
        return redirect()->route('vente.index')->with('success', 'Modification effectuée avec succès');
    }
    public function destroy($id)
    {
        $items = Ventes::find($id);
        $items->delete();

        return redirect()->route('vente.index')->with('success', 'Suppression effectué avec succes.');
    }
}
