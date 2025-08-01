import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/report_page.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/scan_page.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/sell_ticket_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accueil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScanPage()),
                );
              },
              child: const Text('Scanner un Billet'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SellTicketPage(),
                  ), // Page de vente directe
                );
              },
              child: const Text('Vente de Ticket'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportPage()),
                );
              },
              child: const Text('Rapport'),
            ),
          ],
        ),
      ),
    );
  }
}
