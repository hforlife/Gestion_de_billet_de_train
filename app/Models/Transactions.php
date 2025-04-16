<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Transactions extends Model
{
    //
    protected $fillable = [
        'ticket_id',
        'montant',
        'type_paiement',
        'status',
    ];

    public function ticket(){
        return $this->belongsTo(Tickets::class, 'ticket_id');
    }
}
