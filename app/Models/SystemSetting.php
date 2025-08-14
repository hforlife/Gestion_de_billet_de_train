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
        'coefficients_classes',
    ];
    protected $casts = [
        'coefficients_classes' => 'array',
    ];
}
