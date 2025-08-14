import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/bloc/ticket_bloc.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/ticket_details_page.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final TextEditingController _qrController = TextEditingController();
  QRViewController? controller;
  String? qrText;
  final TicketBloc ticketBloc = GetIt.instance<TicketBloc>();
  DateTime? _lastScanTime;

  @override
  void dispose() {
    controller?.dispose();
    _qrController.dispose();
    super.dispose();
  }

  void _onQRCodeScanned(String scannedCode) {
    final now = DateTime.now();
    // Debounce scans (only process if 1 second has passed since last scan)
    if (_lastScanTime == null ||
        now.difference(_lastScanTime!).inMilliseconds > 1000) {
      if (scannedCode != qrText) {
        print('QR Code detected: $scannedCode');
        setState(() {
          qrText = scannedCode;
          ticketBloc.add(ScanTicketEvent(scannedCode));
          _lastScanTime = now;
        });
      }
    }
  }

  void _onManualSubmit() {
    final manualCode = _qrController.text.trim();
    if (manualCode.isNotEmpty) {
      print('Manual QR Code entered: $manualCode');
      setState(() {
        qrText = manualCode;
        ticketBloc.add(ScanTicketEvent(manualCode));
        _qrController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer une référence valide')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ticketBloc,
      child: BlocListener<TicketBloc, TicketState>(
        listener: (context, state) {
          print('BlocListener state: $state');
          if (state is TicketScanned) {
            controller?.pauseCamera();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TicketDetailsPage(ticket: state.ticket),
              ),
            ).then((_) {
              if (mounted) {
                setState(() {
                  qrText = null;
                  controller?.resumeCamera();
                });
              }
            });
          } else if (state is TicketError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            setState(() {
              qrText = null;
              controller?.resumeCamera();
            });
          }
        },
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: (controller) {
                    this.controller = controller;
                    controller.scannedDataStream.listen(
                      (scanData) {
                        if (!mounted) return;
                        final scannedCode = scanData.code;
                        if (scannedCode != null) {
                          _onQRCodeScanned(scannedCode);
                        }
                      },
                      onError: (error) {
                        print('Error scanning QR code: $error');
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur de scan: $error')),
                          );
                          setState(() {
                            qrText = null;
                            controller.resumeCamera();
                          });
                        }
                      },
                    );
                    controller.resumeCamera();
                  },
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 5,
                    cutOutSize: 300,
                  ),
                  onPermissionSet: (controller, permission) {
                    if (!permission && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Permission caméra refusée'),
                        ),
                      );
                    }
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _qrController,
                        decoration: InputDecoration(
                          labelText: 'Entrer la référence du ticket',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _onManualSubmit,
                          ),
                        ),
                        onSubmitted: (_) => _onManualSubmit(),
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<TicketBloc, TicketState>(
                        builder: (context, state) {
                          if (state is TicketLoading) {
                            return const CircularProgressIndicator();
                          }
                          if (qrText != null) {
                            return Text(
                              'Ticket scanné : $qrText\nTraitement en cours...',
                              style: TextStyle(fontSize: TSizes.md),
                              textAlign: TextAlign.center,
                            );
                          }
                          return Text(
                            'Scannez un code QR ou entrez la référence manuellement',
                            style: TextStyle(fontSize: TSizes.md),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            qrText = null;
                            _qrController.clear();
                            controller?.resumeCamera();
                          });
                        },
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
