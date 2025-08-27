import 'package:gestion_billet_train_flutter/di/injection_container.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ApiConstants {
  static const String _sopUrl = "https://e-sopafer.ml/api";
  static const String _sopLocUrl = "https://sopafer.doucsoft.dev/api";
  static const String _localWorkUrl = "http://192.168.1.32:8000/api";
  static const String _localHouseUrl = "http://192.168.1.32:8000/api";

  static String get baseUrl {
    // Default to SopLoc if no value is stored
    final box = sl<Box<String>>();
    final selectedServer = box.get('selected_server', defaultValue: 'SopLoc');
    switch (selectedServer) {
      case 'SOPAFER':
        return _sopUrl;
      case 'DOUCSOFT':
        return _sopLocUrl;

      default:
        return _sopLocUrl;
    }
  }

  static Future<void> setServer(String server) async {
    final box = sl<Box<String>>();
    await box.put('selected_server', server);
  }

  static List<String> get availableServers => ['SOPAFER', 'DOUCSOFT'];
}
