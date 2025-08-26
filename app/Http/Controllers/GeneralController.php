<?php

namespace App\Http\Controllers;

use App\Models\General;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class GeneralController extends Controller
{
    //
    use AuthorizesRequests;
    public function edit($id): Response
    {
         $this->authorize('viewAny parametre');
         $generals = General::findOrFail($id); // On prend le premier paramètre
        return Inertia::render('Setting/Parametre/UpdateO', [
            'general' => $generals,
        ]);
    }

    public function update(Request $request, $parametre)
    {
        $setting = General::findOrFail($parametre);
        $validated = $request->validate([
            'nom_app' => 'required|string|max:255',
            'footer_text' => 'nullable|string',
            'logo' => 'nullable|file|max:2048',
            'dark_mode' => 'required|boolean',
        ]);
        
        
        if ($request->hasFile('logo')) {
            $path = $request->file('logo')->store('logos', 'public');
            $validated['logo'] = $path;
        }
        
        $setting->update($validated);

        return redirect()->back()->with('success', 'Paramètres mis à jour.');
    }
}
