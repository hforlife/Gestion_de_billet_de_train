<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class ModesPaiement extends Model
{

    protected $table = 'modes_paiement';
    protected $fillable = ['type'];

    public function scopeFilter($query, array $filters)
    {
        $query->when($filters['search'] ?? null, function ($query, $search) {
            $query->where(function ($query) use ($search) {
                $query->where('type', 'like', "%{$search}%");
            });
        });
    }
}
