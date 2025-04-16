<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Bagages extends Model
{
    //
    protected $fillable = [
        'user1',
        'user2',
        'poids',
        'tarif',
        'status',
    ];

}
