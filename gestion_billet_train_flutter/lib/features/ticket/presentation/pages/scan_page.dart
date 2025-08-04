import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  QRViewController? controller;
  String? qrText;
  final TicketBloc ticketBloc =
      GetIt.instance<TicketBloc>(); // Toujours valide avec GetIt

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ticketBloc,
      child: Builder(
        builder: (context) {
          return BlocListener<TicketBloc, TicketState>(
            listener: (context, state) {
              if (state is TicketScanned) {
                controller?.pauseCamera();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TicketDetailsPage(ticket: state.ticket),
                  ),
                ).then((_) {
                  if (mounted) {
                    setState(() => qrText = null);
                    controller?.resumeCamera();
                  }
                });
              } else if (state is TicketError) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
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
                        if (this.controller == null) {
                          this.controller = controller;
                          controller.scannedDataStream.listen(
                            (scanData) {
                              if (!mounted) return;
                              print('QR Code detected: ${scanData.code}');
                              if (qrText != scanData.code) {
                                setState(() {
                                  qrText = scanData.code;
                                  if (qrText != null) {
                                    ticketBloc.add(ScanTicketEvent(qrText!));
                                  }
                                });
                              }
                            },
                            onError: (error) {
                              print('Error scanning QR code: $error');
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erreur de scan: $error'),
                                  ),
                                );
                              }
                            },
                          );
                          controller.resumeCamera();
                        }
                      },
                      overlay: QrScannerOverlayShape(
                        borderColor: Colors.red,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 5,
                        cutOutSize: 300,
                      ),
                      onPermissionSet: (controller, permission) {
                        if (!permission) {
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
                          if (qrText != null) ...[
                            const Text(
                              'Ticket scanné, redirection en cours...',
                            ),
                          ],
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (mounted) {
                                setState(() => qrText = null);
                                controller?.resumeCamera();
                              }
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
          );
        },
      ),
    );
  }
}
