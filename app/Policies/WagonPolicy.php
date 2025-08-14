<?php

namespace App\Policies;

use App\Models\User;
use App\Models\Wagon;

class WagonPolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->can('viewAny wagon');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, Wagon $Wagon): bool
    {
        return $user->can('view wagon');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->can('create wagon');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, Wagon $Wagon): bool
    {
        return $user->can('update wagon');
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, Wagon $Wagon): bool
    {
        return $user->can('delete Wagon');
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, Wagon $Wagon): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, Wagon $Wagon): bool
    {
        return false;
    }
}
