import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/square.dart';
import 'package:territory_game/view/widgets/game_screen/board/property_widget.dart';
import 'package:territory_game/view/widgets/game_screen/board/square_widget.dart';

/// This widget builds the game board based on the Board data model. 
class BoardWidget extends StatefulWidget {
  final Board board;
  const BoardWidget({
    required this.board,
    super.key
  });

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  int rows = AppDimensions.boardRows;
  int cols = AppDimensions.boardCols;
  /// The build method returns a GridView, where each item of the Grid is a SquareWidget object.
  @override
  Widget build(BuildContext context) {
    final playerMap = context.watch<GameController>().game.players;
    
    Color getPropertyColorFromOwner(Property property) {
      for (String playerId in playerMap.keys) {
        if (playerId == property.ownerId) {
          return playerMap[playerId]!.propertyColor;
        }
      }
      throw "No matching player ID.";
    }
    
    return Consumer<GameController>(
      builder: (context, gameController, child) => GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: rows
        ),
        itemCount: 100,
        itemBuilder: (BuildContext context, int index) {
          final row = index ~/ rows;
          final col = index % cols;
          final areaSpecificData = getAreaSpecificData(row, col);
          final squareData = Square(
            row: row, 
            col: col,
            area: areaSpecificData["area"],
            points: areaSpecificData["points"]
          );
          
          final squareProperty = gameController.boardState[row][col];

          return SquareWidget(
            square: squareData,
            color: areaSpecificData["color"],
            property: squareProperty != null 
            ? PropertyWidget(
                color: getPropertyColorFromOwner(squareProperty),
                property: squareProperty,
            )
            : null,
          );
        }
      )
    ); 
  }
  
  /// Returns the correct square color based on the coordinate of the square.
  /// 
  /// This delineates the four play areas of the board.
  Map<String, dynamic> getAreaSpecificData (int row, int col) {
    Map<String, dynamic> data = {};
    if (row >= 4 && row <= 5 && col >= 4 && col <= 5) {
      data["area"] = "The Pit";
      data["color"] = AppColors.pitRed;
      data["points"] = 10;
    } else if (row >= 3 && row <= 6 && col >= 3 && col <= 6) {
      data["area"] = "The Battleground";
      data["color"] = AppColors.battlegroundPurple;
      data["points"] = 5;
    } else if (row >= 2 && row <= 7 && col >= 2 && col <= 7) {
      data["area"] = "The Arena";
      data["color"] = AppColors.arenaGreen;
      data["points"] = 2;
    } else {
      data["area"] = "The Dojo";
      data["color"] = AppColors.dojoGrey;
      data["points"] = 1;
    }
    return data;
  }

  
}