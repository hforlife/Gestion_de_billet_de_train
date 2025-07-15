<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Rapport extends Model
{
    //
    protected $fillable = [
        'chef_gare_id',
        'contenu',
        'date',
    ];

    public function chef_gare(){
        return $this->belongsTo(User::class, 'chef_gare_id');
    }
}
