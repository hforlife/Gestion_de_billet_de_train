<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Voyage extends Model
{
    protected $fillable = [
        'name',
        'train_id',
        'gare_depart_id',
        'gare_arrivee_id',
        'date_depart',
        'date_arrivee',
        'prix',
        'statut',
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
            return $this->belongsTo(Train::class);
        }

        public function gare_depart()
        {
            return $this->belongsTo(Gare::class, 'gare_depart_id');
        }

        public function gare_arrivee()
        {
            return $this->belongsTo(Gare::class, 'gare_arrivee_id');
        }

}
