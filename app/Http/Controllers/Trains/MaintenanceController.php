<?php

namespace App\Http\Controllers\Trains;

use App\Models\Train;
use App\Models\Maintenance;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use Carbon\Carbon;

class MaintenanceController
{
    // Liste des maintenances
    public function index(Request $request): Response
    {
        $filters = $request->only(['search', 'statut', 'train_id']);

        $maintenances = Maintenance::with(['train'])
            ->when($filters['search'] ?? null, fn($query, $search) =>
                $query->where('description', 'like', "%{$search}%")
            )
            ->when($filters['statut'] ?? null, fn($query, $statut) =>
                $query->where('statut', $statut)
            )
            ->when($filters['train_id'] ?? null, fn($query, $trainId) =>
                $query->where('train_id', $trainId)
            )
            ->orderBy('date_debut', 'desc')
            ->paginate(15)
            ->withQueryString();

        return Inertia::render('Maintenances/Index', [
            'maintenances' => $maintenances,
            'filters' => $filters,
            'trains' => Train::all(),
            'statuts' => ['planifie', 'en_cours', 'termine', 'retard'],
        ]);
    }

    // Formulaire de création
    public function create(): Response
    {
        return Inertia::render('Maintenances/Create', [
            'trains' => Train::all(),
        ]);
    }

    // Enregistrement d'une nouvelle maintenance
    public function store(Request $request)
    {
        $validated = $request->validate([
            'train_id' => 'required|exists:trains,id',
            'date_debut' => 'required|date|after_or_equal:now',
            'date_fin_prevue' => 'required|date|after:date_debut',
            'description' => 'required|string|min:10|max:2000',
            'statut' => 'required|in:planifie,en_cours,termine,retard',
        ]);

        // Vérifier que le train n'est pas déjà en maintenance
        $existing = Maintenance::where('train_id', $validated['train_id'])
            ->where('statut', '!=', 'termine')
            ->exists();

        if ($existing) {
            return back()->withErrors([
                'train_id' => 'Ce train est déjà en maintenance'
            ]);
        }

        Maintenance::create($validated);

        return redirect()->route('maintenance.index')
            ->with('success', 'Maintenance planifiée avec succès');
    }

    // Marquer comme terminée
    public function terminer(Maintenance $maintenance)
    {
        $maintenance->update([
            'statut' => 'termine',
            'date_fin_reelle' => now(),
        ]);

        return back()->with('success', 'Maintenance marquée comme terminée');
    }

    // Formulaire d'édition
    public function edit(Maintenance $maintenance): Response
    {
        return Inertia::render('Maintenances/Edit', [
            'maintenance' => $maintenance,
            'trains' => Train::all(),
        ]);
    }

    // Mise à jour d'une maintenance
    public function update(Request $request, Maintenance $maintenance)
    {
        $rules = [
            'description' => 'required|string|min:10|max:2000',
            'statut' => 'required|in:planifie,en_cours,termine,retard',
        ];

        if ($maintenance->statut === 'planifie') {
            $rules['date_debut'] = 'required|date';
            $rules['date_fin_prevue'] = 'required|date|after:date_debut';
        }

        $validated = $request->validate($rules);

        $maintenance->update($validated);

        return redirect()->route('maintenance.index')
            ->with('success', 'Maintenance mise à jour avec succès');
    }

    // Suppression d'une maintenance
    public function destroy(Maintenance $maintenance)
    {
        $maintenance->delete();

        return redirect()->route('maintenance.index')
            ->with('success', 'Maintenance supprimée avec succès');
    }

    // Dashboard des maintenances
    public function dashboard(): Response
    {
        $stats = [
            'en_cours' => Maintenance::where('statut', 'en_cours')->count(),
            'planifiees' => Maintenance::where('statut', 'planifie')->count(),
            'en_retard' => Maintenance::where('statut', 'retard')->count(),
        ];

        $recentes = Maintenance::with('train')
            ->where('date_debut', '>=', now()->subDays(7))
            ->orderBy('date_debut', 'desc')
            ->limit(5)
            ->get();

        return Inertia::render('Maintenances/Dashboard', [
            'stats' => $stats,
            'recentes' => $recentes,
        ]);
    }
}
