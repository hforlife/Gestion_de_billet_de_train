<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VoyageRecurrentJour extends Model
{
    //
    protected $fillable = [
        'voyage_recurrent_id',
        'jour_semaine_id', 
    ];
}
