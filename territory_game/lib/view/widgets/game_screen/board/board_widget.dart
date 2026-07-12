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
    

    return Consumer<GameController>(
      builder: (context, gameController, child) => GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: rows
        ),
        itemCount: 100,
        itemBuilder: (BuildContext context, int index) {
          int row = index ~/ rows;
          int col = index % cols;
          Color squareColor = getSquareColor(row, col);
          Square squareData = Square(x: row, y: col);
          Property? squareProperty = gameController.boardState[row][col];

          return SquareWidget(
            square: squareData,
            color: squareColor,
            property: squareProperty != null 
            ? PropertyWidget(
                color: Colors.black,
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
  Color getSquareColor(int row, int col) {
    if (row >= 4 && row <= 5 && col >= 4 && col <= 5) {
      return const Color.fromARGB(255, 165, 55, 51);
    } else if (row >= 3 && row <= 6 && col >= 3 && col <= 6) {
      return const Color.fromARGB(255, 118, 50, 135);
    } else if (row >= 2 && row <= 7 && col >= 2 && col <= 7) {
      return const Color.fromARGB(255, 87, 138, 50);
    } else {
      return const Color.fromARGB(255, 78, 101, 123);
    }
  }
}