<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Billet de Train</title>
    <style>
        body { font-family: 'Times New Roman', Times, serif, sans-serif; }
        h1 { text-align: center; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #000; padding: 8px; text-align: left; }
        .cadre { border = solid, black, 1px}
    </style>
</head>
<body>
    <div class="cadre">
    <img src="assets/images/icon_dark.png" alt="" width="400">
    <h1>Billet de Train</h1>

    <p><strong>Nom du client :</strong> {{ $vente->client_nom }}</p>
    <p><strong>Voyage :</strong> {{ $vente->voyage->name }}</p>
    <p><strong>Train :</strong> {{ $vente->train->numero }}</p>
    <p><strong>Prix :</strong> {{ $vente->prix }} FCFA</p>
    <p><strong>Bagage :</strong> {{ $vente->bagage ? 'Oui' : 'Non' }}</p>
    @if($vente->bagage)
        <p><strong>Poids bagage :</strong> {{ $vente->poids_bagage }} Kg</p>
    @endif

    <p><strong>Date de vente :</strong> {{ $vente->created_at->format('d/m/Y H:i') }}</p>
    </div>
</body>
</html>
