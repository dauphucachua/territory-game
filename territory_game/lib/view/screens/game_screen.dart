import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/view/widgets/game_screen/board/board_widget.dart';
import 'package:territory_game/view/widgets/game_screen/UI/main_sidebar_widget.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_lint/main.dart";

/// This is the main game screen. 
/// 
/// It shows the game board, main sidebar, game tabs (unimplemented), main menu (unimplemented) and power-ups (unimplemented).
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GameController>().listenForStateUpdates();
  }

  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      // AppBar with menu button - this should probably be converted into a row for customisability (tabs etc)
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: AppColors.opaqueWhite
          ),
          onPressed: () {}
          
        ),
      ),
      body: Stack(
        children: [
          // The game board and play area - still needs zoom / scrollability  
          InteractiveViewer(
            constrained: false,
            minScale: 0.1,
            maxScale: 4,
            boundaryMargin: EdgeInsets.symmetric(
              vertical: 10000, 
              horizontal: 10000
            ),
            child: SizedBox(
              width: 2000,
              height: 2000,
              child: BoardWidget(
                board: gameController.board
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              // The main sidebar 
              child: MainSidebarWidget()
            ),
          ),
          // The main action sidebar
          
        ],
      ),
    );
  }
}