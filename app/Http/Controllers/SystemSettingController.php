<?php

namespace App\Http\Controllers;

use App\Models\SystemSetting;
use Illuminate\Http\Request;

class SystemSettingController extends Controller
{
    //
    public function store(Request $request)
{
    $validatedData = $request->validate([
        'mode_vente' => 'required|string|in:par_voyage,par_kilometrage',
        'tarif_kilometrique' => 'nullable|numeric',
        'tarif_minimum' => 'nullable|numeric',
        'coefficients_classes' => 'nullable|json',
    ]);

    SystemSetting::updateOrCreate(
        ['id' => 1], // il n'y a qu'un seul enregistrement système
        $validatedData
    );

    return redirect()->back()->with('success', 'Paramètres système mis à jour.');
}

}
