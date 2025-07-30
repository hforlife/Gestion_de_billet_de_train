<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Voyage extends Model
{
    protected $fillable = [
        'nom',
        'train_id',
        'ligne_id',
        'date_depart',
        'date_arrivee',
        'statut',
    ];


    public function tarifs()
    {
        return $this->hasMany(TarifsGare::class);
    }

    public function classesDisponibles()
    {
        return $this->belongsToMany(ClassesWagon::class, 'tarifs_gares')
            ->withPivot('prix', 'date_effet', 'date_expiration');
    }
    public function gareDepart()
    {
        return $this->belongsTo(ArretsLigne::class, 'depart_id');
    }

    public function gareArrivee()
    {
        return $this->belongsTo(ArretsLigne::class, 'arrivee_id');
    }

    public function train()
    {
        return $this->belongsTo(Train::class);
    }

    public function ligne()
    {
        return $this->belongsTo(Ligne::class);
    }


    public function ventes(): HasMany
    {
        return $this->hasMany(Vente::class);
    }

    public function tarifsVoyage()
    {
        return $this->hasMany(TarifVoyage::class);
    }

    // public function classesWagon()
    // {
    //     return $this->;
    // }


    // Calcul du prix en fonction de la classe
    public function getPrixForClasse($classeWagonId)
    {
        return $this->tarif->where('classe_wagon_id', $classeWagonId)
            ->where('date_effet', '<=', now())
            ->where(function ($query) {
                $query->where('date_expiration', '>=', now())
                    ->orWhereNull('date_expiration');
            })
            ->first()
            ?->prix ?? 0;
    }
}
