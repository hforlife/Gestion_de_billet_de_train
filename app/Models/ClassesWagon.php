<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class ClassesWagon extends Model
{
    protected $table = 'classes_wagon';
    protected $fillable = ['classe', 'prix_multiplier'];

    public function scopeFilter($query, array $filters)
    {
        $query->when($filters['search'] ?? null, function ($query, $search) {
            $query->where(function ($query) use ($search) {
                $query->where('classe', 'like', "%{$search}%");
            });
        });
    }
    public function wagons(): HasMany
    {
        return $this->hasMany(Wagon::class, 'classe_id');
    }
}
