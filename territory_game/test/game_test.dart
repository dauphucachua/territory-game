import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';

void main() {
  Topic topic = Topic(
    name: "topic A",
    subTopics: ["subTopic A", "subTopic B"],
    week: 1
  );

  Game testGame = Game(
    board: Board(
      cols: 10,
      rows: 10,
    ),
    startTime: DateTime.now(),
    endTime: DateTime.now().add(Duration(days: 1000)),
    id: "gameid123",
    players: {
      "id1": Player(
        id: "id1",
        propertyColor: Colors.black,
      ),
      "id2": Player(
        id: "id2",
        propertyColor: Colors.white,
      ),
    },
    subject: Subject(
      name: "subject A",
      questionTypes: ["questionType1", "questionType2"],
      topics: [
        topic
      ],
    ),
    topic: topic
  );

  test("containsPlayerWithId", () {
    String userId = "id1";
    expect(testGame.containsPlayerWithId(userId), true);
    String userId2 = "falseid";
    expect(testGame.containsPlayerWithId(userId2), false);
  });

  test("toJson", () {
    final gameJson = testGame.toJson();
    print(gameJson.toString());
  });
}