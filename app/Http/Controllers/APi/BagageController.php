<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Bagages;
use App\statusBagage;
use Illuminate\Http\Request;
use Illuminate\Validation\Rules\Enum;
use Inertia\Inertia;
use Inertia\Response;


class BagageController extends Controller
{
    //
    public function index(): Response{
        $items = Bagages::all();
        return Inertia::render('bagage',[
            'bagages' => $items,
        ]);
    }

    // 
    public function create(): Response{
        return Inertia::render('other/bagage/create');
    }

    // 
    public function store(Request $request){
        $request->validate([
            'user1' => 'required|string|max:255',
            'user2' => 'required|string|max:255',
            'poids' => 'required',
            'tarif' => 'required',
            'statut' => ['required', new Enum(statusBagage::class)],
        ]);
        
        $item = new Bagages();
        $item->user1 = $request->user1;
        $item->user2 = $request->user2;
        $item->poids = $request->poids;
        $item->tarif = $request->tarif;
        $item->statut = $request->statut;
        
        $item->save();

        return redirect()->route('gare.index')->with('status', 'Ajout effectué avec succès');
    }

    // 
    public function edit($id): Response{
        $item = Bagages::findOrFail($id);
        return Inertia::render('other/bagage/edit',[
            'bagages' => $item
        ]);
    }
    // Update
    public function update(Request $request, string $id)
    {
        //
        $request->validate([
            'user1' => 'required|string|max:255',
            'user2' => 'required|string|max:255',
            'poids' => 'required',
            'tarif' => 'required',
            'statut' => ['required', new Enum(statusBagage::class)],
        ]);

        $entrys = Bagages::findOrFail($id);
        $entrys->user1 = $request->user1;
        $entrys->user2 = $request->user2;
        $entrys->poids = $request->poids;
        $entrys->tarif = $request->tarif;
        $entrys->statut = $request->statut;

        $entrys->update();

        return redirect()->route('bagage.index')->with('status', 'Modification effectué avec succès');
    }
    // Destroy
    public function destroy($id){
        $items = Bagages::find($id);
        $items->delete();

        return redirect()->route('bagage.index')->with('status', 'Suppression effectué avec succes.');
    }
}
