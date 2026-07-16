import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/question_models/coding_problem.dart';
import 'package:territory_game/model/quiz_models/question_models/theory_question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';

void main() {
  Board board = Board(
    rows: 10, 
    cols: 10
  );

  Property testProperty = Property(
    health: 100,
    ownerId: "1",
    quiz: Quiz(
      questions: [CodingProblem(id: 1, question: "Test question", inputExample: "input", outputExample: "output")],
      subTopic: "Subtopic",
      type: "codingProblem",
    ),
    row: 1,
    col: 1
  );

  test("json", () {
    
    Map<String, dynamic> boardJson = board.toJson();

    Board boardObj = Board.fromJson(boardJson);

    boardObj.checkBoardState();
  });
  
   test("json with property", () {
    board.state[1][1] = testProperty;
    Map<String, dynamic> boardJson = board.toJson();

    Board boardObj = Board.fromJson(boardJson);

    boardObj.checkBoardState();
  });
  
}