import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/sell_ticket_page.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;
  bool showDetails = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  setState(() {
                    qrText = scanData.code;
                  });
                });
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (qrText != null) ...[
                    Card(
                      child: ListTile(
                        title: Text('Numéro de Train: XXX'), // Masqué
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Classe: XXX'), // Masqué
                            Text('Vagon: XXX'), // Masqué
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              color: Colors.green, // Fond vert pour la place
                              child: Text(
                                'Place: ${qrText?.split(',')[3] ?? 'N/A'}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Prix Total: ${qrText?.split(',')[4] ?? 'N/A'} €'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => setState(() => showDetails = !showDetails),
                      child: Icon(
                        showDetails
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 40,
                      ),
                    ),
                    if (showDetails)
                      Column(
                        children: [
                          Text(
                            'Numéro de Train: ${qrText?.split(',')[0] ?? 'N/A'}',
                          ),
                          Text('Classe: ${qrText?.split(',')[1] ?? 'N/A'}'),
                          Text('Vagon: ${qrText?.split(',')[2] ?? 'N/A'}'),
                          Text(
                            'Date du Voyage: ${qrText?.split(',')[5] ?? 'N/A'}',
                          ),
                        ],
                      ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() => qrText = null); // Rescanner
                        },
                        child: const Text('Scanner'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          if (qrText != null) {
                            final data = qrText!.split(',');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SellTicketPage(),
                              ),
                            );
                          }
                        },
                        child: const Text('Vendre'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
