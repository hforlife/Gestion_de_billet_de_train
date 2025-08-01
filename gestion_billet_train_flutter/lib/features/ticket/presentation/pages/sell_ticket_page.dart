import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/core/constants/app_colors.dart'; // Ajustez selon votre projet

class SellTicketPage extends StatefulWidget {
  const SellTicketPage({super.key});

  @override
  State<SellTicketPage> createState() => _SellTicketPageState();
}

class _SellTicketPageState extends State<SellTicketPage> {
  String? departureId;
  String? arrivalId;
  bool hasPenalty = false;
  double distance = 0.0;
  double price = 0.0;
  bool isCalculating = false;
  bool showReceipt = false;
  Map<String, dynamic>? soldTicket;

  // Données simulées (remplacez par vos données réelles)
  final List<Map<String, dynamic>> locations = [
    {'id': 'loc1', 'name': 'Gare A'},
    {'id': 'loc2', 'name': 'Gare B'},
  ];

  double calculateDistance(double lat1, lon1, double lat2, lon2) {
    // Simplification : formule approximative
    const double earthRadius = 6371; // km
    final double dLat = (lat2 - lat1) * (3.14159 / 180);
    final double dLon = (lon2 - lon1) * (3.14159 / 180);
    final double a =
        dLat * dLat +
        dLon * dLon * cos(lat1 * 3.14159 / 180) * cos(lat2 * 3.14159 / 180);
    return earthRadius * 2 * asin(sqrt(a));
  }

  double calculatePrice(double distance, bool hasPenalty) {
    double basePrice = distance * 0.5; // 0.5 € par km (exemple)
    return hasPenalty ? basePrice * 1.2 : basePrice; // +20% avec pénalité
  }

  void handleSellTicket() {
    if (departureId == null || arrivalId == null || departureId == arrivalId)
      return;

    setState(() => isCalculating = true);
    final departure = locations.firstWhere((loc) => loc['id'] == departureId);
    final arrival = locations.firstWhere((loc) => loc['id'] == arrivalId);
    // Simuler des coordonnées (ajoutez-les dans locations si besoin)
    final calculatedDistance = calculateDistance(
      48.8566,
      2.3522,
      48.8584,
      2.2945,
    ); // Exemple
    final calculatedPrice = calculatePrice(calculatedDistance, hasPenalty);

    setState(() {
      distance = calculatedDistance;
      price = calculatedPrice;
      isCalculating = false;
      showReceipt = true;
      soldTicket = {
        'departure': departure['name'],
        'arrival': arrival['name'],
        'distance': distance,
        'price': price,
        'hasPenalty': hasPenalty,
        'trainNumber': 'T123', // Simulé
        'wagonClass': '1ère', // Simulé
        'wagon': 'A', // Simulé
        'seat': '1', // Simulé
        'tripNumber': 'TRP001', // Simulé
        'saleDate': DateTime.now().toIso8601String(), // Simulé
        'qrCode': 'QR_CODE_123', // Simulé
      };
    });
  }

  void handleBackToSell() {
    setState(() {
      showReceipt = false;
      soldTicket = null;
      departureId = null;
      arrivalId = null;
      hasPenalty = false;
    });
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  bool get isFormValid =>
      departureId != null && arrivalId != null && departureId != arrivalId;

  @override
  Widget build(BuildContext context) {
    if (showReceipt && soldTicket != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reçu de Vente')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reçu de Vente',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Numéro de Train: ${soldTicket!['trainNumber']}'),
                      Text('Classe: ${soldTicket!['wagonClass']}'),
                      Text('Wagon: ${soldTicket!['wagon']}'),
                      Text('Place: ${soldTicket!['seat']}'),
                      Text('Gare de Départ: ${soldTicket!['departure']}'),
                      Text('Gare d\'Arrivée: ${soldTicket!['arrival']}'),
                      Text(
                        'Distance: ${soldTicket!['distance'].toStringAsFixed(2)} km',
                      ),
                      Text(
                        'Date de Vente/Voyage: ${formatDate(soldTicket!['saleDate'])}',
                      ),
                      if (soldTicket!['hasPenalty'])
                        Text('Pénalité: Appliquée (+20%)'),
                      Text('QR Code: ${soldTicket!['qrCode']}'),
                      const SizedBox(height: 10),
                      Text(
                        'Prix Total: ${soldTicket!['price'].toStringAsFixed(2)} €',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Impression en cours...')),
                      );
                    },
                    child: const Text('Imprimer'),
                  ),
                  ElevatedButton(
                    onPressed: handleBackToSell,
                    child: const Text('Nouvelle Vente'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Vente de Ticket')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vendre un billet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              hint: const Text('Gare de Départ'),
              value: departureId,
              items: locations.map((loc) {
                return DropdownMenuItem<String>(
                  value: loc['id'],
                  child: Text(loc['name']),
                );
              }).toList(),
              onChanged: (value) => setState(() => departureId = value),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              hint: const Text('Gare d\'Arrivée'),
              value: arrivalId,
              items: locations.map((loc) {
                return DropdownMenuItem<String>(
                  value: loc['id'],
                  child: Text(loc['name']),
                );
              }).toList(),
              onChanged: (value) => setState(() => arrivalId = value),
            ),
            if (departureId != null &&
                arrivalId != null &&
                departureId == arrivalId)
              const Text(
                'Les gares ne peuvent pas être identiques',
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pénalité (+20%)'),
                Switch(
                  value: hasPenalty,
                  onChanged: (value) => setState(() => hasPenalty = value),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (isFormValid) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Résumé',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (isCalculating) const CircularProgressIndicator(),
                      if (!isCalculating) ...[
                        Text('Distance: $distance km'),
                        if (hasPenalty) Text('Pénalité: +20%'),
                        Text(
                          'Prix Total: $price €',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isFormValid ? handleSellTicket : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFormValid ? AppColors.primary : Colors.grey,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Valider la Vente',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
