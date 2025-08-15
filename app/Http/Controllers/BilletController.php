<?php

namespace App\Http\Controllers;

use App\Models\Vente;
use TCPDF;
use TCPDF2DBarcode;

class BilletController extends Controller
{
    public function generateBillet($id)
    {
        $vente = Vente::with([
            'voyage.gareDepart',
            'voyage.gareArrivee',
            'train',
            'place.wagon',
            'classeWagon'
        ])->findOrFail($id);

        // Création du PDF en format portrait (85x54mm)
        $pdf = new TCPDF('L', 'mm', [85, 54], true, 'UTF-8', false);

        // Configuration du document
        $pdf->SetCreator(config('app.name'));
        $pdf->SetAuthor('SOPAFER');
        $pdf->SetTitle('Billet de train #'.$vente->reference);
        $pdf->SetMargins(3, 3, 3); // Marge de 3mm sur tous les côtés
        $pdf->SetAutoPageBreak(false);
        $pdf->AddPage();

        // Couleurs personnalisées (RGB)
        $primaryColor = [0, 60, 110]; // Bleu SOPAFER
        $secondaryColor = [220, 230, 240]; // Fond clair
        $textColor = [50, 50, 50];

        // Style de base
        $pdf->SetTextColor($textColor[0], $textColor[1], $textColor[2]);
        $pdf->SetDrawColor($primaryColor[0], $primaryColor[1], $primaryColor[2]);
        $pdf->SetLineWidth(0.2);

        // En-tête avec logo
        $pdf->Image(public_path('assets/images/icon_white.png'), 3, 3, 15, '', 'PNG');
        $pdf->SetFont('helvetica', 'B', 8);
        $pdf->SetXY(20, 3);
        $pdf->Cell(0, 5, 'Billet de Train - SOPAFER', 0, 1);

        // Ligne de séparation
        $pdf->Line(3, 10, 82, 10);

        // Section Passager
        $pdf->SetFont('helvetica', 'B', 7);
        $pdf->SetXY(3, 12);
        $pdf->Cell(20, 5, 'PASSAGER:', 0, 0);
        $pdf->SetFont('helvetica', '', 8);
        $pdf->Cell(0, 5, mb_strtoupper($vente->client_nom), 0, 1);

        // Section Trajet
        $this->drawInfoBox($pdf, 'DÉPART', $vente->voyage->gareDepart->nom, 3, 18, 38);
        $this->drawInfoBox($pdf, 'ARRIVÉE', $vente->voyage->gareArrivee->nom, 43, 18, 38);

        // Section Horaires
        $this->drawInfoBox($pdf, 'DATE', $vente->voyage->date_depart, 3, 26, 25);
        $this->drawInfoBox($pdf, 'CLASSE', $vente->classeWagon->classe, 30, 26, 25);
        // $this->drawInfoBox($pdf, 'CLASSE', $vente->classeWagon->classe, 57, 26, 25);

        // Section Place
        // $this->drawInfoBox($pdf, 'TRAIN', $vente->train->numero, 3, 34, 25);
        $this->drawInfoBox($pdf, 'WAGON', $vente->place->wagon->numero_wagon, 3, 34, 25);
        $this->drawInfoBox($pdf, 'PLACE', $vente->place->numero, 30, 34, 25);

        // QR Code (20x20mm)
        $qrcode = new TCPDF2DBarcode($vente->reference, 'QRCODE,M');
        $pdf->SetXY(60, 18);
        $pdf->Image('@'.$qrcode->getBarcodePngData(), '', '', 20, 20, 'PNG');

        // Pied de page
        $pdf->SetFont('helvetica', 'I', 5);
        $pdf->SetXY(3, 50);
        $pdf->Cell(0, 3, 'Réf: '.$vente->reference.' | Édité le '.now()->format('d/m/Y H:i'), 0, 0);

        // Barre de sécurité
        $pdf->SetLineWidth(0.5);
        $pdf->Line(3, 47, 82, 47);

        // Sortie du PDF
        $pdf->Output('billet_'.$vente->reference.'.pdf', 'I');
        exit;
    }

    private function drawInfoBox($pdf, $label, $value, $x, $y, $width)
    {
        $pdf->SetFont('helvetica', 'B', 6);
        $pdf->SetXY($x, $y);
        $pdf->Cell($width, 3, $label, 0, 1);

        $pdf->SetFont('helvetica', '', 7);
        $pdf->SetXY($x, $y + 3);
        $pdf->Cell($width, 4, mb_strtoupper($value), 0, 1);
    }
}
