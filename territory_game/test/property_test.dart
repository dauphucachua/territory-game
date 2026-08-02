import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/question_models/question.dart';
import 'package:territory_game/model/quiz_models/question_models/theory_question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';

void main() {
  Property testProperty = Property(
    health: 100,
    ownerId: "1",
    quiz: Quiz(
      questions: [TheoryQuestion(id: 1, question: "Test question")],
      subTopic: "Subtopic",
      type: "theory",
      difficulty: "Easy"
    ),
    row: 1,
    col: 1,
  );

  test("get humanCoord", () {
    final coord = testProperty.humanCoord;
    expect(coord, (2, 9));
  });

  test("hasPerfectHealth - false", () {
    final hasPerfectHealth = testProperty.hasPerfectHealth;
    expect(hasPerfectHealth, false);
  });

  test("hasPerfectHealth - true", () {
    testProperty.health = 20;
    final hasPerfectHealth = testProperty.hasPerfectHealth;
    expect(hasPerfectHealth, true);
  });



}