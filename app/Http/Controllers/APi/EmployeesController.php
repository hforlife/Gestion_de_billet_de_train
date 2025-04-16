<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Employees;
use App\Models\Gares;
use App\Models\Sections;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\Redirect;
use Inertia\Response;

class EmployeesController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): Response
    {
        //
        $item = Employees::all();
        return Inertia::render('employee', [
            'employees' => $item,
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
        $item1 = Gares::all();
        $item2 = Sections::all();
        return Inertia::render('other/employee/create', [
            'gares' => $item1,
            'sections' => $item2
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request){
        $request->validate([
            'name' => 'required|string|max:255',
            'section' => 'required',
            'salaire' => 'required',
            'date_de_debut' => 'required',
            'gare_id' => 'required',
        ]);
        
        $item = new Employees();
        $item->name = $request->name;
        $item->section = $request->section;
        $item->salaire = $request->salaire;
        $item->date_de_debut = $request->date_de_debut;
        $item->gare_id = $request->gare_id;
        $item->save();

        return redirect()->route('employee.index')->with('success', 'Ajout effectué avec succès');
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
        $item = Employees::findOrFail($id);
        $item1 = Gares::all();
        $item2 = Sections::all();
        return Inertia::render('other/employee/edit', [
            'employee' => $item,
            'gares' => $item1,
            'sections' => $item2
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
        $request->validate([
           'name' => 'required|string|max:255',
            'section' => 'required',
            'salaire' => 'required',
            'date_de_debut' => 'required',
            'gare_id' => 'required',
        ]);

        $entrys = Employees::findOrFail($id);
        $entrys->name = $request->name;
        $entrys->section = $request->section;
        $entrys->salaire = $request->salaire;
        $entrys->date_de_debut = $request->date_de_debut;
        $entrys->gare_id = $request->gare_id;

        $entrys->update();

        return redirect()->route('employee.index')->with('success', 'Modification effectué avec succès');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Employees $employee)
    {
        $employee->delete();
        return redirect()->route('employee.index')->with('success', 'Employée supprimée avec succès');
    }
    
}
