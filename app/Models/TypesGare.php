<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class TypesGare extends Model
{
    protected $table = 'types_gare';
    protected $fillable = ['type', 'description'];

    public function gares(): HasMany
    {
        return $this->hasMany(Gare::class, 'type_gare_id');
    }
}
