<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Arrets extends Model
{
    //
    protected $fillable = [
        'voyage_id',
        'gare_id',
        'heure_arrivee',
        'heure_depart',
        'ordre' // ordre de passage,
    ];

    // Arrets.php (Model)
    public function scopeFilter($query, array $filters)
    {
        if (!empty($filters['search'])) {
            $search = $filters['search'];

            $query->whereHas(
                'gare',
                fn($q) =>
                $q->where('nom', 'like', "%{$search}%")
            )->orWhereHas(
                    'voyage',
                    fn($q) =>
                    $q->where('name', 'like', "%{$search}%")
                );
        }
    }


    public function voyage()
    {
        return $this->belongsTo(Voyages::class);
    }

    public function gare()
    {
        return $this->belongsTo(Gares::class);
    }
}
