<?php

namespace App\Enum;

enum statusPaiement: string
{
    //
    case Attente = 'en_attente';
    case Effectué = 'effectué';
    case Echoué = 'échoué';
}
