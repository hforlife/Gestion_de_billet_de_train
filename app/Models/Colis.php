<?php

namespace App\Models;

use App\Http\Controllers\categorieColisController;
use Illuminate\Database\Eloquent\Model;

class Colis extends Model
{
    //
    protected $fillable = [
        'user1',
        'user2',
        'poids',
        'tarif',
        'categorie_colis_id',
        'description',
        'statut',
    ];
    public function scopeFilter($query, array $filters)
{
    $query->when($filters['search'] ?? null, function ($query, $search) {
        $query->where(function ($q) use ($search) {
            $q->where('user1', 'like', "%{$search}%")
              ->orWhere('user2', 'like', "%{$search}%");
        });
    });
}
    public function categorieColis()
    {
        return $this->belongsTo(CategorieColis::class);
    }


}
