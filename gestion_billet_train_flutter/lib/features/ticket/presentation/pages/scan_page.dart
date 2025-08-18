import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:gestion_billet_train_flutter/di/injection_container.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/bloc/ticket_bloc.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/ticket_details_page.dart';
import 'package:hive/hive.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final TextEditingController _qrController = TextEditingController();
  String? qrText;
  final TicketBloc ticketBloc = sl<TicketBloc>();
  DateTime? _lastScanTime;
  late Box<String> _scannedTicketsBox;
  static const MethodChannel _channel = MethodChannel(
    'com.example.gestion_billet_train_flutter/datawedge',
  );

  @override
  void initState() {
    super.initState();
    _scannedTicketsBox = sl<Box<String>>();
    _channel.setMethodCallHandler(_handleScan);
  }

  Future<void> _handleScan(MethodCall call) async {
    if (call.method == 'onScanResult' && mounted) {
      final String? scannedCode = call.arguments as String?;
      if (scannedCode != null) {
        final now = DateTime.now();
        if (_lastScanTime == null ||
            now.difference(_lastScanTime!).inMilliseconds > 1000) {
          if (!_scannedTicketsBox.containsKey(scannedCode)) {
            print('QR Code detected: $scannedCode');
            setState(() {
              qrText = scannedCode;
              ticketBloc.add(ScanTicketEvent(scannedCode));
              _scannedTicketsBox.put(scannedCode, scannedCode);
              _lastScanTime = now;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ce ticket a déjà été scanné')),
            );
          }
        }
      }
    }
    return null;
  }

  void _onManualSubmit() {
    final manualCode = _qrController.text.trim();
    if (manualCode.isNotEmpty) {
      print('Manual QR Code entered: $manualCode');
      if (!_scannedTicketsBox.containsKey(manualCode)) {
        setState(() {
          qrText = manualCode;
          ticketBloc.add(ScanTicketEvent(manualCode));
          _scannedTicketsBox.put(manualCode, manualCode);
          _qrController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ce ticket a déjà été scanné')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer une référence valide')),
      );
    }
  }

  @override
  void dispose() {
    _qrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ticketBloc,
      child: BlocListener<TicketBloc, TicketState>(
        listener: (context, state) {
          print('BlocListener state: $state');
          if (state is TicketScanned) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TicketDetailsPage(ticket: state.ticket),
              ),
            ).then((_) {
              if (mounted) {
                setState(() {
                  qrText = null;
                });
              }
            });
          } else if (state is TicketError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            setState(() {
              qrText = null;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Scanner un ticket')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Utilisez le scanner du Zebra pour scanner un ticket ou entrez la référence manuellement',
                  style: TextStyle(fontSize: TSizes.md),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _qrController,
                  decoration: InputDecoration(
                    labelText: 'Entrer la référence du ticket',
                    border: const OutlineInputBorder(),
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
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      qrText = null;
                      _qrController.clear();
                    });
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
