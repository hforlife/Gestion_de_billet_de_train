<?php

use App\Http\Controllers\Api\{
    BagageController,
    DashboardController,
    GareController,
    TrainController,
    VenteController,
    EmployeesController,
    SectionController,
    VoyageController
};
use Illuminate\Support\Facades\Route;

// Auth + middleware de protection
// Route::middleware(['auth'])->group(function () {
Route::get('/', function (){
    return redirect('login');
});
    /*
        Tableau de bord
    */
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

    /*
        Gestion des ventes (routes manuelles si besoin de personnalisation)
    */
    Route::get('/vente', [VenteController::class, 'index'])->name('vente.index');
    Route::get('/vente-create', [VenteController::class, 'create'])->name('vente.create');
    Route::post('/vente-store', [VenteController::class, 'store'])->name('vente.store');
    Route::get('/vente-edit', [VenteController::class, 'edit'])->name('vente.edit');
    Route::post('/vente-update', [VenteController::class, 'update'])->name('vente.update');
    Route::delete('/vente-destroy', [VenteController::class, 'destroy'])->name('vente.destroy');

    /*
        Ressources générées automatiquement (hors show)
    */
    Route::resource('train', TrainController::class)->except(['show']);
    Route::resource('bagage', BagageController::class)->except(['show']);
    Route::resource('employee', EmployeesController::class)->except(['show']);
    Route::resource('section', SectionController::class)->except(['show']);
    Route::resource('gare', GareController::class)->except(['show']);
    Route::resource('voyage', VoyageController::class)->except(['show']);

    // 🔒 Si tu veux restreindre certaines ressources à des rôles :
    // Route::middleware('role:admin')->group(function () {
    //     Route::resource('employee', EmployeesController::class)->except(['show']);
    //     Route::resource('section', SectionController::class)->except(['show']);
    // });

// });

// Auth routes (login/logout/register...)
require __DIR__ . '/auth.php';

// Paramètres (gestion rôles/permissions)
require __DIR__ . '/setting.php';
