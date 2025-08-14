<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Builder;

class Tarif extends Model
{
    protected $fillable = [
        'ligne_id',
        'classe_wagon_id',
        'prix_base',
        'date_effet',
        'date_expiration'
    ];

    protected $casts = [
        'date_effet' => 'datetime',
        'date_expiration' => 'datetime',
    ];

    public function ligne(): BelongsTo
    {
        return $this->belongsTo(Ligne::class);
    }

    public function classeWagon(): BelongsTo
    {
        return $this->belongsTo(ClassesWagon::class, 'classe_wagon_id');
    }

    public function scopeActive(Builder $query): Builder
    {
        return $query->where('date_effet', '<=', now())
            ->where(function($query) {
                $query->where('date_expiration', '>=', now())
                      ->orWhereNull('date_expiration');
            });
    }
}
