import 'package:flutter/material.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/view/widgets/board_widget.dart';

class GameScreen extends StatelessWidget {
  final GameController gameController;
  const GameScreen(this.gameController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Center(
        child: BoardWidget(
          board: gameController.board
        ),
      ),
    );
  }
}