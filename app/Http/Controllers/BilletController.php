<?php

namespace App\Http\Controllers;

use App\Models\Ventes;
use Illuminate\Http\Request;
use Barryvdh\DomPDF\Facade\Pdf;

class BilletController extends Controller
{
    //Génération du billet PDF
public function generateBillet($id)
{
    // 1. Récupération des données
    $vente = Ventes::with(['voyage', 'train'])->findOrFail($id);

    // 2. Personnalisation du format (optionnel)
    $customPaper = [0, 0, 360, 360]; // Format carré (ex: pour un billet)

    // 3. Génération du PDF
    $pdf = Pdf::loadView('pdf.billets', compact('vente'))
              ->setPaper($customPaper); // Ou 'A4', 'landscape'

    // 4. Options supplémentaires (ex: polices intégrées)
    $pdf->getDomPDF()->set_option('defaultFont', 'Courier');

    // 5. Retour en stream avec nom de fichier dynamique
    return $pdf->stream("billet_train_{$vente->id}.pdf");
}
}
