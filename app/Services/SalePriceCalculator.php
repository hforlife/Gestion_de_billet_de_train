<?php
namespace App\Services;

use App\Models\Ligne;
use App\Models\SystemSetting;

class SalePriceCalculator
{
    public static function computePriceByKilometrage(
        Ligne $ligne,
        int $gareDepartId,
        int $gareArriveeId,
        int $classeWagonId,
        SystemSetting $setting
    ): float {
        if ($setting->mode_vente !== 'par_kilometrage') {
            return 0;
        }

        // Récupération des arrêts de la ligne triés par ordre
        $arrets = $ligne->arrets()->orderBy('ordre')->get();

        $depart = $arrets->firstWhere('gare_id', $gareDepartId);
        $arrivee = $arrets->firstWhere('gare_id', $gareArriveeId);

        if (!$depart || !$arrivee) {
            return 0; // Une des deux gares n'existe pas dans cette ligne
        }

        // Calcul de la distance (toujours positif)
        $distanceKm = abs($arrivee->distance_depart - $depart->distance_depart);

        if ($distanceKm <= 0) {
            return 0;
        }

        // Tarif kilométrique
        $tarifKm = floatval($setting->tarif_kilometrique);
        if ($tarifKm <= 0) {
            return 0;
        }

        // Coefficient de la classe
        $coefficient = 1.0;
        $coeffs = is_string($setting->coefficients_classes)
            ? json_decode($setting->coefficients_classes, true)
            : $setting->coefficients_classes ?? [];

        if (isset($coeffs[$classeWagonId])) {
            $coefficient = floatval($coeffs[$classeWagonId]);
        }

        $prix = $tarifKm * $distanceKm * $coefficient;

        // Application du tarif minimum
        $tarifMinimum = floatval($setting->tarif_minimum);
        if ($tarifMinimum > 0 && $prix < $tarifMinimum) {
            $prix = $tarifMinimum;
        }

        return $prix;
    }
}
