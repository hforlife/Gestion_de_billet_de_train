<?php

namespace App\Enum;

enum typePaiement: string
{
    //
    case Cash = 'cash';
    case Carte = 'carte';
    case Mobile = 'mobile_money';
}
