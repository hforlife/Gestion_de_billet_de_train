<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SystemSetting extends Model
{
    //
    protected $table = 'system_settings';
    protected $fillable = [
        'mode_vente',
        'tarif_kilometrique',
        'tarif_minimum',
        'penalite',
        'bagage_kg',
    ];
}
