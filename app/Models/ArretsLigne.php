<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class ArretsLigne extends Model
{
    protected $table = 'arrets_ligne';
    protected $fillable = ['ligne_id', 'gare_id', 'ordre', 'distance_depart', 'vente_chef_train'];

    public function ligne(): BelongsTo
    {
        return $this->belongsTo(Ligne::class, 'ligne_id');
    }

    public function gare(): BelongsTo
    {
        return $this->belongsTo(Gare::class, 'gare_id');
    }
}
