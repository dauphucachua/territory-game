import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/view/screens/game_over_screen.dart';
import 'package:territory_game/view/screens/game_screen.dart';

class GameScreenWrapper extends StatefulWidget {
  const GameScreenWrapper({super.key});

  @override
  State<GameScreenWrapper> createState() => _GameScreenWrapperState();
}

class _GameScreenWrapperState extends State<GameScreenWrapper> {
  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();

    return ChangeNotifierProvider.value(
      value: gameController,
      child: gameController.gameIsActive ? GameScreen() : GameOverScreen()
    );
  }
}