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
        $this->authorize('view roles');

        return Inertia::render('Setting/Role/Index', [
            'roles' => Role::with('permissions')->get()->map(function ($role) {
                return [
                    'id' => $role->id,
                    'name' => $role->name,
                    'display_name' => $role->display_name,
                    'permissions' => $role->permissions->pluck('name')
                ];
            }),
            'permissions' => Permission::all()->groupBy('module')
        ]);
    }

    public function store(Request $request)
    {
        $this->authorize('manage roles');

        $validated = $request->validate([
            'name' => 'required|string|unique:roles',
            'display_name' => 'required|string',
            'permissions' => 'array'
        ]);

        $role = Role::create([
            'name' => $validated['name'],
            'display_name' => $validated['display_name'],
            'guard_name' => 'web'
        ]);

        if (!empty($validated['permissions'])) {
            $role->syncPermissions($validated['permissions']);
        }

        return redirect()->back()->with('success', 'Rôle créé avec succès');
    }

    public function update(Request $request, Role $role)
    {
        $this->authorize('manage roles');

        $validated = $request->validate([
            'display_name' => 'required|string',
            'permissions' => 'array'
        ]);

        $role->update(['display_name' => $validated['display_name']]);
        $role->syncPermissions($validated['permissions'] ?? []);

        return redirect()->back()->with('success', 'Rôle mis à jour');
    }

    public function destroy(Role $role)
    {
        $this->authorize('manage roles');

        if (in_array($role->name, ['admin', 'chef', 'caissier'])) {
            return redirect()->back()->with('error', 'Ce rôle système ne peut être supprimé');
        }

        $role->delete();
        return redirect()->back()->with('success', 'Rôle supprimé');
    }
}
