<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Employees extends Model
{
    //
    protected $fillable = [
        'name',
        'section',
        'salaire',
        'date_de_debut',
        'gare_id',
    ];

    public function section(){
        return $this->belongsTo(Sections::class, 'section_id');
    }
    public function gare(){
        return $this->belongsTo(Gares::class, 'gare_id');
    }
}
