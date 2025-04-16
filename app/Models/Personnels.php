<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Personnels extends Model
{
    //
    protected $fillable = [
        'user_id',
        'poste',
        'gare_id',
    ];

    public function user(){
        return $this->belongsTo(User::class, 'user_id');
    }
    public function gare(){
        return $this->belongsTo(Gares::class, 'gare_id');
    }
}
