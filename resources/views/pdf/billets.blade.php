<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Billet de Train</title>
    <style>
        body {
            font-family: 'Courier New', monospace;
            font-size: 14px;
            margin: 0;
            padding: 0;
        }
        .ticket {
            width: 100%;
            max-width: 360px;
            border: 1px solid #000;
            padding: 10px;
            box-sizing: border-box;
        }
        .ticket-header {
            text-align: center;
            font-weight: bold;
            font-size: 16px;
            margin-bottom: 15px;
            border-bottom: 1px dashed #000;
            padding-bottom: 5px;
        }
        .ticket-section {
            margin-bottom: 10px;
        }
        .ticket-row {
            display: flex;
            margin-bottom: 5px;
        }
        .ticket-label {
            font-weight: bold;
            width: 120px;
        }
        .ticket-value {
            flex: 1;
        }
        .ticket-divider {
            border-top: 1px dashed #000;
            margin: 10px 0;
            padding-top: 10px;
        }
        .ticket-footer {
            font-size: 12px;
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="ticket">
        <div class="ticket-header">TRAIN TICKET</div>

        <div class="ticket-section">
            <div class="ticket-row">
                <div class="ticket-label">NAME OF PASSENGER</div>
                <div class="ticket-value">{{ strtoupper($vente->client_nom) }}</div>
            </div>
        </div>

        <div class="ticket-divider"></div>

        <div class="ticket-section">
            <div class="ticket-row">
                <div class="ticket-label">FROM:</div>
                <div class="ticket-value">{{ strtoupper($vente->voyage->gare_depart->nom) }}</div>
            </div>
            <div class="ticket-row">
                <div class="ticket-label">TO:</div>
                <div class="ticket-value">{{ strtoupper($vente->voyage->gare_arrivee->nom) }}</div>
            </div>
        </div>

        <div class="ticket-divider"></div>

        <div class="ticket-section">
            <div class="ticket-row">
                <div class="ticket-label">DATE</div>
                <div class="ticket-value">{{ $vente->voyage->date_depart->format('d M Y') }}</div>
            </div>
            <div class="ticket-row">
                <div class="ticket-label">DEPARTURE</div>
                <div class="ticket-value">{{ $vente->voyage->heure_depart }}</div>
            </div>
            <div class="ticket-row">
                <div class="ticket-label">ARRIVE</div>
                <div class="ticket-value">{{ $vente->voyage->heure_arrivee }}</div>
            </div>
        </div>

        <div class="ticket-divider"></div>

        <div class="ticket-section">
            <div class="ticket-row">
                <div class="ticket-label">INFORMATION</div>
                <div class="ticket-value">{{ strtoupper($vente->place->wagon->type) }} CLASS</div>
            </div>
            <div class="ticket-row">
                <div class="ticket-label">TRAIN</div>
                <div class="ticket-value">{{ $vente->train->numero }}</div>
            </div>
            <div class="ticket-row">
                <div class="ticket-label">CARRIAGE</div>
                <div class="ticket-value">{{ $vente->place->wagon->nom }}</div>
            </div>
            <div class="ticket-row">
                <div class="ticket-label">SEAT</div>
                <div class="ticket-value">{{ $vente->place->numero }}</div>
            </div>
        </div>

        <div class="ticket-divider"></div>

        <div class="ticket-section">
            <div class="ticket-row">
                <div class="ticket-label">PRICE</div>
                <div class="ticket-value">{{ $vente->prix }} FCFA</div>
            </div>
        </div>

        <div class="ticket-footer">Merci de voyager avec nous</div>
    </div>
</body>
</html>
