import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/board.dart';

void main() {
  Board board = Board(
    rows: 10, 
    cols: 10
  );

  test("json", () {
    Map<String, dynamic> boardJson = board.toJson();

    Board boardObj = Board.fromJson(boardJson);

    boardObj.checkBoardState();
  });
  
}