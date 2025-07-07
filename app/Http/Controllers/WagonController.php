<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class WagonController extends Controller
{
    //
    public function index(){
        // Logique pour afficher la liste des wagons
        return view('wagon.index');
    }

    public function create(){
        // Logique pour afficher le formulaire de création d'un wagon
        return view('wagon.create');
    }

    public function edit(){
        // Logique pour afficher le formulaire d'édition d'un wagon
        return view('wagon.edit');
    }

    public function store(Request $request){
        // Logique pour enregistrer un nouveau wagon
        // Validation et sauvegarde dans la base de données
        return redirect()->route('wagon.index')->with('success', 'Wagon créé avec succès.');
    }

    public function update(Request $request, $id){
        // Logique pour mettre à jour un wagon existant
        // Validation et mise à jour dans la base de données
        return redirect()->route('wagon.index')->with('success', 'Wagon mis à jour avec succès.');
    }

    public function destroy($id){
        // Logique pour supprimer un wagon
        // Suppression de l'enregistrement dans la base de données
        return redirect()->route('wagon.index')->with('success', 'Wagon supprimé avec succès.');
    }
}
