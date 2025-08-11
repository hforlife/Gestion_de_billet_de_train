<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Request as ClientRequest;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Support\Facades\Redirect;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules;
use Spatie\Permission\Models\Role;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class UserController extends Controller
{
    use AuthorizesRequests;
    public function index(): Response
    {
        $this->authorize('viewAny user');
        return Inertia::render('Setting/User/Index', [
            'filters' => ClientRequest::only('search'),
            'users' => User::query()
                ->with('roles')
                ->orderBy('username')
                ->filter(ClientRequest::only('search'))
                ->paginate(10)
                ->through(fn($user) => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'username' => $user->username,
                    'email' => $user->email,
                    'roles' => $user->getRoleNames(),
                    'created_at' => $user->created_at->format('d/m/Y'),
                ]),
        ]);
    }

    public function create(): Response
    {
        $this->authorize('create user');
        return Inertia::render('Setting/User/Create', [
            'roles' => Role::all()->pluck('name')->toArray(), // Retourne un tableau de noms
        ]);
    }

    public function store(Request $request)
    {
        $this->authorize('create user');
        $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'username' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => ['required', 'confirmed', Rules\Password::defaults()],
            'roles' => ['required','string', 'exists:roles,name'],
        ]);

        $user = User::create([
            'name' => $request->name,
            'username' => $request->username,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        $user->syncRoles($request->roles);

        return Redirect::route('user.index')->with('success', 'Utilisateur créé avec succès.');
    }
    public function edit(User $user): Response
    {
        $this->authorize('update user');
        return Inertia::render('Setting/User/Edit', [
            'users' => [
                'id' => $user->id,
                'name' => $user->name,
                'username' => $user->username,
                'email' => $user->email,
                'role' => $user->getRoleNames()->first(), // ✅ un seul rôle pour le champ select
            ],
            'roles' => Role::all()->pluck('username')->toArray(), // Si besoin d’ID + nom, sinon .toArray() simple
        ]);
    }

    public function update(Request $request, User $user)
    {
        $this->authorize('update user');
        $request->validate([
            'name' => ['nullable', 'string', 'max:255'],
            'email' => ['nullable', 'string', 'email', 'max:255'],
            'password' => ['nullable', 'confirmed', Rules\Password::defaults()],
            'roles' => ['required','string', 'exists:roles,name'],
        ]);

        $user->update([
            'name' => $request->name,
            'username' => $request->username,
            'email' => $request->email,
            'password' => $request->password ? Hash::make($request->password) : $user->password,
        ]);

        $user->syncRoles($request->roles);

        return Redirect::route('user.index')->with('success', 'Utilisateur mis à jour avec succès.');
    }

    public function destroy(User $user)
    {
        $this->authorize('delete user');
        // Empêche la suppression de l'utilisateur connecté
        if ($user->id === Auth::id()) {
            return Redirect::back()->with('error', 'Vous ne pouvez pas supprimer votre propre compte.');
        }

        $user->delete();
        return Redirect::route('user.index')->with('success', 'Utilisateur supprimé avec succès.');
    }


}
