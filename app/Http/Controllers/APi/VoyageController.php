<?php

namespace App\Http\Controllers\Api;

use App\Enum\statusVoyage;
use App\Http\Controllers\Controller;
use App\Models\Voyages;
use Illuminate\Http\Request;
use Illuminate\Validation\Rules\Enum;
use Inertia\Inertia;
use Inertia\Response;

class VoyageController extends Controller
{
    // Index
    public function index(): Response{
        $items = Voyages::all();
        return Inertia::render('voyage',[
            'voyages' => $items,
        ]);
    }

    // Create
    public function create(){
        return Inertia::render('oyher/voyage/create');
    }

    // Store
    public function store(Request $request){
        $request->validate([
            'train_id' => 'required|string|max:255',
            'gare_depart' => 'required|string|max:255',
            'gare_arrivee' => 'required',
            'date_depart' => 'required',
            'date_arrivee' => 'nullable',
            'status' => ['required', new Enum(statusVoyage::class)],
        ]);
        
        $item = new Voyages();
        $item->train_id = $request->train_id;
        $item->gare_depart = $request->gare_depart;
        $item->gare_arrivee = $request->gare_arrivee;
        $item->date_depart = $request->date_depart;
        $item->date_arrivee = $request->date_arrivee;
        $item->status = $request->status;
        
        $item->save();

        return redirect()->route('voyage.index')->with('status', 'Ajout effectué avec succès');
    }
    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
        $item = Voyages::findOrFail($id);
        return Inertia::render('other/voyage/edit', [
            'voyages' => $item,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
        $request->validate([
          'train_id' => 'required|string|max:255',
            'gare_depart' => 'required|string|max:255',
            'gare_arrivee' => 'required',
            'date_depart' => 'required',
            'date_arrivee' => 'nullable',
            'status' => ['required', new Enum(statusVoyage::class)],
        ]);

        $entrys = Voyages::findOrFail($id);
        $entrys->train_id = $request->train_id;
        $entrys->gare_depart = $request->gare_depart;
        $entrys->gare_arrivee = $request->gare_arrivee;
        $entrys->date_depart = $request->date_depart;
        $entrys->date_arrivee = $request->date_arrivee;
        $entrys->status = $request->status;

        $entrys->update();

        return redirect()->route('voyage.index')->with('status', 'Modification effectué avec succès');
    }
    // Destroy
    public function destroy($id){
        $items = Voyages::find($id);
        $items->delete();

        return redirect()->route('voyage.index')->with('status', 'Suppression effectué avec succes.');
    }
}
