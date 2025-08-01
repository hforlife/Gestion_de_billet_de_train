import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/app.dart';
import 'package:gestion_billet_train_flutter/di/injection_container.dart' as di;
import 'package:gestion_billet_train_flutter/features/auth/data/models/user_model.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/models/ticket_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TicketModelAdapter());
  await di.init();
  runApp(const App());
}
