<?php

use App\Models\Distance;
use App\Models\SystemSetting;
use App\Models\Vente;

class SalePriceCalculator
{
    public static function computePriceForVoyageMode(Vente $vente)
    {
        // Mode par voyage : on suppose que le voyage a des tarifs gares associés
        // Ex : si le voyage a plusieurs tarifs, on peut sommer ou choisir en fonction
        // Ici exemple simplifié : prix de base depuis la place/classe via relation.
        // Adapte selon ta logique existante.
        return $vente->prix; // déjà renseigné en amont
    }

    public static function computePriceByKilometrage($departGareId, $arriveeGareId, $classeWagonId, SystemSetting $setting)
    {
        // Récupérer la distance (simplification : A→B ou B→A)
        $distance = Distance::where(function ($q) use ($departGareId, $arriveeGareId) {
            $q->where('gare_depart_id', $departGareId)
              ->where('gare_arrivee_id', $arriveeGareId);
        })->orWhere(function ($q) use ($departGareId, $arriveeGareId) {
            $q->where('gare_depart_id', $arriveeGareId)
              ->where('gare_arrivee_id', $departGareId);
        })->first();

        if (!$distance) {
            throw new \Exception("Distance introuvable entre les gares.");
        }

        $base = $distance->distance_km * ($setting->tarif_kilometrique ?? 0);

        // Coefficient de classe
        $coeffs = json_decode($setting->coefficients_classes, true) ?? [];
        $coef = $coeffs[$classeWagonId] ?? 1.0;

        $calculated = $base * $coef;

        // Appliquer tarif minimum
        $final = max($calculated, $setting->tarif_minimum);

        // Arrondir si nécessaire
        return round($final, 2);
    }
}

