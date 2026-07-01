import 'package:flutter/material.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/view/widgets/square_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    final board = widget.board.board;

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: board[0].length
      ),
      itemCount: 100,
      itemBuilder: (BuildContext context, int index) {
        int row = index ~/ 10;
        int col = index % 10;

        print((row, col));

        Color squareColor = getSquareColor(row, col); 

        return SquareWidget(color: squareColor);
      }    
    );
  }
}