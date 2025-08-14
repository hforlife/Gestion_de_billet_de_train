<?php

namespace App\Http\Controllers;

use Inertia\Inertia;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;
use Illuminate\Http\Request;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class RoleController extends Controller
{
    use AuthorizesRequests;
    public function index()
    {
        $this->authorize('viewAny role');

        return Inertia::render('Setting/Role/Index', [
            'roles' => Role::with('permissions')->paginate(10)->through(fn($role) => [
                'id' => $role->id,
                'name' => $role->name,
                'permissions' => $role->permissions->pluck('name')
            ],),
            'permissions' => Permission::all()->groupBy('module')
        ]);
    }

    public function create()
    {
        $this->authorize('create role');

        return Inertia::render('Setting/Role/Create', [
            'permissions' => Permission::all()
        ]);
    }

    public function store(Request $request)
    {
        $this->authorize('create role');

        $validated = $request->validate([
            'name' => 'required|string|unique:roles',
            'permissions' => 'array'
        ]);

        // dd($validated['permissions']);

        $role = Role::create([
            'name' => $validated['name'],
        ]);

        if (!empty($validated['permissions'])) {
            $role->syncPermissions($validated['permissions']);
        }

        return redirect()->route('role.index')->with('success', 'Rôle créé avec succès');
    }

    public function edit(Role $role)
    {
        $this->authorize('update role');

        return Inertia::render('Setting/Role/Edit', [
            'roles' => $role->load('permissions'),
            'permissions' => Permission::all()
        ]);
    }

    public function update(Request $request, Role $role)
    {
        $this->authorize('update role');

        $validated = $request->validate([
            'name' => 'required|string|unique:roles,name,' . $role->id,
            'permissions' => 'array'
        ]);
        // if (in_array($role->name, ['admin', 'chef', 'caissier'])) {
        //     return redirect()->back()->with('error', 'Ce rôle système ne peut être modifié');
        // }
        // dd($validated['permissions']);

        $role->syncPermissions($validated['permissions'] ?? []);

        return redirect()->route('role.index')->with('success', 'Rôle mis à jour');
    }

    public function destroy(Role $role)
    {
        $this->authorize('delete role');

        if (in_array($role->name, ['admin', 'chef', 'caissier'])) {
            return redirect()->back()->with('error', 'Ce rôle système ne peut être supprimé');
        }

        $role->delete();
        return redirect()->back()->with('success', 'Rôle supprimé');
    }
}
