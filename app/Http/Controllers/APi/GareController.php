<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Gares;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class GareController extends Controller
{
    //
    public function index(): Response
    {
        $gare = Gares::all();
        return Inertia::render('gare', props: [
            'gares' => $gare,
        ]);
    }
    // 
    public function create()
    {
        return Inertia::render('other/gare/create');
    }
    // Store
    public function store(Request $request)
    {
        $request->validate([
            'nom' => 'string|max:255',
            'localisation' => 'string|max:255'
        ]);

        $items = new Gares();
        $items->nom = $request->nom;
        $items->localisation = $request->localisation;
        $items->save();

        return redirect()->route('gare.index')->with('status', 'Ajout effectué avec succès');
    }
    // Edit
    public function edit(string $id)
    {
        //
        $item1 = Gares::findOrFail($id);
        return Inertia::render('other/gare/edit', [
            'gares' => $item1,
        ]);
    }
    // Update
    public function update(Request $request, string $id)
    {
        //
        $request->validate([
            'nom' => 'string|max:255',
            'localisation' => 'string|max:255'
        ]);

        $entrys = Gares::findOrFail($id);
        $entrys->nom = $request->nom;
        $entrys->localisation = $request->localisation;

        $entrys->update();

        return redirect()->route('gare.index')->with('status', 'Modification effectué avec succès');
    }

    // Destroy
    public function destroy($id)
    {
        $items = Gares::find($id);
        $items->delete();

        return redirect()->route('gare.index')->with('status', 'Suppression effectué avec succes.');
    }
}
