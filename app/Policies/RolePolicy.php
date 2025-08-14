<?php

namespace App\Policies;

use App\Models\User;
use Spatie\Permission\Models\Role;

class RolePolicy
{
    public function viewAny(User $user)
    {
        return $user->can('viewAny role');
    }

    public function view(User $user, Role $role)
    {
        return $user->can('viewAny role');
    }

    public function create(User $user)
    {
        return $user->can('create role');
    }

    public function update(User $user, Role $role)
    {
        return $user->can('update role');
    }

    public function delete(User $user, Role $role)
    {
        return $user->can('delete role') && !in_array($role->name, ['admin', 'chef', 'caissier']);
    }
}
