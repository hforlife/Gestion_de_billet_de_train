<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class VenteResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return  [
            'id' => $this->id,
            'client_nom' => $this->client_nom,
            'voyage_id' => $this->voyage_id,
            'mode_paiement_id' => $this->mode_paiement_id,
            'point_vente_id' => $this->point_vente_id,
            'classe_wagon_id' => $this->classe_wagon_id,
            'prix' => $this->prix,
            'demi_tarif' => $this->demi_tarif,
            'date_vente' => $this->date_vente,
            'quantite' => $this->quantite,
            'bagage' => $this->bagage,
            'poids_bagage' => $this->poids_bagage,
            'place_id' => $this->place_id,
            'penalite' => $this->penalite,
            'reference' => $this->reference,
            'statut' => $this->statut,
        ];
    }
}
