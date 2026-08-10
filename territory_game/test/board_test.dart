import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/question_models/coding_problem.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';

void main() {
  Board board = Board(
    rows: 10, 
    cols: 10
  );

  Player testPlayer = Player(
    displayName: "name",
    id: "1",
    propertyColor: Colors.black,
  );

  Property testProperty = Property(
    health: 100,
    ownerId: "1",
    quiz: Quiz(
      questions: [CodingProblem(id: 1, question: "Test question", inputExample: "input", outputExample: "output")],
      subTopic: "Subtopic",
      type: "codingProblem",
      difficulty: "Easy"
    ),
    row: 1,
    col: 1
  );
  
  Property testProperty2 = Property(
    health: 100,
    ownerId: "1",
    quiz: Quiz(
      questions: [CodingProblem(id: 1, question: "Test question", inputExample: "input", outputExample: "output")],
      subTopic: "Subtopic",
      type: "codingProblem",
      difficulty: "Easy"
    ),
    row: 2,
    col: 2
  );

  Property testProperty3 = Property(
    health: 100,
    ownerId: "1",
    quiz: Quiz(
      questions: [CodingProblem(id: 1, question: "Test question", inputExample: "input", outputExample: "output")],
      subTopic: "Subtopic",
      type: "codingProblem",
      difficulty: "Easy"
    ),
    row: 3,
    col: 3
  );

  Property testProperty4 = Property(
    health: 100,
    ownerId: "1",
    quiz: Quiz(
      questions: [CodingProblem(id: 1, question: "Test question", inputExample: "input", outputExample: "output")],
      subTopic: "Subtopic",
      type: "codingProblem",
      difficulty: "Easy"
    ),
    row: 4,
    col: 4
  );

  test("json", () {
    Map<String, dynamic> boardJson = board.toJson();
    expect(boardJson["rows"], 10);
    expect(boardJson["cols"], 10);
    expect(boardJson["state"]["row 0"], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardJson["state"]["row 1"], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardJson["state"]["row 2"], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardJson["state"]["row 3"], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardJson["state"]["row 4"], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardJson["state"]["row 5"], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardJson["state"]["row 6"], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardJson["state"]["row 7"], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardJson["state"]["row 8"], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardJson["state"]["row 9"], [null, null, null, null, null, null, null, null, null, null]);

    Board boardObj = Board.fromJson(boardJson);
    expect(boardObj.rows, 10);
    expect(boardObj.cols, 10);
    expect(boardObj.state[0], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardObj.state[1], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardObj.state[2], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardObj.state[3], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardObj.state[4], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardObj.state[5], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardObj.state[6], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardObj.state[7], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardObj.state[8], [null, null, null, null, null, null, null, null, null, null]);
    expect(boardObj.state[9], [null, null, null, null, null, null, null, null, null, null]);
  });
  
   test("json with property", () {
    board.state[1][1] = testProperty;
    Map<String, dynamic> boardJson = board.toJson();
    expect(boardJson["state"]["row 1"][1]["health"], 100);
    expect(boardJson["state"]["row 1"][1]["isBattling"], "false");
    expect(boardJson["state"]["row 1"][1]["row"], 1);
    expect(boardJson["state"]["row 1"][1]["col"], 1);
    expect(boardJson["state"]["row 1"][1]["quiz"].containsKey("questions"), true);
    expect(boardJson["state"]["row 1"][1]["quiz"].containsKey("difficulty"), true);
    expect(boardJson["state"]["row 1"][1]["quiz"].containsKey("subTopic"), true);
    expect(boardJson["state"]["row 1"][1]["quiz"].containsKey("quizType"), true);

    Board boardObj = Board.fromJson(boardJson);
    expect(boardObj.state[1][1].runtimeType, Property);
    expect(boardObj.state[1][1].health, 100);
    expect(boardObj.state[1][1].isBattling, false);
    expect(boardObj.state[1][1].row, 1);
    expect(boardObj.state[1][1].col, 1);
    expect(boardObj.state[1][1].quiz.runtimeType, Quiz);
  });

  test("getBoardArea", () {
    expect(board.getBoardArea(1, 1), "The Dojo");
    expect(board.getBoardArea(2, 2), "The Arena");
    expect(board.getBoardArea(3, 3), "The Battleground");
    expect(board.getBoardArea(4, 4), "The Pit");
  });

  test("getControlPointsByPlayer", () {
    board.state[1][1] = testProperty; // 1 points
    board.state[2][2] = testProperty2; // 2 points
    board.state[3][3] = testProperty3; // 5 points
    board.state[4][4] = testProperty4; // 10 points
    final points = board.getControlPointsByPlayer(testPlayer);
    expect(points, 18);
  }); 
  
}