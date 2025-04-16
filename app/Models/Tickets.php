<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Tickets extends Model
{
    //
    protected $fillable = [
        'numero',
        'voyage_id',
        'user_id',
        'prix',
        'status'
    ];

    public function voyage(){
        return $this->belongsTo(Voyages::class, 'voyage_id');
    }
    public function user(){
        return $this->belongsTo(User::class, 'user_id');
    }
}
