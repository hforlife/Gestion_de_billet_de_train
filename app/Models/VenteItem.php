<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VenteItem extends Model
{
    protected $fillable = [
        'vente_id',
        'tarif_gare_id',
        'quantite',
        'prix_unitaire',
        'prix_total'
    ];

    public function vente()
    {
        return $this->belongsTo(Vente::class);
    }

    public function tarifGare()
    {
        return $this->belongsTo(TarifsGare::class, 'tarif_gare_id');
    }
}
