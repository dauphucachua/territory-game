import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:territory_game/firebase_options.dart';
import 'package:territory_game/services/initialization_services/main_initializer.dart';
import 'package:territory_game/view/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final mainInitializer = MainInitializer();
  MainApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return mainInitializer.initializeMultiProvider(
      MaterialApp(home: LoginScreen())
    );
  }
}
