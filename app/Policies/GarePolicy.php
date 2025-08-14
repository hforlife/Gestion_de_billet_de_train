<?php

namespace App\Policies;

use App\Models\User;
use App\Models\Gare;

class GarePolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->can('viewAny gare');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, Gare $Gare): bool
    {
        return $user->can('view gare');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->can('create gare');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, Gare $Gare): bool
    {
        return $user->can('update gare');
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, Gare $Gare): bool
    {
        return $user->can('delete gare');
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, Gare $Gare): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, Gare $Gare): bool
    {
        return false;
    }
}
