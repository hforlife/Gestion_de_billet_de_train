<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Colis;
use App\Models\Voyage;
use App\Models\Gare;
use App\Models\Train;
use App\Models\Vente;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use Carbon\Carbon;

class DashboardController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): Response
    {
        // Total des entités
        $ticketsCount = Vente::count();
        $revenusTotaux = Vente::sum('prix');
        $trainsCount = Train::count();
        $voyagesCount = Voyage::count();
        $garesCount = Gare::count();

        // Total de colis express transférés par l'utilisateur connecté
        $colisExpressCount = Colis::where('statut', 'enregistré')
                                   ->count();

        // Revenus mensuels (12 derniers mois)
        $revenusMensuels = Vente::selectRaw("
                TO_CHAR(created_at, 'YYYY-MM') as mois,
                SUM(prix) as total_revenus
            ")
            ->where('created_at', '>=', now()->subMonths(12))
            ->groupBy('mois')
            ->orderBy('mois')
            ->get();

        // Ventes par mois pour le graphique (12 derniers mois)
        $ventesParMois = Vente::selectRaw("
                TO_CHAR(created_at, 'YYYY-MM') as mois,
                COUNT(*) as total_ventes
            ")
            ->where('created_at', '>=', now()->subMonths(12))
            ->groupBy('mois')
            ->orderBy('mois')
            ->get();

        // Préparer les données pour le graphique
        $graphData = $ventesParMois->map(function ($item) use ($revenusMensuels) {
            $revenuMois = $revenusMensuels->firstWhere('mois', $item->mois);
            return [
                'mois' => $item->mois,
                'ventes' => $item->total_ventes,
                'revenus' => $revenuMois ? $revenuMois->total_revenus : 0,
            ];
        });

        return Inertia::render('Dashboard/Index', [
            'tickets' => $ticketsCount,
            'trains' => $trainsCount,
            'voyages' => $voyagesCount,
            'gares' => $garesCount,
            'stats' => [
                'total_ventes' => $ticketsCount,
                'revenus_totaux' => $revenusTotaux,
                'colis_express' => $colisExpressCount,
            ],
            'graph_data' => $graphData,
            'revenus_mensuels' => $revenusMensuels,
        ]);
    }


    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
