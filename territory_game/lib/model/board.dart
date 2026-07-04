class Board {
  final int rows;
  final int cols;

  const Board({
    required this.rows,
    required this.cols
  });

  List<List<dynamic>> get board => List<List>.generate(
    rows, (x) => List<dynamic>.generate(
      cols, (y) => null
    ), 
    growable: false
  );

  void checkBoardState() {
    for (int i = 0; i < board.length; i++) {
      print("$i: ${board[i].join(" ")}");
    }
  }
}