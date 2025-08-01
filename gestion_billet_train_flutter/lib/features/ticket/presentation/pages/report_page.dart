import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simuler des données (remplacez par une logique réelle avec votre datasource)
    final double totalRevenue = 1500.50;
    final int ticketSold = 25;

    return Scaffold(
      appBar: AppBar(title: const Text('Rapport')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rapport des Ventes',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text('Total Encaissé: $totalRevenue €'),
            Text('Nombre de Billets Vendus: $ticketSold'),
            // Ajoutez d'autres métriques si nécessaire (par ex. via un datasource)
          ],
        ),
      ),
    );
  }
}
