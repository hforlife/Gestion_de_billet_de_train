<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Gare extends Model
{
    //
    protected $fillable = [
        'nom',
        'adresse',
    ];

    public function scopeFilter($query, array $filters)
    {
        $query->when($filters['search'] ?? null, function ($query, $search) {
            $query->where(function ($query) use ($search) {
                $query->where('nom', 'like', "%{$search}%")
                    ->orWhere('adresse', 'like', "%{$search}%");
            });
        });

    }
    public function arrets()
    {
        return $this->hasMany(Arret::class);
    }
}
