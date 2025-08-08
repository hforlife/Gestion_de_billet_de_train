<?php

namespace App\Http\Controllers;

use App\Models\SystemSetting;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;


class SystemSettingController extends Controller
{
    use AuthorizesRequests;
    //
    public function store(Request $request)
    {
        $this->authorize('update system_setting');

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
            'coefficients_classes' => 'nullable|json',
        ]);

        SystemSetting::updateOrCreate(
            ['id' => 1], // il n'y a qu'un seul enregistrement système
            $validatedData
        );

        return redirect()->back()->with('success', 'Paramètres système mis à jour.');
    }
}
