import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    final activePlayer = gameController.activePlayer;
    Player? opponent = gameController.opponent;
    int? opponentPoints;
    final playerPoints = gameController.getControlPointsByPlayerId(activePlayer.id);
    opponentPoints = opponent != null ? gameController.getControlPointsByPlayerId(opponent.id) : 0; 
    
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Padding(
        padding: const .symmetric(horizontal: 300, vertical: 100),
        child: Center(
          child: Container(
            padding: .all(32.0),
            width: 700,
            height: 400,
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: .all(.circular(30.0)),
            ),
            child: Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .center,
              children: [
                TitleText(text: "Game over"),
                SubtitleText(text: opponent != null 
                  ? "${activePlayer.displayName} vs. ${opponent.displayName}"
                  : "${activePlayer.displayName} vs. no-one"
                ),
                if (playerPoints > opponentPoints)
                  SubtitleText(text: "${activePlayer.displayName} wins!")
                else if (playerPoints == opponentPoints)
                  SubtitleText(text: "It's a draw!")
                else
                  SubtitleText(text: "${opponent?.displayName} wins!"),
                SizedBox(height: 64.0),
                SubtitleText(text: "$playerPoints control points vs. $opponentPoints control points"),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context), 
                  child: Text(
                    "Return to main menu",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.blue
                    )
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}