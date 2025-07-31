<?php


use Illuminate\Support\Facades\Route;
use App\Http\Controllers\{
    DashboardController,
    UserController,
    ParametreController,
    FeedController,
    BilletController,
    DistanceController,
    PaiementController,
    RoleController,
    SystemSettingController
};

// Contrôleurs par module
use App\Http\Controllers\Gares\{GareController, ArretController, LigneController, TypeController};
use App\Http\Controllers\Trains\{ClasseController, TrainController, WagonController, MaintenanceController};
use App\Http\Controllers\Ventes\{VenteController, PointVenteController};
use App\Http\Controllers\Voyages\{VoyageController, ReccuringVoyageController, TarifController};
use App\Http\Controllers\Colis\{ColisController, CategorieColisController};

Route::get('/', function () {
    return redirect('login');
});

// Routes communes à tous les utilisateurs authentifiés
Route::middleware(['auth'])->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

    Route::get('/profile', [UserController::class, 'profile'])
        ->name('user.profile');
});

// Routes pour caissiers, chefs et admin
Route::middleware(['auth', 'role:admin|chef|caissier'])->group(function () {
    Route::prefix('/vente')->group(function () {
        Route::get('/', [VenteController::class, 'index'])->name('vente.index');
        Route::get('/create', [VenteController::class, 'create'])->name('vente.create');
        Route::post('/store', [VenteController::class, 'store'])->name('vente.store');
        Route::get('/{id}', [VenteController::class, 'show'])->name('vente.show');
        Route::get('/{id}/edit', [VenteController::class, 'edit'])->name('vente.edit');
        Route::put('/{vente}', [VenteController::class, 'update'])->name('vente.update');
        Route::delete('/{id}', [VenteController::class, 'destroy'])->name('vente.destroy');
    });

    Route::get('/billet/{id}', [BilletController::class, 'generateBillet'])->name('vente.generate');
    Route::resource('/colis', ColisController::class)->except(['show']);
});

// Routes pour chefs et admin seulement
Route::middleware(['auth', 'role:admin|chef'])->group(function () {
    Route::resource('/points-vente', PointVenteController::class)->except(['show']);            // Pour les points de vente
    Route::resource('/train', TrainController::class)->except(['show']);                        // Pour les trains
    Route::resource('/wagon', WagonController::class)->except(['show']);                        // Pour les wagons
    Route::resource('/classe', ClasseController::class)->except(['show']);                      // Pour les classes de train
    Route::resource('/gare', GareController::class)->except(['show']);                          // Pour les gares
    Route::resource('/ligne', LigneController::class)->except(['show']);                        // Pour les lignes de train
    Route::resource('/type', TypeController::class)->except(['show']);                          // Pour les Type de train
    Route::resource('/arret', ArretController::class)->except(['show']);                        // Pour les arrêts
    Route::resource('/voyage', VoyageController::class)->except(['show']);                      // Pour les voyages
    Route::resource('/voyage-reccurent', ReccuringVoyageController::class)->except(['show']);   // Pour les voyages récurrents
    Route::resource('/categories-colis', CategorieColisController::class)->except(['show']);    // Pour les catégories de colis
    Route::resource('/setting', ParametreController::class)->except(['show']);                  // Pour les paramètres
    Route::resource('/system', SystemSettingController::class)->except(['show', 'index', 'destroy']);                  // Pour les paramètres
    Route::resource('/feed', FeedController::class)->except(['show']);                          //Pour les rapports
    Route::resource('/paiement', PaiementController::class)->except(['show']);                  //Pour les Paiements
    Route::resource('/tarif', TarifController::class)->except(['show']);
    Route::resource('/maintenance', MaintenanceController::class)->except(['show']);
    Route::resource('/distance', DistanceController::class)->except(['show']);

    Route::get(
        '/maintenance/dashboard',
        [MaintenanceController::class, 'dashboard']
    )->name('maintenance.dashboard');
    Route::post(
        '/maintenance/{maintenance}/terminer',
        [MaintenanceController::class, 'terminer']
    )->name('maintenance.terminer');
});

// Routes réservées à l'admin
Route::middleware(['auth', 'role:admin'])->group(function () {
    Route::resource('/user', UserController::class)->except(['show']);
    Route::resource('/role', RoleController::class)->except(['show']);
});

require __DIR__ . '/auth.php';
