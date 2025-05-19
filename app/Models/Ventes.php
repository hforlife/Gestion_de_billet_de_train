<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Ventes extends Model
{
    protected $fillable = [
        'client_nom',
        'voyage_id',
        'prix',
        'train_id',
        'bagage',
        'poids_bagage',
        'status',
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
        return $this->belongsTo(Voyages::class);
    }

    public function train()
    {
        return $this->belongsTo(Trains::class);
    }
}

