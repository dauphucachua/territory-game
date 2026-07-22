import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';
import 'package:territory_game/view/widgets/game_screen/board/board_widget.dart';
import 'package:territory_game/view/widgets/game_screen/UI/main_sidebar_widget.dart';
import 'package:territory_game/view/widgets/game_screen/property_icon.dart';

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
    final activePlayer = gameController.activePlayer;
    Player? opponent = gameController.opponent;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: Column(
        children: [
          // This is the top bar, which has a menu and a display of game statistics
          Container(
            height: 50,
            color: AppColors.darkBlue,
            child: Row(
              children: [
                // Menu button
                PopupMenuButton(
                  icon: Icon(
                    Icons.menu,
                    color: AppColors.opaqueWhite,
                  ),
                  color: AppColors.darkBlue,
                  elevation: 4.0,
                  shadowColor: Colors.black,
                  offset: Offset(0, 50),
                  itemBuilder: (context) {
                    // Menu list
                    return [
                      PopupMenuItem(
                        child: MainMenuItem(
                          text: "Home",
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                       PopupMenuItem(
                        child: MainMenuItem(
                          text: "Logout",
                          onTap: () {
                            gameController.firebaseAuth.logout();
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                        ),
                      ),
                    ];
                  },
                ),
                SizedBox(width: 32.0),
                // Display names of players in game
                ContentText(
                  text: opponent != null 
                    ? "${activePlayer.displayName} vs ${opponent.displayName}"
                    : activePlayer.displayName
                ),
                SizedBox(width: 32.0),
                // Player statistic boxes for displaying number of control points per player
                PlayerStatContainer(
                  activePlayer: activePlayer, 
                  opponent: opponent
                ),
                SizedBox(width: 32.0),
                opponent != null 
                  ? PlayerStatContainer(
                    activePlayer: opponent,
                    opponent: activePlayer
                  )
                  : ContentText(text: "No opponent present"),
                SizedBox(width: 32.0),
                // Game end time - countdown can be implemented here optionally
                ContentText(text: "Game ends: ${gameController.game.endTimeAsString}"),
              ],
            ),
          ),
          // Main screen area 
          Expanded(
            child: Stack(
              children: [
                // Interactive viewer covering the board and the play area
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
          ),
        ],
      ),
    );
  }
}

class PlayerStatContainer extends StatelessWidget {
  const PlayerStatContainer({
    super.key,
    required this.opponent,
    required this.activePlayer,
  });

  final Player? opponent;
  final Player activePlayer;

  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    final playerProperties = gameController.getPropertiesByPlayerId(activePlayer.id);
    final playerControlPoints = gameController.getControlPointsByPlayerId(activePlayer.id);
    final opponentControlPoints = opponent != null ? gameController.getControlPointsByPlayerId(opponent!.id) : 0;

    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: opponent == null || playerControlPoints >= opponentControlPoints
          ? AppColors.correctBoxGreen
          : AppColors.wrongBoxRed,
        borderRadius: AppDimensions.cornerRadius,
    
      ),
      child: Row(
        children: [
          PropertyIcon(
            color: activePlayer.propertyColor,
            width: 20.0,
          ),
          SizedBox(width: 12.0),
          Text(
            "$playerControlPoints control points, $playerProperties properties",
            style: TextStyle(
              color: AppColors.opaqueWhite,
            )
          ),
        ],
      ),
    );
  }
}

class MainMenuItem extends StatelessWidget {
  final String text;
  final Function() onTap;
  const MainMenuItem({
    required this.text,
    required this.onTap,
    super.key
  });

  final color = AppColors.darkBlue;
  final hoverColor = AppColors.blue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 220,
        child: ListTile(  
          title: Text(
            text,
            style: TextStyle(
              color: AppColors.opaqueWhite,
              fontSize: 18.0,
              fontWeight: .bold
            ),
            textAlign: .center
          ),
          tileColor: color,
          hoverColor: hoverColor,
          onTap: onTap,
        ),
      ),
    );
  }
}