<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Colis;
use App\Models\Voyage;
use App\Models\Gare;
use App\Models\Train;
use App\Models\Vente;
use App\Models\User;
use App\Models\Client;
use App\Models\Ligne;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
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

        // Totaux
        $ticketsCount = Vente::count();
        $revenusTotaux = Vente::sum('prix');
        $trainsCount = Train::count();
        $voyagesCount = Voyage::count();
        $garesCount = Gare::count();
        $colisExpressCount = Colis::where('statut', 'enregistré')->count();
        $voyagesDuJour = Voyage::whereDate('date_depart', today())->count();

        // Revenus mensuels
        $revenusMensuels = Vente::selectRaw("
                DATE_FORMAT(date_vente, '%Y-%m') as mois,
                SUM(prix) as total_revenus
            ")
            ->where('date_vente', '>=', now()->subMonths(12))
            ->groupBy('mois')
            ->orderBy('mois')
            ->get();

        // Ventes mensuelles
        $ventesParMois = Vente::selectRaw("
                DATE_FORMAT(date_vente, '%Y-%m') as mois,
                COUNT(*) as total_ventes
            ")
            ->where('date_vente', '>=', now()->subMonths(12))
            ->groupBy('mois')
            ->orderBy('mois')
            ->get();

        $graphData = $ventesParMois->map(function ($item) use ($revenusMensuels) {
            $revenuMois = $revenusMensuels->firstWhere('mois', $item->mois);
            return [
                'mois' => Carbon::createFromFormat('Y-m', $item->mois)->format('M Y'),
                'ventes' => $item->total_ventes,
                'revenus' => $revenuMois ? $revenuMois->total_revenus : 0,
            ];
        });

        // Top destinations
        $topDestinations = $this->getTopDestinations();

        // Méthodes de paiement
        $paymentMethodsData = $this->getPaymentMethodsData();

        return Inertia::render('Dashboard/Index', [
            'tickets' => $ticketsCount,
            'trains' => $trainsCount,
            'voyages' => $voyagesCount,
            'gares' => $garesCount,
            'stats' => [
                'total_ventes' => $ticketsCount,
                'revenus_totaux' => $revenusTotaux,
                'colis_express' => $colisExpressCount,
                'voyages_du_jour' => $voyagesDuJour,
            ],
            'graph_data' => $graphData,
            'revenus_mensuels' => $revenusMensuels,
            'top_destinations' => $topDestinations,
            'payment_methods_data' => $paymentMethodsData,
        ]);
    }


    /**
     * Get top destinations
     */

    private function getTopDestinations(): array
    {
        return Voyage::selectRaw('
                gares.nom as destination,
                COUNT(ventes.id) as nombre_ventes,
                SUM(ventes.prix) as revenu_total
            ')
            ->join('gares', 'voyages.gare_arrivee_id', '=', 'gares.id')
            ->join('ventes', 'ventes.voyage_id', '=', 'voyages.id')
            ->where('ventes.date_vente', '>=', now()->subMonths(6))
            ->groupBy('gares.id', 'gares.nom')
            ->orderByDesc('nombre_ventes')
            ->limit(5)
            ->get()
            ->map(fn($item) => [
                'nom' => $item->destination,
                'ventes' => $item->nombre_ventes,
                'revenu' => $item->revenu_total
            ])
            ->toArray();
    }


    /**
     * Get payment methods data
     */
    private function getPaymentMethodsData(): array
    {
        $totalVentes = Vente::where('date_vente', '>=', now()->subMonth())->count();

        if ($totalVentes === 0) {
            return [
                ['methode' => 'Mobile Money', 'pourcentage' => 45],
                ['methode' => 'Carte Bancaire', 'pourcentage' => 30],
                ['methode' => 'Espèce', 'pourcentage' => 20],
                ['methode' => 'Autre', 'pourcentage' => 5]
            ];
        }

        return Vente::selectRaw("
        modes_paiement.type as methode,
        ROUND(COUNT(*) * 100.0 / {$totalVentes}, 2) as pourcentage
    ")
            ->join('modes_paiement', 'ventes.mode_paiement_id', '=', 'modes_paiement.id')
            ->where('ventes.date_vente', '>=', now()->subMonth())
            ->groupBy('modes_paiement.type')
            ->get()
            ->toArray();
    }

    /**anieh920
     * Get voyages for calendar
     */
    public function getVoyagesForCalendar()
    {
        $voyages = Voyage::with(['gareDepart', 'gareArrivee', 'train'])
            ->select('id', 'date_depart', 'gare_depart_id', 'gare_arrivee_id', 'train_id')
            ->get()
            ->map(function ($voyage) {
                return [
                    'id' => $voyage->id,
                    'title' => $voyage->train->numero . ' → ' .
                        $voyage->gareDepart->nom . ' - ' .
                        $voyage->gareArrivee->nom,
                    'start' => $voyage->date_depart,
                    'color' => '#3b82f6', // couleur par défaut car ton modèle Train n’a pas "type"
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
