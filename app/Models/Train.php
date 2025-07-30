<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Train extends Model
{
    //
    protected $fillable = [
        'numero',
        'sens', // Sens du train, par exemple 'Bamako-Kayes' ou 'Kayes-Bamako'
        'etat',
        'nombre_agents',
    ];

    public function scopeFilter($query, array $filters)
    {
        $query->when($filters['search'] ?? null, function ($query, $search) {
            $query->where(function ($query) use ($search) {
                $query->where('numero', 'like', "%{$search}%")
                ->orWhere('etat', 'like', "%{$search}%");
            });
        });
    }

    public function wagons()
    {
        return $this->hasMany(Wagon::class);
    }
}
