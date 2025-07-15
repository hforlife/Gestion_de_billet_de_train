<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Bagage extends Model
{
    //
    protected $fillable = [
        'vente_id',
        'poids', // Type de bagage (valise, sac à dos, etc.)
        'tarif', // Poids du bagage en kg
        'description', // Dimensions du bagage (longueur x largeur x hauteur)
    ];

    public function vente()
    {
        return $this->belongsTo(Vente::class);
    }
}
