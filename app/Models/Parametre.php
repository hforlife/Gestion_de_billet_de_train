<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Parametre extends Model
{

    protected $fillable = ['categorie_id', 'poids_min', 'poids_max', 'prix_par_kg'];

    public function categorie()
    {
        return $this->belongsTo(CategorieColis::class, 'categorie_id');
    }


}
