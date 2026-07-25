import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/question_models/coding_problem.dart';
import 'package:territory_game/model/quiz_models/question_models/theory_question.dart';
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

    Board boardObj = Board.fromJson(boardJson);

    boardObj.checkBoardState();
  });
  
   test("json with property", () {
    board.state[1][1] = testProperty;
    Map<String, dynamic> boardJson = board.toJson();

    Board boardObj = Board.fromJson(boardJson);

    boardObj.checkBoardState();
  });

  test("getControlPointsByPlayer", () {
    board.state[1][1] = testProperty; // 1 points
    board.state[2][2] = testProperty2; // 2 points
    board.state[3][3] = testProperty3; // 5 points
    board.state[4][4] = testProperty4; // 10 points
    int points = board.getControlPointsByPlayer(testPlayer);
    expect(points, 18);
  }); 
  
}