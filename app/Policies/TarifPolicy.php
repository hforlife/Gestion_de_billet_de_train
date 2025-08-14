<?php

namespace App\Policies;

use App\Models\User;
use App\Models\Tarif;

class TarifPolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->can('viewAny tarif');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, Tarif $Tarif): bool
    {
        return $user->can('view tarif');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->can('create tarif');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, Tarif $Tarif): bool
    {
        return $user->can('update tarif');
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, Tarif $Tarif): bool
    {
        return $user->can('delete tarif');
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, Tarif $Tarif): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, Tarif $Tarif): bool
    {
        return false;
    }
}
