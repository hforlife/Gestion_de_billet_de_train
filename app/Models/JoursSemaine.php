<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class JoursSemaine extends Model
{
    //
    protected $fillable = [
        'nom', // Nom du jour de la semaine
        'code', // Code unique pour le jour (par exemple, 'LUN' pour lundi)
    ];
    protected $table = 'jours_semaine'; // Nom de la table dans la base de données
    public $timestamps = false; // Pas de timestamps pour cette table
}
