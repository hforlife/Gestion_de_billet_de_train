import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:gestion_billet_train_flutter/core/constants/text_strings.dart';
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
    'com.sopafer.dev/datawedge',
  );

  @override
  void initState() {
    super.initState();
    _scannedTicketsBox = sl<Box<String>>();
    _channel.setMethodCallHandler(_handleScan);
    print('ScanPage: Initialized, MethodChannel handler set');
  }

  Future<void> _handleScan(MethodCall call) async {
    print(
      'ScanPage: Received MethodChannel call: ${call.method}, Arguments: ${call.arguments}',
    );
    if (call.method == 'onScanResult' && mounted) {
      final String? scannedCode = call.arguments as String?;
      print('ScanPage: Scanned code: $scannedCode');
      if (scannedCode != null) {
        final now = DateTime.now();
        if (_lastScanTime == null ||
            now.difference(_lastScanTime!).inMilliseconds > 1000) {
          print('ScanPage: Processing scan: $scannedCode');
          setState(() {
            qrText = scannedCode;
            ticketBloc.add(ScanTicketEvent(scannedCode));
            _scannedTicketsBox.put(scannedCode, now.toIso8601String());
            _lastScanTime = now;
          });
        } else {
          print('ScanPage: Scan ignored (debounce): $scannedCode');
        }
      } else {
        print('ScanPage: No scan data received');
      }
    }
    return null;
  }

  void _onManualSubmit() {
    final manualCode = _qrController.text.trim();
    print('ScanPage: Manual code entered: $manualCode');
    if (manualCode.isNotEmpty) {
      print('ScanPage: Processing manual scan: $manualCode');
      setState(() {
        qrText = manualCode;
        ticketBloc.add(ScanTicketEvent(manualCode));
        _scannedTicketsBox.put(manualCode, DateTime.now().toIso8601String());
        _qrController.clear();
      });
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
          print('ScanPage: Bloc state: $state');
          if (state is TicketScanned) {
            print(
              'ScanPage: Navigating to TicketDetailsPage for ticket: ${state.ticket}',
            );
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
            print('ScanPage: Error: ${state.message}');
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            setState(() {
              qrText = null;
            });
          } else if (state is TicketLoading) {
            setState(() {
              qrText = 'Traitement en cours...';
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
                  TTexts.scanSentence,
                  style: TextStyle(fontSize: TSizes.md),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _qrController,
                  decoration: InputDecoration(
                    labelText: TTexts.referencePlacholder,
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
                        qrText!,
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
                  child: const Text(TTexts.retry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
