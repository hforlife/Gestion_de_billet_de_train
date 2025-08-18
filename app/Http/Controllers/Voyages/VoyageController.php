<?php

namespace App\Http\Controllers\Voyages;

use App\Models\Gare;
use App\Models\Train;
use App\Models\Ligne;
use App\Models\TarifsGare;
use App\Models\Voyage;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class VoyageController
{
    use AuthorizesRequests;
    public function index(Request $request): Response
    {
        $this->authorize('viewAny voyage');
        $filters = $request->only('search');
        $sortOrder = $request->get('sort', 'asc');

        $voyages = Voyage::with([
            'train',
            'ligne',
        ])
            ->when($filters['search'] ?? null, function ($query, $search) {
                $query->where(function ($q) use ($search) {
                    $q->where('nom', 'like', "%{$search}%")
                        ->orWhereHas('train', fn($q) => $q->where('numero', 'like', "%{$search}%"))
                        ->orWhereHas('ligne', fn($q) => $q->where('nom', 'like', "%{$search}%"));
                });
            })
            ->orderBy('date_depart', $sortOrder)
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Voyages/Index', [
            'trains' => Train::select('id', 'numero')->get(),
            'lignes' => Ligne::with(['arrets.gare'])->get(),
            'filters' => $filters,
            'voyages' => $voyages,
            'sort' => $sortOrder,
        ]);
    }

    public function create(): Response
    {
        $this->authorize('create voyage');
        return Inertia::render('Voyages/Create', [
            'trains' => Train::select('id', 'numero')->get(),
            'lignes' => Ligne::with(['arrets.gare'])->get(),
            'gares' => Gare::select('id', 'nom')->where('type', '!=', ['halte'])->get(),
        ]);
    }

    public function nextNumber()
    {
        // Exemple : on conserve le format VOY-950-<sequence 6 chiffres>
        $prefix = 'VOY';
        $code = '950';

        // Récupérer le dernier numéro existant pour ce pattern
        $last = Voyage::where('numero_voyage', 'like', "{$prefix}-{$code}-%")
            ->orderByDesc('id')
            ->first();

        $nextSeq = 1;
        if ($last && preg_match('/' . preg_quote("{$prefix}-{$code}-", '/') . '(\d+)$/', $last->numero_voyage, $m)) {
            $nextSeq = intval($m[1]) + 1;
        }

        // Pad à 6 chiffres par exemple
        $seqFormatted = str_pad($nextSeq, 6, '0', STR_PAD_LEFT);
        $numero = "{$prefix}-{$code}-{$seqFormatted}";

        return response()->json(['numero' => $numero]);
    }

    public function store(Request $request)
    {
        $this->authorize('create voyage');
        $data = $request->validate([
            'nom' => 'required|string|max:255',
            'numero_voyage' => 'required|string|unique:voyages,numero_voyage',
            'train_id' => 'required|exists:trains,id',
            'gare_depart_id' => 'required|exists:gares,id',
            'gare_arrivee_id' => 'required|exists:gares,id',
            'ligne_id' => 'required|exists:lignes,id',
            'date_depart' => 'required|date',
            'date_arrivee' => 'required|date|after:date_depart',
            'statut' => 'required|in:programme,en_cours,terminé,annulé',
        ]);

        $voyage = Voyage::create([
            'nom' => $data['nom'],
            'numero_voyage' => $data['numero_voyage'],
            'train_id' => $data['train_id'],
            'gare_depart_id' => $data['gare_depart_id'],
            'gare_arrivee_id' => $data['gare_arrivee_id'],
            'ligne_id' => $data['ligne_id'],
            'date_depart' => $data['date_depart'],
            'date_arrivee' => $data['date_arrivee'],
            'statut' => $data['statut'],
        ]);

        return redirect()->route('voyage.index')->with('success', 'Voyage créé avec succès');
    }


    public function edit(Voyage $voyage): Response
    {
        $this->authorize('update voyage');
        return Inertia::render('Voyages/Edit', [
            'voyage' => $voyage->load([
                'ligne.arrets.gare',
                'train',
            ]),
            'trains' => Train::select('id', 'numero')->get(),
            'lignes' => Ligne::with(['arrets.gare'])->get(),
            // 'tarifs' => TarifsGare::with(['classeWagon', 'gareDepart', 'gareArrivee'])->active()->get(),
            'gares' => Gare::select('id', 'nom')->where('type', '!=', ['fermee', 'halte'])->get(),
        ]);
    }

    public function update(Request $request, Voyage $voyage)
    {
        $this->authorize('update voyage');
        $validated = $request->validate([
            'nom' => 'required|string|max:255',
            'numero_voyage' => 'required|string',
            'train_id' => 'required|exists:trains,id',
            'gare_depart_id' => 'required|exists:gares,id',
            'gare_arrivee_id' => 'required|exists:gares,id',
            'ligne_id' => 'required|exists:lignes,id',
            'date_depart' => 'required|date',
            'date_arrivee' => 'required|date|after:date_depart',
            'statut' => 'required|in:programme,en_cours,terminé,annulé',
        ]);

        $voyage->update($validated);

        return redirect()->route('voyage.index')->with('success', 'Voyage mis à jour avec succès');
    }

    public function destroy(Voyage $voyage)
    {
        $this->authorize('delete voyage');
        $voyage->delete();

        return redirect()->route('voyage.index')->with('success', 'Voyage supprimé avec succès');
    }
}
