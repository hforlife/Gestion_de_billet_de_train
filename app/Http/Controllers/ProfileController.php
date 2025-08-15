<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Support\Facades\Auth;

class ProfileController extends Controller
{
    //
    use AuthorizesRequests;
    public function profile(): Response
    {
        $this->authorize('profile profile');
        $user = Auth::user();

        return Inertia::render('Setting/Profile/Index', [
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'username' => $user->username,
                'email' => $user->email,
                'roles' => $user->getRoleNames(),
            ]
        ]);
    }
    public function update(Request $request)
    {
        $this->authorize('profile profile');
        $this->authorize('update profile');

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users,email,' . $request->user()->id,
            'username' => 'nullable|string|max:255',
        ]);

        $request->user()->update($validated);

        return back()->with('success', 'Profil mis à jour avec succès');
    }
}
