<?php

namespace App\Http\Controllers;

use App\Models\CategorieColis;
use Inertia\Inertia;
use Inertia\Response;
use App\Models\Parametres;
use Illuminate\Http\Request;

class ParametreController extends Controller
{
    //
    public function index(): Response
    {
        return Inertia::render('Setting/Parametre/Index', [
            'parametres' => Parametres::orderBy('poids_min')->get(),
            'categories' => CategorieColis::all()->map(fn($cat) => [
                'id' => $cat->id,
                'nom' => $cat->nom,
                'description' => $cat->description,
            ]),
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'categorie_id' => ['required', 'exists:categorie_colis,id'],
            'poids_min' => ['required', 'numeric'],
            'poids_max' => ['required', 'numeric'],
            'prix_par_kg' => ['required', 'numeric'],
        ]);

        Parametres::create($validated);

        return redirect()->back()->with('success', 'Tarif enregistré avec succès.');
    }


}
