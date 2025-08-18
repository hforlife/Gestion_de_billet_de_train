<?php

namespace App\Http\Controllers;

use App\Models\SystemSetting;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;


class SystemSettingController extends Controller
{
    use AuthorizesRequests;
    //
    public function edit($id)
    {
        $this->authorize('create system_setting');

        return Inertia::render('Setting/Parametre/UpdateP', [
            'system' => SystemSetting::findOrFail($id)
        ]);
    }

    public function store(Request $request)
    {
        $this->authorize('create system_setting');

        $validatedData = $request->validate([
            'mode_vente' => 'required|string|in:par_voyage,par_kilometrage',
            'tarif_kilometrique' => [
                'nullable',
                'numeric',
                Rule::requiredIf(fn() => $request->input('mode_vente') === 'par_kilometrage')
            ],
            'tarif_minimum' => [
                'nullable',
                'numeric',
                Rule::requiredIf(fn() => $request->input('mode_vente') === 'par_kilometrage')
            ],
            'penalite' => 'nullable|numeric|between:0,999.99',
            'bagage_kg' => 'nullable|numeric|between:0,999.99',
        ]);

        SystemSetting::updateOrCreate(
            ['id' => 1], // il n'y a qu'un seul enregistrement système
            $validatedData
        );

        return redirect()->route('setting.index')->with('success', 'Paramètres système mis à jour.');
    }
}
