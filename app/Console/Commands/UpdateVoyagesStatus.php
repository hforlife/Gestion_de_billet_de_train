<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Voyage;
use Carbon\Carbon;

class UpdateVoyagesStatus extends Command
{
    protected $signature = 'voyages:update-status';
    protected $description = 'Met à jour le statut des voyages selon l’heure';

    public function handle()
    {
        $now = Carbon::now();

        // Passer à "en_cours" si date_depart est atteinte
        Voyage::where('statut', 'programmé')
            ->where('date_depart', '<=', $now)
            ->where('date_arrivee', '>=', $now)
            ->update(['statut' => 'en_cours']);

        // Passer à "terminé" si date_arrivee est passée
        Voyage::where('statut', 'en_cours')
            ->where('date_arrivee', '<', $now)
            ->update(['statut' => 'terminé']);

        $this->info('Statuts des voyages mis à jour avec succès.');
    }
}
