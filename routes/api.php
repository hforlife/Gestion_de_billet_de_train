<?php

use App\Http\Controllers\Ventes\VenteController;
use App\Http\Controllers\Voyages\VoyageController;
use Illuminate\Http\Request;
use App\Http\Api\V1\LoginController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Api\V1\GareController;
use App\Http\Api\V1\ClassController;
use App\Http\Api\V1\TarifController;
use App\Http\Api\V1\SettingController;
use App\Http\Api\V1\PaiementController;
use App\Http\Api\V1\PointVenteController;
use App\Http\Api\V1\VenteController as V1VenteController;



Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');



Route::post('/login', [LoginController::class, 'login']);

Route::group(['middleware' => ['auth:sanctum']], function () {
    // Route::get('/logout', [AuthController::class, 'logout']);

    Route::prefix('v1')->group(function () {
        Route::apiResource('/gares', GareController::class);
        Route::apiResource('/paiements', PaiementController::class);
        Route::apiResource('/classes', ClassController::class);
        Route::apiResource('/voyages', VoyageController::class);
        Route::apiResource('/setting', SettingController::class);
        Route::apiResource('/tarifGare', TarifController::class);
        Route::apiResource('/ventes', V1VenteController::class);
        // Route::post('/carts/sync', [CartItemController::class, 'syncCart']);
    });
});
