<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CategorieColis extends Model
{
    //
    protected $fillable = ['nom', 'description'];

    public function colis()
    {
        return $this->hasMany(Colis::class, 'categorie_id');
    }

    public function parametres()
{
    return $this->hasMany(Parametres::class, 'categorie_id');
}


    // app/Models/CategorieColis.php
    public function scopeFilter($query, array $filters)
    {
        if (!empty($filters['search'])) {
            $query->where('nom', 'ILIKE', '%' . $filters['search'] . '%');
        }
    }


}
