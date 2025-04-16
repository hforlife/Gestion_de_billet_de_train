<?php

namespace App\Enum;

enum statusVoyage: string
{
    //
    case Programmé = 'programmé';
    case En_cours = 'en_cours';
    case Termoiné = 'terminé';
    case Annulé = 'annulé';
}
