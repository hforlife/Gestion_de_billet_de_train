<?php

namespace App\Http\Controllers\Trains;

use App\Http\Controllers\Controller;
use App\Models\ClassesWagon;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class ClasseController extends Controller
{
    use AuthorizesRequests;
     // Liste des ClassesWagons
    public function index(Request $request): Response
    {
        $filters = $request->only('search');

        $ClassesWagons = ClassesWagon::query()
            ->filter($filters)
            ->orderBy('classe')
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Trains/Classe/Index', [
            'filters' => $filters,
            'ClassesWagons' => $ClassesWagons->through(fn($ClassesWagon) => [
                'id' => $ClassesWagon->id,
                'classe' => $ClassesWagon->classe,
                'prix_multiplier' => $ClassesWagon->prix_multiplier
            ]),
        ]);
    }

    // Formulaire de création
    public function create(): Response
    {
        return Inertia::render('Trains/Classe/Create');
    }

    // Enregistrement du ClassesWagon
    public function store(Request $request)
    {
        $validated = $request->validate([
            'classe' => 'required|string|max:255',
            'prix_multiplier' => 'required|string|max:255',
        ]);

        $ClassesWagon = ClassesWagon::create($validated);

        return redirect()->route('classe.index')->with('success', 'Classes et sièges créés avec succès.');
    }

    // Formulaire d'édition
    public function edit(int $id): Response
    {
        $ClassesWagon = ClassesWagon::findOrFail($id);

        return Inertia::render('Trains/Classe/Edit', [
            'ClassesWagon' => $ClassesWagon,
        ]);
    }

    // Mise à jour
    public function update(Request $request, int $id)
    {
        $ClassesWagon = ClassesWagon::findOrFail($id);

        $validated = $request->validate([
            'classe' => 'required',
            'prix_multiplier' => 'required|string|max:255',
        ]);

        $ClassesWagon->update($validated);

        return redirect()->route('classe.index')->with('success', 'Classe mis à jour avec succès.');
    }

    // Suppression
    public function destroy(int $id)
    {
        $ClassesWagon = ClassesWagon::findOrFail($id);
        $ClassesWagon->delete();

        return redirect()->route('classe.index')->with('success', 'Suppression effectuée avec succès.');
    }
}
