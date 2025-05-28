<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Colis;
use Illuminate\Http\Request as ClientRequest;
use Illuminate\Support\Facades\Request;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;
use Inertia\Response;


class ColisController extends Controller
{
    //
    public function index(): Response
{

    return Inertia::render('Colis/Index', props: [
        'filters' => Request::only('search'),
        'bagages' => Colis::orderBy('user1')
            ->filter(Request::only('search'))
            ->paginate(10)
            ->withQueryString()
            ->through(fn ($bagage) => [
                'id' => $bagage->id,
                'user1' => $bagage->user1,
                'user2' => $bagage->user2,
                'poids' => $bagage->poids,
                'tarif' => $bagage->tarif,
                'statut' => $bagage->statut,
            ]),
    ]);
}

    //
    public function create(): Response{
        return Inertia::render('Colis/Create');
    }

    //
    public function store(){
        Colis::create(Request::validate([
            'user1' => ['required'],
            'user2' => ['required'],
            'poids' => ['required'],
            'tarif' => ['required'],
            'statut' => ['required'],
        ]));

        return Redirect::route('bagage.index')->with('success', 'Ajout effectué avec succès');
    }

    //
    public function edit(string $id)
    {
        //
        $item = Colis::findOrFail($id);
        return Inertia::render('Colis/Edit', [
            'colis' => $item,
        ]);
    }
    // Update
    public function update(ClientRequest $request, Int $id)
    {
        $request->validate([
            'user1' => ['required', 'string'],
            'user2' => ['required', 'string'],
            'poids' => ['required', 'numeric'],
            'tarif' => ['required', 'numeric'],
            'statut' => ['required'],
        ]);

        $item = Colis::findOrFail($id);
        $item->user1 = $request->input('user1');
        $item->user2 = $request->input('user2');
        $item->poids = $request->input('poids');
        $item->tarif = $request->input('tarif');
        $item->statut = $request->input('statut');
        $item->update();

        // dd($request);

        return redirect()->route('bagage.index')->with('success', 'Ajout effectué avec succès');
    }

    // Destroy
    public function destroy(Colis $colis){
        $colis->delete();

        return Redirect::back()->with('success', 'Suppression effectuée avec succès.');
    }
}
