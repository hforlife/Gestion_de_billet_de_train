<?php

namespace App\Http\Controllers;

use App\Models\Vente;
use Illuminate\Http\Request;
use FPDF;

class BilletController extends Controller
{
    public function generateBillet($id)
    {
        $vente = Vente::with(['voyage', 'train', 'place.wagon'])->findOrFail($id);

        // Création du PDF en format paysage (150x100mm)
        $pdf = new FPDF('L', 'mm', [150, 100]);
        $pdf->AddPage();
        $pdf->SetMargins(8, 8, 8);

        // Couleurs personnalisées
        $primaryColor = [0, 60, 110]; // Bleu SOPAFER
        $secondaryColor = [220, 230, 240]; // Fond clair

        // Logo avec taille ajustée
        $pdf->Image(public_path('assets/images/icon_white.png'), 10, 8, 25);

        // En-tête
        $pdf->SetY(10);
        $pdf->SetFont('Helvetica', 'B', 14);
        $pdf->SetTextColor($primaryColor[0], $primaryColor[1], $primaryColor[2]);
        $pdf->Cell(0, 8, 'TRAIN TICKET', 0, 1, 'R');
        $pdf->SetLineWidth(0.3);
        $pdf->Line(8, 20, 142, 20);

        // Section Passager - Méthode FPDF standard
        $pdf->SetY(25);
        $pdf->SetFillColor($secondaryColor[0], $secondaryColor[1], $secondaryColor[2]); // Correction ici
        $pdf->Rect(8, 25, 134, 8, 'F');
        $pdf->SetFont('Helvetica', 'B', 10);
        $pdf->Cell(40, 8, 'NOM DU PASSAGER', 0, 0);
        $pdf->SetFont('Helvetica', '', 10);
        $pdf->Cell(0, 8, iconv('UTF-8', 'windows-1252', mb_strtoupper($vente->client_nom)), 0, 1);

        // Séparateur
        $this->drawDashedLine($pdf, 35);

        // Trajet
        $pdf->SetY(38);
        $this->drawCompactInfoBox($pdf, 'DE:', $vente->voyage->gare_depart->nom, 8, 38, 60);
        $this->drawCompactInfoBox($pdf, 'A:', $vente->voyage->gare_arrivee->nom, 78, 38, 60);

        // Séparateur
        $this->drawDashedLine($pdf, 48);

        // Date/Heure
        $pdf->SetY(53);
        $this->drawCompactInfoBox($pdf, 'DATE', $vente->voyage->date_depart->format('d/m/Y'), 8, 53, 40);
        $this->drawCompactInfoBox($pdf, 'DEPART', $vente->voyage->heure_depart, 58, 53, 40);
        $this->drawCompactInfoBox($pdf, 'ARRIVEE', $vente->voyage->heure_arrivee, 108, 53, 34);

        // Séparateur
        $this->drawDashedLine($pdf, 65);

        // Détails train
        $pdf->SetY(70);
        $this->drawCompactInfoBox($pdf, 'TRAIN', $vente->train->numero, 8, 70, 40);
        $this->drawCompactInfoBox($pdf, 'WAGON', $vente->place->wagon->nom, 58, 70, 40);
        $this->drawCompactInfoBox($pdf, 'PLACE', $vente->place->numero, 108, 70, 34);

        // Code-barres
        $pdf->SetFillColor(0, 0, 0);
        $pdf->Rect(8, 83, 134, 1, 'F');

        // Pied de page
        // $pdf->SetY(90);
        // $pdf->SetFont('Helvetica', 'I', 5);
        // $pdf->Cell(0, 4, iconv('UTF-8', 'windows-1252', 'SOPAFER - Voyages sécurisés et Confortables'), 0, 0, 'C');

        $pdf->Output('I', 'billet_sopafer_' . $vente->id . '.pdf');
        exit;
    }

    private function drawDashedLine($pdf, $y) {
        $pdf->SetDrawColor(200, 200, 200);
        for($i=8; $i<142; $i+=4) {
            $pdf->Line($i, $y, $i+2, $y);
        }
        $pdf->SetDrawColor(0, 0, 0);
    }

    private function drawCompactInfoBox($pdf, $label, $value, $x, $y, $width) {
        $pdf->SetXY($x, $y);
        $pdf->SetFont('Helvetica', 'B', 8);
        $pdf->Cell($width, 4, iconv('UTF-8', 'windows-1252', $label), 0, 1);

        $pdf->SetXY($x, $y+4);
        $pdf->SetFont('Helvetica', '', 9);
        $pdf->Cell($width, 5, iconv('UTF-8', 'windows-1252', mb_strtoupper($value)), 0, 1);
    }
}
