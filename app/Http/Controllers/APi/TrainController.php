<?php

namespace App\Http\Controllers\Api;

use App\Enum\etatTrain;
use App\Http\Controllers\Controller;
use App\Models\Trains;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Validation\Rules\Enum;
use Inertia\Response;

class TrainController extends Controller
{
    //
    public function index(){
        $items = Trains::all();
        return Inertia::render('train', [
            'trains' => $items,
        ]);
    }
    //
    public function create(){
        return Inertia::render('other/train/create');
    }
    //
    public function store(Request $request){
        $request->validate([
            'nom' => 'required|string',
            'capacite' => 'required',
            'etat' => ['required', new Enum(etatTrain::class)]
        ]);

        $items = new Trains();
        $items->nom = $request->nom;
        $items->capacite = $request->capacite;
        $items->etat = $request->etat;
        $items->save();

        return redirect()->route('train.index')->with('status', 'Ajout effectué avec succès');
    }
    // Edit
    public function edit($id): Response{
        $item = Trains::findOrFail($id);
        return Inertia::render('other/train/edit',[
            'trains' => $item
        ]);
    }
    // Update
    public function update(Request $request, string $id)
    {
        //
        $request->validate([
            'nom' => 'required|string',
            'capacite' => 'required',
            'etat' => ['required', new Enum(etatTrain::class)]
        ]);

        $entrys = Trains::findOrFail($id);
        $entrys->nom = $request->nom;
        $entrys->capacite = $request->capacite;
        $entrys->etat = $request->etat;

        $entrys->update();

        return redirect()->route('train.index')->with('status', 'Modification effectué avec succès');
    }
    // Destroy
    public function destroy($id){
        $items = Trains::find($id);
        $items->delete();

        return redirect()->route('train.index')->with('status', 'Suppression effectué avec succes.');
    }
}
