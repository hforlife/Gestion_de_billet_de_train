<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;

class Distance extends Model
{
    //
    public $table = 'distances_gares';
    public $timestamps = false;
    public $fillable = [
        'gare_depart_id',
        'gare_arrivee_id',
        'distance_km',
    ];
    public function gareDepart()
    {
        return $this->belongsTo('App\Models\Gare', 'gare_depart_id');
    }
    public function gareArrivee()
    {
        return $this->belongsTo('App\Models\Gare', 'gare_arrivee_id');
    }

        public function scopeFilter(Builder $query, array $filters): Builder
    {
        return $query
            ->when($filters['search'] ?? null, function ($query, $search) {
                $query->where('gare_depart', 'like', "%{$search}%")
                    ->orWhere('gare_arrivee', 'like', "%{$search}%");
            });
    }
}
