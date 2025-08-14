<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Ligne extends Model
{
    protected $fillable = ['nom', 'gare_depart_id', 'gare_arrivee_id', 'distance_totale'];

    public function scopeFilter($query, array $filters)
    {
        $query->when($filters['search'] ?? null, function ($query, $search) {
            $query->where(function ($query) use ($search) {
                $query->where('nom', 'like', "%{$search}%")
                ->orWhereHas('gareDepart', fn($q) => $q->where('nom', 'like', "%{$search}%"));
            });
        });
    }

    public function gareDepart(): BelongsTo
    {
        return $this->belongsTo(Gare::class, 'gare_depart_id');
    }

    public function gareArrivee(): BelongsTo
    {
        return $this->belongsTo(Gare::class, 'gare_arrivee_id');
    }

    public function arrets(): HasMany
    {
        return $this->hasMany(ArretsLigne::class, 'ligne_id');
    }

    public function voyages(): HasMany
    {
        return $this->hasMany(Voyage::class, 'ligne_id');
    }

    public function classeWagon(): BelongsTo
    {
        return $this->belongsTo(ClassesWagon::class, 'classe_wagon_id');
    }
}
