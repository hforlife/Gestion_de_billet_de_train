<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOneThrough;

class Vente extends Model
{
    protected $fillable = [
        'client_nom',
        'voyage_id',
        'mode_paiement_id',
        'point_vente_id',
        'classe_wagon_id',
        'prix',
        'demi_tarif',
        'date_vente',
        'quantite',
        'bagage',
        'poids_bagage',
        'place_id',
        'penalite',
        'reference',
        'qrcode',
        'statut',
    ];

    protected $casts = [
        'demi_tarif' => 'boolean',
        'bagage' => 'boolean',
        'date_vente' => 'datetime',
        'prix' => 'decimal:2',
    ];

    protected $appends = [
        'total',
        'is_demi_tarif',
        'has_bagage',
    ];

    public function scopeFiltrer($query, $search = null, $voyageId = null)
    {
        return $query
            ->when($search, fn($q) => $q->where('client_nom', 'like', "%{$search}%"))
            ->when($voyageId, fn($q) => $q->where('voyage_id', $voyageId))
            ->with(['voyage', 'place', 'modePaiement', 'pointVente', 'classeWagon']);
    }

    public function voyage(): BelongsTo
    {
        return $this->belongsTo(Voyage::class);
    }

    public function place(): BelongsTo
    {
        return $this->belongsTo(Place::class)->with('wagon');
    }

    public function train(): HasOneThrough
    {
        return $this->hasOneThrough(
            Train::class,
            Voyage::class,
            'id',
            'id',
            'voyage_id',
            'train_id'
        );
    }

    public function modePaiement(): BelongsTo
    {
        return $this->belongsTo(ModesPaiement::class, 'mode_paiement_id');
    }

    public function pointVente(): BelongsTo
    {
        return $this->belongsTo(PointsVente::class, 'point_vente_id');
    }

    public function items(): HasMany
    {
        return $this->hasMany(VenteItem::class);
    }

    public function classeWagon(): BelongsTo
    {
        return $this->belongsTo(ClassesWagon::class, 'classe_wagon_id');
    }

    public function getTotalAttribute(): float
    {
        return $this->prix * $this->quantite;
    }

    public function getIsDemiTarifAttribute()
    {
        return $this->demi_tarif;
    }

    public function getHasBagageAttribute(): bool
    {
        return $this->bagage && $this->poids_bagage > 0;
    }
}
