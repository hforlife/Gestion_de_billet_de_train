<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Wagon extends Model
{
    protected $fillable = [
        'train_id',
        'classe_id',
        'numero_wagon',
        'nombre_sieges',
        'sieges_disponibles',
    ];

    /**
     * Scope de filtrage par numéro de wagon.
     */
    public function scopeFilter($query, array $filters)
    {
        if (!empty($filters['search'])) {
            $query->where('numero_wagon', 'like', '%' . $filters['search'] . '%');
        }
    }

    /**
     * Relation : Wagon appartient à un train.
     */
    public function train(): BelongsTo
    {
        return $this->belongsTo(Train::class);
    }

    /**
     * Relation : Wagon appartient à une classe (1ère, 2ème, etc).
     */
    public function classeWagon(): BelongsTo
    {
        return $this->belongsTo(ClassesWagon::class);
    }

    /**
     * Relation : Wagon possède plusieurs places.
     */
    public function places(): HasMany
    {
        return $this->hasMany(Place::class);
    }
}
