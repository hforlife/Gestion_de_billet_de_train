<?php

namespace App\Policies;

use App\Models\User;
use App\Models\Voyage;

class VoyagePolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->can('viewAny voyage');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, Voyage $Voyage): bool
    {
        return $user->can('view voyage');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->can('create Voyage');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, Voyage $Voyage): bool
    {
        return $user->can('update voyage');
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, Voyage $Voyage): bool
    {
        return $user->can('delete voyage');
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, Voyage $Voyage): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, Voyage $Voyage): bool
    {
        return false;
    }
}
