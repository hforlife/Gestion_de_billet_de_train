<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\{
    ArretController,
    BilletController,
    ColisController,
    DashboardController,
    GareController,
    TrainController,
    WagonController,
    VenteController,
    VoyageController,
    UserController,
    CategorieColisController,
    ParametreController,
    FeedController,
    ReccuringVoyageController
};

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
    Route::resource('/train', TrainController::class)->except(['show']);
    Route::resource('/wagon', WagonController::class)->except(['show']);
    Route::resource('/gare', GareController::class)->except(['show']);
    Route::resource('/voyage', VoyageController::class)->except(['show']);
    Route::resource('/voyage-reccurent', ReccuringVoyageController::class)->except(['show']);
    Route::resource('/arret', ArretController::class)->except(['show']);
    Route::resource('/categories-colis', CategorieColisController::class)->except(['show']);
    Route::resource('/setting', ParametreController::class)->except(['show']);
    Route::resource('/feed', FeedController::class)->except(['show']);
});

// Routes réservées à l'admin
Route::middleware(['auth', 'role:admin'])->group(function () {
    Route::resource('/user', UserController::class)->except(['show']);
});

require __DIR__ . '/auth.php';
