<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Builder;

class TarifsGare extends Model
{
    protected $fillable = [
        'voyage_id',
        'classe_wagon_id',
        'prix',
        'date_effet',
        'date_expiration'
    ];

    protected $casts = [
        'date_effet' => 'datetime',
        'date_expiration' => 'datetime',
    ];
   public function voyage()
{
    return $this->belongsTo(Voyage::class);
}

public function classeWagon()
{
    return $this->belongsTo(ClassesWagon::class);
}
    public function ligne()
    {
        return $this->belongsTo(Ligne::class);
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
