<?php

namespace App\Http\Controllers;

use App\Models\CategorieColis;
use App\Models\Parametre;
use App\Models\ClassesWagon;
use App\Models\SystemSetting;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class ParametreController extends Controller
{
    use AuthorizesRequests;
    public function index(): Response
    {
        $this->authorize('viewAny parametre');
        $param = Parametre::query()
            // ->orderBy('pri')
            ->paginate(10)
            ->withQueryString();

        $ClassesWagons = ClassesWagon::query()
            ->orderBy('classe')
            ->paginate(10)
            ->withQueryString();

        $SystemSetting = SystemSetting::first();

        return Inertia::render('Setting/Parametre/Index', [
            // Données pour les catégories de colis
            'parametres' => $param->through(fn($param) => [
                'id' => $param->id,
                'categorie_id' => $param->categorie_id,
                'poids_min' => $param->poids_min,
                'poids_max' => $param->poids_max,
                'prix_par_kg' => $param->prix_par_kg,
                'categorie' => [
                    'id' => $param->categorie->id ?? null,
                    'nom' => $param->categorie->nom ?? 'Inconnue',
                ],
            ]),

            // Données pour les classes
            'ClassesWagons' => $ClassesWagons->through(fn($ClassesWagon) => [
                'id' => $ClassesWagon->id,
                'classe' => $ClassesWagon->classe,
                'prix_multiplier' => $ClassesWagon->prix_multiplier
            ]),

            // Données pour les paramètres systèmes
            'Settings' => $SystemSetting,
        ]);
    }

    public function create()
    {
        $this->authorize('create parametre');
        return Inertia::render('Setting/Parametre/Create', [
            'categories' => CategorieColis::orderBy('nom')->get()->map(fn($cat) => [
                'id' => $cat->id,
                'nom' => $cat->nom,
                'description' => $cat->description,
            ]),
        ]);
    }

    public function store(Request $request)
    {
        $this->authorize('create parametre');
        $validated = $request->validate([
            'categorie_id' => ['required', 'exists:categorie_colis,id'],
            'poids_min' => ['required', 'numeric', 'min:0'],
            'poids_max' => ['required', 'numeric', 'gt:poids_min'],
            'prix_par_kg' => ['required', 'numeric', 'min:0'],
        ]);

        // Facultatif : vérifier chevauchement avec d'autres plages pour la même catégorie
        $exists = Parametre::where('categorie_id', $validated['categorie_id'])
            ->where(function ($query) use ($validated) {
                $query->whereBetween('poids_min', [$validated['poids_min'], $validated['poids_max']])
                    ->orWhereBetween('poids_max', [$validated['poids_min'], $validated['poids_max']]);
            })
            ->exists(); 

        if ($exists) {
            return back()->withErrors([
                'poids_min' => 'Cette plage de poids est déjà couverte pour cette catégorie.',
            ]);
        }

        Parametre::create($validated);

        return redirect()->route('setting.index')->with('success', 'Tarif enregistré avec succès.');
    }


    public function edit(int $id): Response
    {
        $this->authorize('create parametre');
        return Inertia::render('Setting/Parametre/UpdateCat', [
            'settings' => Parametre::findOrFail($id),
            'categories' => CategorieColis::orderBy('nom')->get()->map(fn($cat) => [
                'id' => $cat->id,
                'nom' => $cat->nom,
                'description' => $cat->description,
            ]),
        ]);
    }

    public function update(Request $request, Parametre $set)
    {
        $this->authorize('create parametre');

        $validated = $request->validate([
            'categorie_id' => ['required', 'exists:categorie_colis,id'],
            'poids_min' => ['required', 'numeric', 'min:0',' between:0,999.99'],
            'poids_max' => ['required', 'numeric', 'gt:poids_min',' between:0,999.99'],
            'prix_par_kg' => ['required', 'numeric', 'min:0',' between:0,999.99'],
        ]);

        // Vérifier chevauchement
        $exists = Parametre::where('categorie_id', $validated['categorie_id'])
            ->where('id', '!=', $set->id)
            ->where(function ($query) use ($validated) {
                $query->where('poids_min', '<=', $validated['poids_max'])
                    ->where('poids_max', '>=', $validated['poids_min']);
            })
            ->exists();

        if ($exists) {
            return back()->withErrors([
                'poids_min' => 'Cette plage de poids est déjà couverte pour cette catégorie.',
            ]);
        }

        $set->update($validated);

        return redirect()->route('setting.index')->with('success', 'Tarif mis à jour avec succès.');
    }


    // Suppression
    public function destroy(int $id)
    {
        $ClassesWagon = Parametre::findOrFail($id);
        $ClassesWagon->delete();

        return redirect()->back()->with('success', 'Suppression effectuée avec succès.');
    }
}
