<?php

namespace App\Policies;

use App\Models\User;
use App\Models\CategorieColis;

class CategorieColisPolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->can('viewAny categorie_colis');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, CategorieColis $CategorieColis): bool
    {
        return $user->can('view categorie_colis');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->can('create categorie_colis');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, CategorieColis $CategorieColis): bool
    {
        return $user->can('update categorie_colis');
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, CategorieColis $CategorieColis): bool
    {
        return $user->can('delete categorie_colis');
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, CategorieColis $CategorieColis): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, CategorieColis $CategorieColis): bool
    {
        return false;
    }
}
