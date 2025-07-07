<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Wagons extends Model
{
    //
    protected $fillable = [
        'train_id',
        'nom', // Ex: Wagon A, B, etc.
        'nombre_places'
    ];
    public function train()
    {
        return $this->belongsTo(Trains::class);
    }
    public function ventes()
    {
        return $this->hasMany(Ventes::class);
    }
}
