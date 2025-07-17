<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CategorieColis extends Model
{
    //
    protected $fillable = ['nom', 'description'];

    public function colis()
    {
        return $this->hasMany(Colis::class);
    }

    public function parametre()
{
    return $this->hasMany(Parametre::class, 'categorie_id');
}


    // app/Models/categorieColis.php
    public function scopeFilter($query, array $filters)
    {
        if (!empty($filters['search'])) {
            $query->where('nom', 'ILIKE', '%' . $filters['search'] . '%');
        }
    }


}
