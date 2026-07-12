import 'package:territory_game/model/property.dart';

/// A data model for the game board.
class Board {
  final int rows;
  final int cols;
  /// Generates a 2d list for managing the current state of the board.
  late final List<List<dynamic>> state = List<List>.generate(
    rows, (x) => List<dynamic>.generate(
      cols, (y) => null
    ), 
    growable: false
  );

  Board({
    required this.rows,
    required this.cols
  });

  /// Prints a representation of the board state.
  void checkBoardState() {
    for (int i = 0; i < state.length; i++) {
      print("$i: ${state[i].join(" ")}");
    }
  }
}