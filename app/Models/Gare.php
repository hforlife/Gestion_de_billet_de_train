<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;

class Gare extends Model
{
    //
        protected $fillable = [
        'nom', 'adresse', 'type', 'distance_km',
        'internet', 'electricite', 'nombre_guichets', 'controle_bagage'
    ];

    protected $casts = [
        'internet' => 'boolean',
        'electricite' => 'boolean',
    ];

    public function scopeFilter(Builder $query, array $filters): Builder
    {
        return $query
            ->when($filters['search'] ?? null, function ($query, $search) {
                $query->where('nom', 'like', "%{$search}%")
                    ->orWhere('adresse', 'like', "%{$search}%");
            })
            ->when($filters['type_gare'] ?? null, function ($query, $type) {
                $query->where('type_gare_id', $type);
            });
    }


    public function arrets()
    {
        return $this->hasMany(ArretsLigne::class);
    }
}
