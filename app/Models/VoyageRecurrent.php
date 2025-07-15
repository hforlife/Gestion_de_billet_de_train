<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VoyageRecurrent extends Model
{
    //
    protected $fillable = [
        'name',
        'train_id',
        'gare_depart_id',
        'gare_arrivee_id',
        'heure_depart',
        'prix',
        'statut', // actif ou inactif
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
        return $this->belongsTo(Train::class, 'train_id');
    }

    public function gare_depart()
    {
        return $this->belongsTo(Gare::class, 'gare_depart_id');
    }

    public function gare_arrivee()
    {
        return $this->belongsTo(Gare::class, 'gare_arrivee_id');
    }
    public function arrets()
    {
        return $this->hasMany(Arret::class)->orderBy('ordre');
    }
}
