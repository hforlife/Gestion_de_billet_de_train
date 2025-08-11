<?php

namespace App\Policies;

use App\Models\User;
use App\Models\Train;

class TrainPolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->can('viewAny train');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, Train $Train): bool
    {
        return $user->can('view train');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->can('create train');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, Train $Train): bool
    {
        return $user->can('update train');
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, Train $Train): bool
    {
        return $user->can('delete train');
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, Train $Train): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, Train $Train): bool
    {
        return false;
    }
}
