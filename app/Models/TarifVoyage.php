<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class TarifVoyage extends Model
{
    use HasFactory;

    protected $table = 'tarifs_voyage';

    protected $fillable = [
        'voyage_id',
        'tarif_gare_id',
    ];

    public function voyage()
    {
        return $this->belongsTo(Voyage::class);
    }

    public function tarifGare()
    {
        return $this->belongsTo(TarifsGare::class, 'tarif_gare_id');
    }

}
