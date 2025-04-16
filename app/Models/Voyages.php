<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Voyages extends Model
{
    //
    protected $fillable = [
        'train_id',
        'gare_depart',
        'gare_arrivee',
        'date_depart',
        'date_arrivee',
        'status',
    ];

    public function train(){
        return $this->belongsTo(Trains::class, 'train_id');
    }

    public function gare_depart(){
        return $this->belongsTo(Gares::class, 'gare_depart');
    }

    public function gare_arrivee(){
        return $this->belongsTo(Gares::class, 'gare_arrivee');
    }
}
