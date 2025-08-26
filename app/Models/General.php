<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class General extends Model
{
    //
    protected $fillable = [
        'nom_app',
        'logo',
        'footer_text',
        'dark_mode',
    ];
}
