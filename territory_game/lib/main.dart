import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/firebase_options.dart';
import 'package:territory_game/services/firebase_services/firebase_auth_service.dart';
import 'package:territory_game/view/screens/login_screen.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final firebaseAuth = FirebaseAuthService();
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => firebaseAuth,
      child: MaterialApp(
        home: LoginScreen()
      )
    );
  }
}
