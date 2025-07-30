<?php

// use App\Http\Controllers\Api\DashboardController;

use App\Http\Controllers\Ventes\VenteController;
use App\Http\Controllers\Voyages\VoyageController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');
Route::get('/voyages/{voyage}/tarifs', [VoyageController::class, 'tarifs']);
Route::get('/api/tarifs/disponibles', [VenteController::class, 'getTarifsDisponibles']);
