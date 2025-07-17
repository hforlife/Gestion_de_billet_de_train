<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Vente extends Model
{
    protected $fillable = [
        'client_nom',
        'voyage_id',
        'prix',
        'quantite',
        'bagage',
        'poids_bagage',
        'place_id',
        'statut',
    ];

    public function scopeFilter($query, array $filters)
    {
        $query->when($filters['search'] ?? null, function ($query, $search) {
            $query->where(function ($query) use ($search) {
                $query->where('client_nom', 'like', "%{$search}%")
                    ->orWhereHas('voyage', fn($q) => $q->where('destination', 'like', "%{$search}%"));
            });
        });
    }

    public function voyage()
    {
        return $this->belongsTo(Voyage::class);
    }

    public function place()
    {
        return $this->belongsTo(Place::class);
    }
    public function train()
    {
        return $this->hasOneThrough(
            Train::class,
            Voyage::class,
            'id',       // Voyage id
            'id',       // Train id
            'voyage_id', // Foreign key in Vente
            'train_id'  // Foreign key in Voyage
        );
    }
}
