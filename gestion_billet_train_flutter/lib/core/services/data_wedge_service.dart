import 'package:flutter/services.dart';
import 'package:gestion_billet_train_flutter/di/injection_container.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/bloc/ticket_bloc.dart';
import 'package:hive/hive.dart';

class DataWedgeService {
  static final DataWedgeService _instance = DataWedgeService._internal();
  factory DataWedgeService() => _instance;
  DataWedgeService._internal();

  static const MethodChannel _channel = MethodChannel(
    'com.sopafer.dev/datawedge',
  );
  late Box<String> _scannedTicketsBox;
  DateTime? _lastScanTime;

  void initialize() {
    _scannedTicketsBox = sl<Box<String>>();
    _channel.setMethodCallHandler(_handleScan);
    print('DataWedgeService: Initialized, MethodChannel handler set');
  }

  Future<void> _handleScan(MethodCall call) async {
    print(
      'DataWedgeService: Received MethodChannel call: ${call.method}, Arguments: ${call.arguments}',
    );
    if (call.method == 'onScanResult') {
      final String? scannedCode = call.arguments as String?;
      print('DataWedgeService: Scanned code: $scannedCode');
      if (scannedCode != null) {
        final now = DateTime.now();
        if (_lastScanTime == null ||
            now.difference(_lastScanTime!).inMilliseconds > 1000) {
          print('DataWedgeService: Processing scan: $scannedCode');
          final ticketBloc = sl<TicketBloc>();
          ticketBloc.add(ScanTicketEvent(scannedCode));
          _scannedTicketsBox.put(scannedCode, now.toIso8601String());
          _lastScanTime = now;
        } else {
          print('DataWedgeService: Scan ignored (debounce): $scannedCode');
        }
      } else {
        print('DataWedgeService: No scan data received');
      }
    }
    return null;
  }
}
