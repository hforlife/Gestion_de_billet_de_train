<?php

namespace App\Http\Controllers;


use App\Models\Gares;
use Illuminate\Support\Facades\Request;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;
use Inertia\Response;

class GareController extends Controller
{
    public function index(): Response
    {
        return Inertia::render('Gares/Index', [
            'filters' => Request::only('search'),
            'gares' => Gares::orderBy('nom')
                ->filter(Request::only('search'))
                ->paginate(10)
                ->withQueryString()
                ->through(fn ($gare) => [
                    'id' => $gare->id,
                    'nom' => $gare->nom,
                    'adresse' => $gare->adresse,
                ]),
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Gares/Create');
    }

    public function store()
    {
        Gares::create(Request::validate([
            'nom' => ['required', 'string', 'max:255'],
            'adresse' => ['required', 'string', 'max:255'],
        ]));

        return Redirect::route('gare.index')->with('success', 'Ajout effectué avec succès');
    }

    public function edit(Gares $gare): Response
    {
        return Inertia::render('Gares/Edit', [
            'gares' => $gare->only('id', 'nom', 'adresse'),
        ]);
    }

    public function update(Gares $gare)
    {
        $gare->update(Request::validate([
            'nom' => ['required', 'string', 'max:255'],
            'adresse' => ['required', 'string', 'max:255'],
        ]));

        return Redirect::route('gare.index')->with('success', 'Modification effectuée avec succès');
    }

    public function destroy(Gares $gare)
    {
        $gare->delete();

        return Redirect::back()->with('success', 'Suppression effectuée avec succès.');
    }
}
