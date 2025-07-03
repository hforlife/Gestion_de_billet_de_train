<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Voyages extends Model
{
    protected $fillable = [
        'name',
        'train_id',
        'gare_depart_id',
        'gare_arrivee_id',
        'date_depart',
        'date_arrivee',
        'prix',
        'statut',
    ];

    public function scopeFilter($query, array $filters)
    {
        $query->when($filters['search'] ?? null, function ($query, $search) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('prix', 'like', "%{$search}%");
            });
        });
    }

    public function train()
    {
        return $this->belongsTo(Trains::class, 'train_id');
    }

    public function gare_depart()
    {
        return $this->belongsTo(Gares::class, 'gare_depart_id');
    }

    public function gare_arrivee()
    {
        return $this->belongsTo(Gares::class, 'gare_arrivee_id');
    }
    public function arrets()
    {
        return $this->hasMany(Arrets::class)->orderBy('ordre');
    }
}
