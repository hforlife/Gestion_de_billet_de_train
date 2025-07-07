<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Parametres extends Model
{

    protected $fillable = ['categorie_colis','poids_min', 'poids_max', 'prix_par_kg'];

    public function categorie()
{
    return $this->belongsTo(categorieColis::class);
}

}
