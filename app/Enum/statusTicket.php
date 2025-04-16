<?php

namespace App\Enum;

enum statusTicket: string
{
    //
    case Valide = 'valide';
    case Annulé = 'annulé';
    case Utilisé = 'utilisé';
}
