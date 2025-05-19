<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Trains extends Model
{
    //
    protected $fillable = [
        'numero',
        'capacite',
        'etat'
    ];
    public function scopeFilter($query, array $filters)
{
    $query->when($filters['search'] ?? null, function ($query, $search) {
        $query->where(function ($query) use ($search) {
            $query->where('numero', 'like', "%{$search}%")
                  ->orWhere('capacite', 'like', "%{$search}%")
                  ->orWhere('etat', 'like', "%{$search}%");
        });
    });
}
}
