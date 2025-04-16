<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Sections;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class SectionController extends Controller
{
    //Index
    public function index(): Response{
        $items = Sections::all();
        return Inertia::render('section', [
            'sections' => $items
        ]);
    }

    // Create
    public function create(): Response{
        return Inertia::render('other/section/create');
    }

    // Store
    public function store(Request $request){
        $request->validate([
            'name' => 'string|max:255',
            'description' => 'string|max:500'
        ]);

        $items = new Sections();
        $items->name = $request->name;
        $items->description = $request->description;
        $items->save();

        return redirect()->route('section.index')->with('status', 'Ajout effectué avec succès');
    }

    // Edit
    public function edit($id){
        $items = Sections::findOrFail($id);
        return Inertia::render('other/section/edit',[
            'section' => $items
        ]);
    }

    // Update
    public function update(Request $request, string $id)
    {
        //
        $request->validate([
            'name' => 'required',
            'description' => 'required',
        ]);

        $entrys = Sections::findOrFail($id);
        $entrys->name = $request->name;
        $entrys->description = $request->description;
        $entrys->update();

        return redirect()->route('section.index')->with('status', 'Modification effectué avec succès');
    }

    // Destroy
    public function destroy($id){
        $items = Sections::find($id);
        $items->delete();

        return redirect()->route('section.index')->with('status', 'Suppression effectué avec succes.');
    }
}
