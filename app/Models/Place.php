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

    public function vente()
    {
        return $this->hasOne(Vente::class); // une place peut être liée à une seule vente
    }

}
