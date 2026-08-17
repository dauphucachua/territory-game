import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/question_models/coding_problem.dart';
import 'package:territory_game/model/quiz_models/question_models/theory_question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';

void main() {
  Property testProperty = Property(
    health: 100,
    ownerId: "1",
    quiz: Quiz(
      questions: [
        CodingProblem(
          id: 1, 
          question: "Test question",
          inputExample: "inputExample",
          outputExample: "outputExample"
        )
      ],
      subTopic: "Subtopic",
      type: "codingProblem",
      difficulty: "Easy"
    ),
    row: 1,
    col: 1,
  );

  /// Tests that the JSON serialisation/deserialisation methods produce the expected result.
  test("json", () {
    final testPropertyJson = testProperty.toJson();

    expect(testPropertyJson["health"], 100);
    expect(testPropertyJson["quiz"], isA<Map<String, dynamic>>());
    expect(testPropertyJson["ownerId"], "1");
    expect(testPropertyJson["row"], 1);
    expect(testPropertyJson["col"], 1);

    final testPropertyObj = Property.fromJson(testPropertyJson);

    expect(testPropertyObj.health, 100);
    expect(testPropertyObj.quiz, isA<Quiz>());
    expect(testPropertyObj.ownerId, "1");
    expect(testPropertyObj.row, 1);
    expect(testPropertyObj.col, 1);

    
  });

  /// Tests that humanCoord correctly converts indices to a human-readable coordinate.
  test("get humanCoord", () {
    final coord = testProperty.humanCoord;
    expect(coord, (2, 9));
  });

  /// Tests that isPlaced returns true when a property has a coordinate.
  test("isPlaced - true", () {
    expect(testProperty.isPlaced, true);
  });

  /// Tests that isPlaced returns false when a property does not have a coordinate.
  test("isPlaced - false", () {
    testProperty.row = null;
    testProperty.col = null;

    expect(testProperty.isPlaced, false);
  });

  /// Tests that hasPerfectHealth returns false when the property does not have a perfect score.
  test("hasPerfectHealth - false", () {
    final hasPerfectHealth = testProperty.hasPerfectHealth;
    expect(hasPerfectHealth, false);
  });
  
  /// Tests that hasPerfectHealth returns true when the property has a perfect score.
  test("hasPerfectHealth - true", () {
    testProperty.health = 20;
    final hasPerfectHealth = testProperty.hasPerfectHealth;
    expect(hasPerfectHealth, true);
  });

  /// Tests that isEnemyOf returns true when a given property is owned by another player.
  test("isEnemyOf - true", () {
    Property testProperty2 = Property(
      health: 100,
      ownerId: "2",
      quiz: Quiz(
        questions: [TheoryQuestion(id: 1, question: "Test question")],
        subTopic: "Subtopic",
        type: "theory",
        difficulty: "Easy"
      ),
      row: 1,
      col: 2,
    );

    expect(testProperty.isEnemyOf(testProperty2), true);
  });

  /// Tests that isEnemyOf returns false when a given property is owned by the active player.
  test("isEnemyOf - false", () {
    Property testProperty2 = Property(
      health: 100,
      ownerId: "1",
      quiz: Quiz(
        questions: [TheoryQuestion(id: 1, question: "Test question")],
        subTopic: "Subtopic",
        type: "theory",
        difficulty: "Easy"
      ),
      row: 1,
      col: 2,
    );

    expect(testProperty.isEnemyOf(testProperty2), false);
  });

  /// Tests that isAdjacentTo returns true when a given property is within the surrounding eight squares
  /// of the current property.
  test("isAdjacentTo - true", () {
    // Iterate through all the squares adjacent to [1][1] - where testProperty is positioned
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        Property testProperty2 = Property(
          health: 100,
          ownerId: "2",
          quiz: Quiz(
            questions: [TheoryQuestion(id: 1, question: "Test question")],
            subTopic: "Subtopic",
            type: "theory",
            difficulty: "Easy"
          ),
          row: row,
          col: col,
        );

        // Filter out [1][1] itself
        if (testProperty.row! != 1 && testProperty.col! != 1) {
          expect(testProperty.isAdjacentTo(testProperty2), true);
        } 
      }
    }
  });

  /// Tests that isAdjacentTo returns false when a given property is not within the surrounding eight squares
  /// of the current property.
  test("isAdjacentTo - false", () {
    // Iterate through all the square on a 10x10 board
    for (int row = 0; row < 10; row++) {
      for (int col = 0; col < 10; col++) {
        // Create a property positioned on the current square
        Property testProperty2 = Property(
          health: 100,
          ownerId: "2",
          quiz: Quiz(
            questions: [TheoryQuestion(id: 1, question: "Test question")],
            subTopic: "Subtopic",
            type: "theory",
            difficulty: "Easy"
          ),
          row: row,
          col: col,
        );

        // Calculate the vector from testProperty to the current position
        final vectorFromProperty = (testProperty.row! - row, testProperty.col! - col);
        Set adjacencyVectors = {
          (0, 1), (1, 1), (1, 0), (1, -1), (-1, 1), (-1, 0), (-1, -1), (0, -1)
        };

        // Filter out vectors that should trigger adjacency
        if (!adjacencyVectors.contains(vectorFromProperty)) {
          // Expect a false result for all other squares
          expect(testProperty.isAdjacentTo(testProperty2), false);
        }
      }
    }
  });

  /// Tests that canAttack returns true when a given property is an enemy of and is adjacent to
  /// the current property.
  test("canAttack - true", () {
    Property testProperty2 = Property(
      health: 100,
      ownerId: "2",
      quiz: Quiz(
        questions: [TheoryQuestion(id: 1, question: "Test question")],
        subTopic: "Subtopic",
        type: "theory",
        difficulty: "Easy"
      ),
      row: 1,
      col: 2,
    );

    expect(testProperty.canAttack(testProperty2), true);
  });

  /// Tests that canAttack returns false when a given property is not an enemy of / adjacent to
  /// the current property.
  test("canAttack - false", () {
    // Not an enemy property
    Property testProperty2 = Property(
      health: 100,
      ownerId: "1",
      quiz: Quiz(
        questions: [TheoryQuestion(id: 1, question: "Test question")],
        subTopic: "Subtopic",
        type: "theory",
        difficulty: "Easy"
      ),
      row: 1,
      col: 2,
    );

    // Not an adjacent property
    Property testProperty3 = Property(
      health: 100,
      ownerId: "1",
      quiz: Quiz(
        questions: [TheoryQuestion(id: 1, question: "Test question")],
        subTopic: "Subtopic",
        type: "theory",
        difficulty: "Easy"
      ),
      row: 1,
      col: 3,
    );

    expect(testProperty.canAttack(testProperty2), false);
    expect(testProperty.canAttack(testProperty3), false);
  });


}