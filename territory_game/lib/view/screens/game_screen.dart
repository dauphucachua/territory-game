import 'package:flutter/material.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/view/widgets/game_screen/board/board_widget.dart';
import 'package:territory_game/view/widgets/game_screen/UI/main_sidebar_widget.dart';

/// This is the main game screen. 
/// 
/// It shows the game board, main sidebar, game tabs (unimplemented), main menu (unimplemented) and power-ups (unimplemented).
class GameScreen extends StatefulWidget {
  final GameController gameController;
  const GameScreen(this.gameController, {super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with menu button - this should probably be converted into a row for customisability (tabs etc)
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {

          }
        ),
      ),
      body: Row(
        children: [
          // The game board and play area - still needs zoom / scrollability
          Expanded(
            child: Container(
              padding: EdgeInsets.all(50.0),
              child: BoardWidget(board: widget.gameController.board)
            ),
          ),
          // The main action sidebar
          Padding(
            padding: const EdgeInsets.all(8.0),
            // The main sidebar 
            child: MainSidebarWidget(widget.gameController)
          ),
        ],
      ),
    );
  }
}