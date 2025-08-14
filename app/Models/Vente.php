<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOneThrough;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Models\Concerns\Auditable;
use App\Services\SalePriceCalculator as ServicesSalePriceCalculator;

class Vente extends Model
{
    use SoftDeletes, Auditable;

    protected $fillable = [
        'client_nom',
        'voyage_id',
        'mode_paiement_id',
        'point_vente_id',
        'classe_wagon_id',
        'prix',
        'demi_tarif',
        'date_vente',
        'quantite',
        'bagage',
        'poids_bagage',
        'place_id',
        'penalite',
        'reference',
        'qrcode',
        'statut',
        'created_by',
        'updated_by',
    ];

    protected $casts = [
        'demi_tarif' => 'boolean',
        'bagage' => 'boolean',
        'date_vente' => 'datetime',
        'prix' => 'decimal:2',
    ];

    protected $appends = [
        'total',
        'is_demi_tarif',
        'has_bagage',
        'qrcode_url',
    ];

    public function scopeFiltrer($query, $search = null, $voyageId = null)
    {
        return $query
            ->when($search, fn($q) => $q->where('client_nom', 'like', "%{$search}%"))
            ->when($voyageId, fn($q) => $q->where('voyage_id', $voyageId))
            ->with(['voyage', 'place', 'modePaiement', 'pointVente', 'classeWagon']);
    }

    public function systemSettings(): HasOneThrough
    {
        return $this->hasOneThrough(
            SystemSetting::class,
            Voyage::class,
            'id', // Foreign key on the voyages table
            'id', // Foreign key on the system_settings table
            'voyage_id', // Local key on the ventes table
            'system_settings_id' // Local key on the voyages table
        );
    }



    public function getQrcodeUrlAttribute()
    {
        return $this->qrcode ? asset('storage/' . $this->qrcode) : null;
    }

    public function creator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    public function voyage(): BelongsTo
    {
        return $this->belongsTo(Voyage::class);
    }

    public function place(): BelongsTo
    {
        return $this->belongsTo(Place::class)->with('wagon');
    }

    public function train(): BelongsTo
    {
        return $this->belongsTo(Train::class);
    }

    public function gareDepart(): BelongsTo
    {
        return $this->belongsTo(Gare::class, 'gare_depart_id');
    }

    public function gareArrivee(): BelongsTo
    {
        return $this->belongsTo(Gare::class, 'gare_arrivee_id');
    }

    public function modePaiement(): BelongsTo
    {
        return $this->belongsTo(ModesPaiement::class, 'mode_paiement_id');
    }

    public function pointVente(): BelongsTo
    {
        return $this->belongsTo(PointsVente::class, 'point_vente_id');
    }

    public function items(): HasMany
    {
        return $this->hasMany(VenteItem::class);
    }

    public function classeWagon(): BelongsTo
    {
        return $this->belongsTo(ClassesWagon::class, 'classe_wagon_id');
    }

    public function arrets(): HasMany
    {
        return $this->hasMany(ArretsLigne::class);
    }

    public function getTotalAttribute(): float
    {
        return $this->prix * $this->quantite;
    }

    public function getIsDemiTarifAttribute()
    {
        return $this->demi_tarif;
    }

    public function getHasBagageAttribute(): bool
    {
        return $this->bagage && $this->poids_bagage > 0;
    }

    //     public function calculatePrice(SystemSetting $setting): float
    // {
    //     $basePrice = 0;

    //     if ($setting->mode_vente === 'par_kilometrage') {
    //         $basePrice = ServicesSalePriceCalculator::computePriceByKilometrage(
    //             $this->gare_depart_id,
    //             $this->gare_arrivee_id,
    //             $this->classe_wagon_id,
    //             $setting
    //         );
    //     } else {
    //         $tarif = $this->voyage->tarifs()
    //             ->where('classe_wagon_id', $this->classe_wagon_id)
    //             ->first();

    //         $basePrice = $tarif ? $tarif->prix : 0;
    //     }

    //     // Appliquer demi-tarif
    //     if ($this->demi_tarif) {
    //         $basePrice = $basePrice / 2;
    //     }

    //     // Ajouter le prix des bagages
    //     if ($this->bagage && $this->poids_bagage > 0) {
    //         $basePrice += $this->calculateBaggagePrice();
    //     }

    //     return $basePrice * $this->quantite;
    // }

    public function calculateBaggagePrice(): float
    {
        // Même logique que dans le contrôleur
        $poidsGratuit = 10;
        if ($this->poids_bagage <= $poidsGratuit) {
            return 0;
        }

        return ($this->poids_bagage - $poidsGratuit) * 500;
    }
    public function getPrixForClasse($classeWagonId)
    {
        return $this->tarif->where('classe_wagon_id', $classeWagonId)
            ->where('date_effet', '<=', now())
            ->where(function ($query) {
                $query->where('date_expiration', '>=', now())
                    ->orWhereNull('date_expiration');
            })
            ->first()
            ?->prix ?? 0;
    }
}
