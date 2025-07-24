<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Voyage extends Model
{
    protected $fillable = [
        'nom',
        'train_id',
        'ligne_id',
        'tarif_id',
        'date_depart',
        'date_arrivee',
        'statut',
    ];

    protected $casts = [
        'date_depart' => 'datetime',
        'date_arrivee' => 'datetime',
    ];

    public function train(): BelongsTo
    {
        return $this->belongsTo(Train::class);
    }

    public function ligne(): BelongsTo
    {
        return $this->belongsTo(Ligne::class);
    }

    public function tarif(): BelongsTo
    {
        return $this->belongsTo(Tarif::class);
    }

    public function arrets(): HasMany
    {
        return $this->hasMany(ArretsLigne::class)->orderBy('ordre');
    }

    public function ventes(): HasMany
    {
        return $this->hasMany(Vente::class);
    }

    // Calcul du prix en fonction de la classe
    public function getPrixForClasse($classeWagonId)
    {
        return $this->tarif->where('classe_wagon_id', $classeWagonId)
            ->where('date_effet', '<=', now())
            ->where(function($query) {
                $query->where('date_expiration', '>=', now())
                      ->orWhereNull('date_expiration');
            })
            ->first()
            ?->prix_base ?? 0;
    }
}
