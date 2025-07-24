<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Vente extends Model
{
    protected $fillable = [
        'client_nom',
        'voyage_id',
        'mode_paiement_id',
        'prix',
        'point_vente_id',
        'quantite',
        'bagage',
        'poids_bagage',
        'place_id',
        'statut',
    ];

    public function scopeFiltrer($query, $search, $voyageId)
    {
        return $query
            ->when($search, fn($q) => $q->where('client_nom', 'like', "%{$search}%"))
            ->when($voyageId, fn($q) => $q->where('voyage_id', $voyageId));
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
    public function modePaiement()
    {
        return $this->belongsTo(ModesPaiement::class);
    }

    public function pointVente()
    {
        return $this->belongsTo(PointsVente::class);
    }
}
