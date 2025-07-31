<?php

namespace App\Http\Controllers;

use App\Models\Distance;
use App\Models\Gare;
use Illuminate\Http\Request;
use Inertia\Inertia;

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
}
