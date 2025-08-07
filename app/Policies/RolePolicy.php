<?php

namespace App\Policies;

use App\Models\User;
use Spatie\Permission\Models\Role;

class RolePolicy
{
    public function viewAny(User $user)
    {
        return $user->can('view roles');
    }

    public function view(User $user, Role $role)
    {
        return $user->can('view roles');
    }

    public function create(User $user)
    {
        return $user->can('manage roles');
    }

    public function update(User $user, Role $role)
    {
        return $user->can('manage roles');
    }

    public function delete(User $user, Role $role)
    {
        return $user->can('manage roles') && !in_array($role->name, ['admin', 'chef', 'caissier']);
    }
}
