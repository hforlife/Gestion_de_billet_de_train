<?php

namespace App\Http\Controllers;

use Inertia\Inertia;
use Illuminate\Http\Request;
use App\Models\CategorieColis;

class CategorieColisController extends Controller
{
    //

    public function index(Request $request)
    {
        return Inertia::render('Colis/CategoriesColis/Index', [
            'filters' => $request->only('search'),
            'categories' => CategorieColis::orderBy('nom')
                ->filter($request->only('search'))
                ->paginate(10)
                ->withQueryString()
                ->through(fn($cat) => [
                    'id' => $cat->id,
                    'nom' => $cat->nom,
                    'description' => $cat->description,
                ]),
        ]);
    }


    public function create()
    {
        return Inertia::render('Colis/CategoriesColis/Create');
    }

    public function store(Request $request)
    {
        $request->validate([
            'nom' => 'required|unique:categorie_colis,nom',
            'description' => 'nullable|string',
        ]);

        CategorieColis::create($request->only('nom', 'description'));

        return redirect()->route('categories-colis.index')->with('success', 'Catégorie ajoutée avec succès.');
    }

    public function edit(CategorieColis $categories_coli)
    {
        return Inertia::render('Colis/CategoriesColis/Edit', [
            'categorie' => [
                'id' => $categories_coli->id,
                'nom' => $categories_coli->nom,
                'description' => $categories_coli->description,
            ]
        ]);
    }

    public function update(Request $request, CategorieColis $categories_coli)
    {
        $request->validate([
            'nom' => 'required|unique:categorie_colis,nom,' . $categories_coli->id,
            'description' => 'nullable|string',
        ]);

        $categories_coli->update($request->only('nom', 'description'));

        return redirect()->route('categories-colis.index')->with('success', 'Catégorie modifiée.');
    }

    public function destroy(CategorieColis $categories_coli)
    {
        $categories_coli->delete();

        return redirect()->route('categories-colis.index')->with('success', 'Catégorie supprimée.');
    }


}
