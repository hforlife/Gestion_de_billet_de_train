<?php

namespace App\Policies;

use App\Models\User;
use App\Models\PointsVente;

class PointsVentePolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->can('viewAny point_vente');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, PointsVente $PointsVente): bool
    {
        return $user->can('view point_vente');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->can('create point_vente');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, PointsVente $PointsVente): bool
    {
        return $user->can('update point_vente');
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, PointsVente $PointsVente): bool
    {
        return $user->can('delete point_vente');
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, PointsVente $PointsVente): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, PointsVente $PointsVente): bool
    {
        return false;
    }
}
