// lib/main.dart
import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/app.dart';
import 'package:gestion_billet_train_flutter/di/injection_container.dart' as di;
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialisation de Hive ici
  await di.init(); // Appel à l'initialisation des dépendances
  runApp(const App());
}
