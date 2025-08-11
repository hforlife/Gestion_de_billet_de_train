<?php

namespace App\Policies;

use App\Models\User;
use App\Models\Colis;

class ColisPolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->can('viewAny colis');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, Colis $Colis): bool
    {
        return $user->can('view colis');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->can('create colis');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, Colis $Colis): bool
    {
        return $user->can('update colis');
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, Colis $Colis): bool
    {
        return $user->can('delete colis');
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, Colis $Colis): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, Colis $Colis): bool
    {
        return false;
    }
}
