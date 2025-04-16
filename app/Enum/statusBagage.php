<?php

namespace App;

enum statusBagage: string
{
    //
    case Enregistre = 'enregistré';
    case Attente = 'perdu';
    case Livré = 'livré';
}
