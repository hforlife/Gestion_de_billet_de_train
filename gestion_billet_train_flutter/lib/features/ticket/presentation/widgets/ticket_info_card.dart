import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/core/constants/app_colors.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';

class TicketInfoCard extends StatelessWidget {
  final Ticket ticket;

  const TicketInfoCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.green),
                Text('Arrivée: ${ticket.destination}'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                Text('Départ: ${ticket.departure}'),
              ],
            ),
            Text('Numéro de train: TGV 6651'),
            Text('Wagon: 12'),
            Text('Classe: Deuxième classe'),
            Text('Place: 45A'),
            Text('Numéro du voyage: TR-2024-001234'),
            Text('Distance: 462.7 km'),
            Text('Date de vente: ${ticket.createdAt.toString().substring(0, 16)}'),
            Text('Date du voyage: 30/07/2025, 18:20'),
            Text('Prix total: ${ticket.price.toStringAsFixed(0)} FCFA'),
            Text('Code QR: ${ticket.id.substring(0, 8)}'),
          ],
        ),
      ),
    );
  }
}