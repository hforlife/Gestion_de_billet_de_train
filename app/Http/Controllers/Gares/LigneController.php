<?php

namespace App\Http\Controllers\Gares;

use App\Models\Ligne;
use App\Models\Gare;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class LigneController
{
    use AuthorizesRequests;
    public function index(Request $request): Response
    {
        $this->authorize('viewAny ligne');
        $filters = $request->only(['search']);

        return Inertia::render('Lignes/Index', [
            'filters' => $filters,
            'lignes' => Ligne::with(['gareDepart', 'gareArrivee'])
                ->orderBy('nom')
                ->when($filters['search'] ?? null, function ($query, $search) {
                    $query->where('nom', 'like', '%' . $search . '%')
                        ->orWhereHas('gareDepart', function ($q) use ($search) {
                            $q->where('nom', 'like', '%' . $search . '%');
                        })
                        ->orWhereHas('gareArrivee', function ($q) use ($search) {
                            $q->where('nom', 'like', '%' . $search . '%');
                        });
                })
                ->paginate(10)
                ->withQueryString()
                ->through(fn($ligne) => [
                    'id' => $ligne->id,
                    'nom' => $ligne->nom,
                    'gare_depart' => $ligne->gareDepart->nom,
                    'gare_arrivee' => $ligne->gareArrivee->nom,
                    'distance_totale' => $ligne->distance_totale . ' km',
                ]),
        ]);
    }

    public function create(): Response
    {
        $this->authorize('create ligne');
        return Inertia::render('Lignes/Create', [
            'gares' => Gare::all()->map->only('id', 'nom'),
        ]);
    }

    public function store(Request $request)
    {
        $this->authorize('create ligne');
        $validated = $request->validate([
            'nom' => ['required', 'string', 'max:255'],
            'gare_depart_id' => ['required', 'exists:gares,id'],
            'gare_arrivee_id' => ['required', 'exists:gares,id', 'different:gare_depart_id'],
            'distance_totale' => ['required', 'numeric', 'min:1'],
            'arrets' => 'array',
            'arrets.*.gare_id' => 'required|exists:gares,id|distinct',
            'arrets.*.distance_depart' => 'required|numeric|min:0',
        ]);

        // Exclure les arrêts du tableau
        $arrets = $validated['arrets'] ?? [];
        unset($validated['arrets']);

        // Créer la ligne sans les arrêts
        $ligne = Ligne::create($validated);

        // Ajouter les arrêts s'ils existent
        foreach ($arrets as $index => $arret) {
            $ligne->arrets()->create([
                'gare_id' => $arret['gare_id'],
                'distance_depart' => $arret['distance_depart'],
                'ordre' => $index + 1,
            ]);
        }

        return Redirect::route('ligne.index')->with('success', 'Ligne créée avec succès.');
    }

    public function edit(Ligne $ligne): Response
    {
        $this->authorize('update ligne');
        return Inertia::render('Lignes/Edit', [
            'ligne' => [
                'id' => $ligne->id,
                'nom' => $ligne->nom,
                'gare_depart_id' => $ligne->gare_depart_id,
                'gare_arrivee_id' => $ligne->gare_arrivee_id,
                'distance_totale' => $ligne->distance_totale,
            ],
            'gares' => Gare::all()->map->only('id', 'nom'),
        ]);
    }

    public function update(Request $request, Ligne $ligne)
    {
        $this->authorize('update ligne');
        $validated = $request->validate([
            'nom' => ['required', 'string', 'max:255'],
            'gare_depart_id' => ['required', 'exists:gares,id'],
            'gare_arrivee_id' => ['required', 'exists:gares,id', 'different:gare_depart_id'],
            'distance_totale' => ['required', 'numeric', 'min:1'],
        ]);

        $ligne->update($validated);

        return Redirect::route('ligne.index')->with('success', 'Ligne mise à jour avec succès.');
    }

    public function destroy(Ligne $ligne)
    {
        $this->authorize('delete ligne');
        if ($ligne->arrets()->exists() || $ligne->voyages()->exists()) {
            return Redirect::back()->with('error', 'Impossible de supprimer : la ligne est utilisée dans des voyages ou arrêts.');
        }

        $ligne->delete();

        return Redirect::back()->with('success', 'Ligne supprimée avec succès.');
    }
}
