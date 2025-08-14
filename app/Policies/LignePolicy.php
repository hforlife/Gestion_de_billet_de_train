<?php

namespace App\Policies;

use App\Models\User;
use App\Models\Ligne;

class LignePolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->can('viewAny ligne');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, Ligne $Ligne): bool
    {
        return $user->can('view ligne');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->can('create ligne');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, Ligne $Ligne): bool
    {
        return $user->can('update ligne');
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, Ligne $Ligne): bool
    {
        return $user->can('delete ligne');
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, Ligne $Ligne): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, Ligne $Ligne): bool
    {
        return false;
    }
}
