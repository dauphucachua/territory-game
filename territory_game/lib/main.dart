import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/firebase_options.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/view/screens/game_screen.dart';

void main() async {
  final board = Board();
  final gameController = GameController(board: board);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MainApp(gameController));
}

class MainApp extends StatelessWidget {
  final GameController gameController;
  const MainApp(this.gameController, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(gameController)
    );
  }
}
