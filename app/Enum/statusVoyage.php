<?php

namespace App\Enum;

enum statusVoyage: string
{
    //
    case Programmé = 'programmé';
    case EnCours = 'en_cours';
    case Terminé = 'terminé';
    case Annulé = 'annulé';
}
