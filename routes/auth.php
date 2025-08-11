<?php

use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;


Route::get('login', [AuthController::class, 'create'])
    ->name('login')
    ->middleware('guest');

Route::post('login', [AuthController::class, 'store'])
    ->name('login.store')
    ->middleware('guest');

Route::post('logout', [AuthController::class, 'destroy'])
    ->name('logout');

Route::get('/profile', [ProfileController::class, 'profile'])
        ->name('user.profile')->middleware('can:profile user');

Route::put('/profile', [ProfileController::class, 'update'])
    ->name('profile.update')->middleware('can:profile user');
