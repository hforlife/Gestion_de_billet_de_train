<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Gares extends Model
{
    //
    protected $fillable = [
        'nom',
        'adresse',
    ];
    public function scopeFilter($query, array $filters)
{
    $query->when($filters['search'] ?? null, function ($query, $search) {
        $query->where(function ($query) use ($search) {
            $query->where('nom', 'like', "%{$search}%")
                  ->orWhere('adresse', 'like', "%{$search}%");
        });
    });
}
}
