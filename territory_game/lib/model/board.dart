/// A data model for the game board.
class Board {
  final int rows;
  final int cols;

  const Board({
    required this.rows,
    required this.cols
  });

  /// Generates a 2d list for managing the current state of the board.
  List<List<dynamic>> get board => List<List>.generate(
    rows, (x) => List<dynamic>.generate(
      cols, (y) => null
    ), 
    growable: false
  );

  /// Prints a representation of the board state.
  void checkBoardState() {
    for (int i = 0; i < board.length; i++) {
      print("$i: ${board[i].join(" ")}");
    }
  }
}