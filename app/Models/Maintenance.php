<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Maintenance extends Model
{
    //
    protected $table = 'maintenances';
    protected $fillable = [
        'train_id',
        'date_debut',
        'date_fin_prevue',
        'date_fin_reelle',
        'description',
        'statut',
    ];
    public function train()
    {
        return $this->belongsTo(Train::class);
    }
}
