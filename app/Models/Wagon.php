<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Wagon extends Model
{
    //
    protected $fillable = [
        'train_id',
        'nom', // Ex: Wagon A, B, etc.
        'nombre_places'
    ];

    public function scopeFilter($query, array $filters)
    {
        if ($filters['search'] ?? false) {
            $query->where('nom', 'like', '%' . request('search') . '%');
        }
    }

    public function train()
    {
        return $this->belongsTo(Train::class);
    }

    public function places()
    {
        return $this->hasMany(Place::class);
    }
}
