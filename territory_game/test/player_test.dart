import 'package:flutter/material.dart';
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
          correctAnswer: "Question 1",
        )
      ],
      subTopic: "Subtopic",
      type: "multipleChoice",
      difficulty: "Easy"
    ),
    row: 1,
    col: 1
  );

  Player player = Player(
    id: "1",
    displayName: "name",
    propertyColor: Colors.black,
    propertyToPlace: null
  );

  /// Tests that the JSON serialisation/deserialisation methods produce the expected result.
  test("json", () {
    final playerJson = player.toJson();
    expect(playerJson["id"], "1");
    expect(playerJson["displayName"], "name");
    expect(playerJson["propertyColor"], "black");
    expect(playerJson["propertyToPlace"], null);

    final playerObj = Player.fromJson(playerJson);
    expect(playerObj.id, "1");
    expect(playerObj.displayName, "name");
    expect(playerObj.propertyColor, Colors.black);
    expect(playerObj.propertyToPlace, null);
  });

 
  group("mustPlaceProperty", () { 
    /// Tests that the mustPlaceProperty getter returns true when a player's propertyToPlace field
    /// is not null.
    test("mustPlaceProperty - true", () {
      player.propertyToPlace = testProperty;
      expect(player.mustPlaceProperty, true
    );
  });

    /// Tests that the mustPlaceProperty getter returns false when a player's propertyToPlace field
    /// is null.
    test("mustPlaceProperty - false", () {
      player.propertyToPlace = null;
      expect(player.mustPlaceProperty, false);
    });
  });

  
}
  