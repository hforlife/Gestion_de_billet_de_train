<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class PointsVente extends Model
{
    protected $fillable = ['gare_id', 'type', 'actif'];

    public function gare(): BelongsTo
    {
        return $this->belongsTo(Gare::class, 'gare_id');
    }

    // public function billets(): HasMany
    // {
    //     return $this->hasMany(Billet::class, 'point_vente_id');
    // }
}
