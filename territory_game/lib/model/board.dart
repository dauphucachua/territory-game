class Board {
  List<List<dynamic>> board = List<List>.generate(
    10, (x) => List<dynamic>.generate(
      10, (y) => null
    ), 
    growable: false
  );

  void checkBoardState() {
    for (int i = 0; i < board.length; i++) {
      print("$i: ${board[i].join(" ")}");
    }
  }
}