<?php

namespace App\Http\Controllers\Gares;

use App\Http\Controllers\Controller;
use App\Models\TypesGare;
use App\Models\Gare;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;
use Inertia\Response;

class TypeController extends Controller
{
    public function index(Request $request): Response
    {
        $filters = $request->only(['search']);

        return Inertia::render('Gares/Types/Index', [
            'filters' => $filters,
            'types' => TypesGare::withCount('gares')
                ->when($filters['search'] ?? null, function ($query, $search) {
                    $query->where('type', 'like', "%{$search}%")
                          ->orWhere('description', 'like', "%{$search}%");
                })
                ->orderBy('type')
                ->paginate(10)
                ->withQueryString()
                ->through(fn ($type) => [
                    'id' => $type->id,
                    'type' => $type->type,
                    'description' => $type->description,
                    'gares_count' => $type->gares_count,
                ]),
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Gares/Types/Create');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'type' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string', 'max:1000'],
        ]);

        TypesGare::create($validated);

        return Redirect::route('type.index')->with('success', 'Type de gare créé avec succès.');
    }

    public function edit(TypesGare $typesGare): Response
    {
        return Inertia::render('Gares/Types/Edit', [
            'typeGare' => [
                'id' => $typesGare->id,
                'type' => $typesGare->type,
                'description' => $typesGare->description,
            ],
        ]);
    }

    public function update(Request $request, TypesGare $typesGare)
    {
        $validated = $request->validate([
            'type' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string', 'max:1000'],
        ]);

        $typesGare->update($validated);

        return Redirect::route('type.index')->with('success', 'Type de gare mis à jour avec succès.');
    }

    public function destroy(TypesGare $typesGare)
    {
        if ($typesGare->gares()->exists()) {
            return Redirect::back()->with('error', 'Impossible de supprimer ce type de gare car il est utilisé par des gares.');
        }

        $typesGare->delete();

        return Redirect::back()->with('success', 'Type de gare supprimé avec succès.');
    }
}
