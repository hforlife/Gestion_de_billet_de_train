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
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class DashboardController extends Controller
{
    use AuthorizesRequests;
    /**
     * Display a listing of the resource.
     */
    public function index(): Response
    {
        $this->authorize('viewAny dashboard');
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
                DATE_FORMAT(created_at, 'YYYY-MM') as mois,
                SUM(prix) as total_revenus
            ")
            ->where('created_at', '>=', now()->subMonths(12))
            ->groupBy('mois')
            ->orderBy('mois')
            ->get();

        // Ventes par mois pour le graphique (12 derniers mois)
        $ventesParMois = Vente::selectRaw("
                DATE_FORMAT(created_at, 'YYYY-MM') as mois,
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


    // app/Http/Controllers/VoyageController.php
    public function getVoyagesForCalendar()
    {
        $voyages = Voyage::with(['gareDepart', 'gareArrivee', 'train'])
            ->select(
                'id',
                'date_depart',
                'heure_depart',
                'heure_arrivee',
                'gare_depart_id',
                'gare_arrivee_id',
                'train_id'
            )
            ->get()
            ->map(function ($voyage) {
                return [
                    'id' => $voyage->id,
                    'title' => $voyage->train->numero . ' → ' .
                        $voyage->gareDepart->nom . ' - ' .
                        $voyage->gareArrivee->nom,
                    'start' => $voyage->date_depart->format('Y-m-d') . 'T' . $voyage->heure_depart,
                    'end' => $voyage->date_depart->format('Y-m-d') . 'T' . $voyage->heure_arrivee,
                    'color' => $this->getTrainColor($voyage->train->type),
                    'extendedProps' => [
                        'train' => $voyage->train->numero,
                        'depart' => $voyage->gareDepart->nom,
                        'arrivee' => $voyage->gareArrivee->nom,
                        'heure_depart' => $voyage->heure_depart,
                        'heure_arrivee' => $voyage->heure_arrivee
                    ]
                ];
            });

        return response()->json($voyages);
    }

    private function getTrainColor($type)
    {
        return match ($type) {
            'TGV' => '#3b82f6',
            'TER' => '#10b981',
            'Intercités' => '#f59e0b',
            default => '#6b7280'
        };
    }
}
