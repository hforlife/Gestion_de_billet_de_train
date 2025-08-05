<?php

namespace App\Http\Controllers;

use App\Models\Distance;
use App\Models\Gare;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\Validator;

class DistanceController extends Controller
{
    //
    public function index(Request $request)
    {

        return Inertia::render('Distance/Index', [
            'distances' => Distance::with(['gareDepart', 'gareArrivee'])
                ->orderBy('distance_km')
                ->paginate(10)
                ->withQueryString(),
            'filters' => request()->all('search'),
        ]);
    }
    public function create()
    {
        return Inertia::render('Distance/Create', [
            'gares' => Gare::all(['id', 'nom']),]);
    }
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'gare_depart_id' => 'required|exists:gares,id',
            'gare_arrivee_id' => 'required|exists:gares,id',
            'distance_km' => 'required|numeric|min:0',
        ]);

        $distance = new Distance();
        $distance->gare_depart_id = $validatedData['gare_depart_id'];
        $distance->gare_arrivee_id = $validatedData['gare_arrivee_id'];
        $distance->distance_km = $validatedData['distance_km'];
        $distance->save();

        return redirect()->route('distance.index')->with('success', 'Distance enregistrée avec succès.');
    }

      public function get(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'depart_id' => 'required|exists:gares,id',
            'arrivee_id' => 'required|exists:gares,id|different:depart_id',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $depart = Gare::find($request->input('depart_id'));
        $arrivee = Gare::find($request->input('arrivee_id'));

        if (!$depart || !$arrivee) {
            return response()->json(['distance' => 0]);
        }

        // Si tu as latitude/longitude sur gares
        $distance = $this->haversineDistance(
            $depart->latitude,
            $depart->longitude,
            $arrivee->latitude,
            $arrivee->longitude
        );

        // Optionnel : arrondir à 1 décimale
        $distance = round($distance, 1);

        return response()->json(['distance' => $distance]);
    }

    // Distance en kilomètres
    private function haversineDistance($lat1, $lon1, $lat2, $lon2)
    {
        $earthRadius = 6371; // km

        $dLat = deg2rad($lat2 - $lat1);
        $dLon = deg2rad($lon2 - $lon1);

        $a = sin($dLat / 2) * sin($dLat / 2) +
             cos(deg2rad($lat1)) * cos(deg2rad($lat2)) *
             sin($dLon / 2) * sin($dLon / 2);

        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        return $earthRadius * $c;
    }
}
