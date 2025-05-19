<?php

namespace App\Http\Controllers;


use App\Http\Controllers\Controller;
use App\Models\Trains;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class TrainController extends Controller
{
    //
    public function index(Request $request): Response
    {
        $filters = $request->only('search');
    
        return Inertia::render('Trains/Index', props: [
            'filters' => $filters,
            'trains' => Trains::orderBy('numero')
                ->filter($filters)
                ->paginate(10)
                ->withQueryString()
                ->through(fn ($train) => [
                    'id' => $train->id,
                    'numero' => $train->numero,
                    'capacite' => $train->capacite,
                    'etat' => $train->etat,
                ]),
        ]);
    }
    //
    public function create(){
        return Inertia::render('Trains/Create');
    }
    //
    public function store(Request $request){
        $request->validate([
            'numero' => ['required','string'],
            'capacite' => ['required'],
            'etat' => ['required']
        ]);

        $items = new Trains();
        $items->numero = $request->numero;
        $items->capacite = $request->capacite;
        $items->etat = $request->etat;
        $items->save();

        return redirect()->route('train.index')->with('status', 'Ajout effectué avec succès');
    }
    // Edit
    public function edit($id): Response{
        $item = Trains::findOrFail($id);
        return Inertia::render('Trains/Edit',[
            'trains' => $item
        ]);
    }
    // Update
    public function update(Request $request, string $id)
    {
        //
        $request->validate([
            'numero' => ['required','string'],
            'capacite' => ['required'],
            'etat' => ['required']
        ]);

        $entrys = Trains::findOrFail($id);
        $entrys->numero = $request->numero;
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
