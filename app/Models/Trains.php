<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Trains extends Model
{
    //
    protected $fillable = [
        'nom',
        'capacite',
        'etat'
    ];
}
