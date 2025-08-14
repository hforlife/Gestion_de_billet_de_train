<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Place extends Model
{
    //
    protected $fillable = [
        'wagon_id',
        'numero'
    ];

    public function wagon()
    {
        return $this->belongsTo(Wagon::class);
    }

     public function ventes()
    {
        return $this->hasMany(Vente::class);
    }


}
