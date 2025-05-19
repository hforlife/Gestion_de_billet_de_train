<?php

use App\Http\Controllers\{
    ColisController,
    DashboardController,
    GareController,
    TrainController,
    VenteController,
    VoyageController,
UserController
};
use Illuminate\Support\Facades\Route;

// Auth + middleware de protection
Route::get('/', function (){
    return redirect('login');
});

    /*
        Tableau de bord
    */
    Route::get('/dashboard', [DashboardController::class, 'index'])
        ->name('dashboard')
        ->middleware('role:admin');

    /*
        Gestion des ventes
    */
    Route::get('/vente', [VenteController::class, 'index'])
        ->name('vente.index')
        ->middleware('role:admin');

    Route::get('/vente-create', [VenteController::class, 'create'])
        ->name('vente.create')
        ->middleware('role:admin');

    Route::post('/vente-store', [VenteController::class, 'store'])
        ->name('vente.store')
        ->middleware('role:admin');

    Route::get('/vente-show/{id}', [VenteController::class, 'show'])
        ->name('vente.show')
        ->middleware('role:admin');

    Route::get('/vente-edit/{id}', [VenteController::class, 'edit'])
        ->name('vente.edit')
        ->middleware('role:admin');

    Route::put('/vente-update/{vente}', [VenteController::class, 'update'])
        ->name('vente.update')
        ->middleware('role:admin');

    Route::delete('/vente-destroy/{id}', [VenteController::class, 'destroy'])
        ->name('vente.destroy')
        ->middleware('role:admin');

    Route::get('/vente/{id}/billet', [VenteController::class, 'generateBillet'])
        ->name('vente.billet')
        ->middleware('role:admin');

// Gestion des Trains
Route::resource('train', TrainController::class)->except(['show'])->middleware('role:admin');

// Gestion des Colis
    Route::resource('bagage', ColisController::class)->except(['show'])->middleware('role:admin');

    // Gestion des Gares
    Route::resource('gare', GareController::class)->except(['show'])->middleware('role:admin');

    // Gestion des Voyages
    Route::resource('voyage', VoyageController::class)->except(['show'])->middleware('role:admin');

    // Gestion des utilisateurs
    Route::resource('user', UserController::class)->except(['show'])->middleware('role:admin');

    // Gestion du profil de l'utilisateur connecté(e)
    Route::get('/profile', [UserController::class, 'profile'])
        ->name('user.profile')
        ->middleware('auth');

    // 🔒 Si tu veux restreindre certaines ressources à des rôles :
    // Route::middleware('role:admin')->group(function () {
    // });


// Auth routes (login/logout/register...)
require __DIR__ . '/auth.php';

