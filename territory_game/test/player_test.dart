import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';

void main() {
   Property testProperty = Property(
    health: 100,
    ownerId: "1",
    quiz: Quiz(
      questions: [
        MultipleChoiceQuestion(
          id: 1, 
          question: "Question 1", 
          distractors: ["d1", "d2" ], 
          correctAnswer: "Question 1"
        )
      ],
      subTopic: "Subtopic",
      type: "multipleChoice",
    ),
    row: 1,
    col: 1
  );

  Player player = Player(
    id: "1",
    properties: [testProperty],
    propertyToPlace: null
  );

  test("json", () {
    final playerJson = player.toJson();
    final playerObj = Player.fromJson(playerJson);

    print(playerObj.properties);
  });
}
  