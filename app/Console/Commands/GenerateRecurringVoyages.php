<?php

namespace App\Console\Commands;

use App\Models\VoyageRecurrent;
use App\Models\Voyages;
use Illuminate\Console\Command;

class GenerateRecurringVoyages extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'generate:recurring-voyages';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Commande pour générer des voyages récurrents';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $today = now()->startOfWeek(); // lundi
        $end = now()->endOfWeek(); // dimanche

        $joursMap = [
            'lundi' => 1,
            'mardi' => 2,
            'mercredi' => 3,
            'jeudi' => 4,
            'vendredi' => 5,
            'samedi' => 6,
            'dimanche' => 0,
        ];

        $recurrentVoyages = VoyageRecurrent::all();

        foreach ($recurrentVoyages as $recur) {
            foreach (explode(',', $recur->jours) as $jour) {
                $dayNum = $joursMap[trim(strtolower($jour))];
                $date = now()->startOfWeek()->addDays($dayNum);

                $exists = Voyages::where('train_id', $recur->train_id)
                    ->whereDate('date_depart', $date)
                    ->whereTime('date_depart', $recur->heure_depart)
                    ->exists();

                if (!$exists) {
                    Voyages::create([
                        'name' => 'Voyage Auto',
                        'train_id' => $recur->train_id,
                        'gare_depart_id' => $recur->gare_depart_id,
                        'gare_arrivee_id' => $recur->gare_arrivee_id,
                        'date_depart' => $date->format('Y-m-d') . ' ' . $recur->heure_depart,
                        'date_arrivee' => $date->addHours(10), // à ajuster
                        'prix' => $recur->prix,
                        'statut' => 'prévu',
                    ]);
                }
            }
        }

        $this->info('Voyages récurrents générés.');
    }


}
