import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/view/screens/game_over_screen.dart';
import 'package:territory_game/view/screens/game_screen.dart';

/// This class serves as a conditional trigger for displaying the GameScreen or the GameOverScreen
/// depending on whether the game is active or not.
class GameScreenWrapper extends StatefulWidget {
  const GameScreenWrapper({super.key});

  @override
  State<GameScreenWrapper> createState() => _GameScreenWrapperState();
}

class _GameScreenWrapperState extends State<GameScreenWrapper> {
  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    final gameEndTime = gameController.game.endTime;

    if (DateTime.now().isAfter(gameEndTime)) {
      gameController.endGame();
    }

    return ChangeNotifierProvider.value(
      value: gameController,
      child: gameController.gameIsActive ? GameScreen() : GameOverScreen()
    );
  }
}