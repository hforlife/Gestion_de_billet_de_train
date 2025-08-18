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
Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard')->middleware('can:viewAny dashboard');

Route::middleware(['auth'])->group(function () {
    Route::get('/profile', [UserController::class, 'profile'])
        ->name('user.profile');
});


// Routes pour caissiers, chefs et admin

    Route::prefix('/vente')->group(function () {
        Route::get('/', [VenteController::class, 'index'])->name('vente.index')->middleware('can:viewAny vente');
        // Création selon le mode : prédéfini ou kilométrique
        Route::get('/create/predefined', [VenteController::class, 'createPredefined'])->name('vente.create.predefined')->middleware('can:createPredefined vente');
        Route::get('/create/kilometrage', [VenteController::class, 'createKilometrage'])->name('vente.create.kilometrage')->middleware('can:createKilometrage vente');

        // Route générique de création qui redirige selon le mode système si besoin
        Route::get('/create', [VenteController::class, 'create'])->name('create')->middleware('can:create vente');

        // Stockage (une seule méthode, elle peut détecter/recevoir le mode)
        Route::post('/store', [VenteController::class, 'store'])->name('vente.store')->middleware('can:create vente');
        Route::get('/{id}', [VenteController::class, 'show'])->name('vente.show')->middleware('can:view vente');
        Route::get('/{id}/edit', [VenteController::class, 'edit'])->name('vente.edit');
        Route::put('/{vente}', [VenteController::class, 'update'])->name('vente.update');
        Route::delete('/{id}', [VenteController::class, 'destroy'])->name('vente.destroy')->middleware('can:delete vente');
    });

    Route::get('/billet/{id}', [BilletController::class, 'generateBillet'])->name('vente.generate');
    Route::resource('/colis', ColisController::class)->except(['show']);


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
    Route::resource('/voyage', VoyageController::class)->except(['show']);
    Route::get('/voyages/next-number', [VoyageController::class, 'nextNumber'])->name('voyage.next-number'); // Pour les voyages
    Route::resource('/voyage-reccurent', ReccuringVoyageController::class)->except(['show']);   // Pour les voyages récurrents
    Route::resource('/categories-colis', CategorieColisController::class)->except(['show']);    // Pour les catégories de colis
    Route::resource('/setting', ParametreController::class)->except(['show']);                  // Pour les paramètres
    Route::resource('/system', SystemSettingController::class)->except(['show','destroy']);     // Pour les paramètres
    Route::resource('/feed', FeedController::class)->except(['show']);                          //Pour les rapports
    Route::resource('/paiement', PaiementController::class)->except(['show']);                  //Pour les Paiements
    Route::resource('/tarif', TarifController::class)->except(['show']);
    Route::resource('/distance', DistanceController::class)->except(['show']);
});

// Routes réservées à l'admin
Route::middleware(['auth', 'role:admin'])->group(function () {
    Route::resource('/user', UserController::class)->except(['show']);
    Route::resource('/role', RoleController::class)->except(['show']);
});

require __DIR__ . '/auth.php';
