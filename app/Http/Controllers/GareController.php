<?php

namespace App\Http\Controllers;

use App\Models\Gare;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;
use Inertia\Response;

class GareController extends Controller
{
    public function index(Request $request): Response
    {
        $filters = $request->only('search');

        return Inertia::render('Gares/Index', [
            'filters' => $filters,
            'gares' => Gare::orderBy('nom')
                ->when($filters['search'] ?? null, function ($query, $search) {
                    $query->where('nom', 'like', "%{$search}%")
                          ->orWhere('adresse', 'like', "%{$search}%");
                })
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

    public function store(Request $request)
    {
        $validated = $request->validate([
            'nom' => ['required', 'string', 'max:255'],
            'adresse' => ['required', 'string', 'max:255'],
        ]);

        Gare::create($validated);

        return Redirect::route('gare.index')->with('success', 'Ajout effectué avec succès.');
    }

    public function edit($id): Response
    {
        return Inertia::render('Gares/Edit', [
            'gare' => Gare::findOrFail($id),
        ]);
    }

    public function update(Request $request, Gare $gare)
    {
        $validated = $request->validate([
            'nom' => ['required', 'string', 'max:255'],
            'adresse' => ['required', 'string', 'max:255'],
        ]);

        $gare->update($validated);

        return Redirect::route('gare.index')->with('success', 'Modification effectuée avec succès.');
    }

    public function destroy(Gare $gare)
    {
        $gare->delete();

        return Redirect::back()->with('success', 'Suppression effectuée avec succès.');
    }
}
