import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/history.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';

void main() {
  Topic topic = Topic(
    name: "Topic A",
    subTopics: ["subTopic A", "subTopic B"],
  );

  Game testGame = Game(
    board: Board(
      cols: 10,
      rows: 10,
    ),
    startTime: DateTime.parse("2026-07-20 20:18:04"),
    endTime:  DateTime.parse("2026-07-23 20:18:04"),
    id: "gameid123",
    players: {
      "id1": Player(
        id: "id1",
        displayName: "name1",
        propertyColor: Colors.black,
      ),
    },
    subject: Subject(
      name: "Subject A",
      questionTypes: ["questionType1", "questionType2"],
      topics: [
        topic
      ],
    ),
    topic: topic,
    history: History(
      activityHistory: ["Event 1", "Event 2"],
      questionHistory: {
        "multipleChoice": ["MC1", "MC2"],
        "codingProblem": ["CP1", "CP2"]}
    )
  );

  /// Tests that the JSON serialisation/deserialisation methods produce the expected result.
  test("json", () {
    final gameJson = testGame.toJson();
    expect(gameJson["startTime"], "2026-07-20 20:18:04.000");
    expect(gameJson["endTime"], "2026-07-23 20:18:04.000");
    expect(gameJson["subject"], isA<Map<String, dynamic>>());
    expect(gameJson["subject"].containsKey("name"), true);
    expect(gameJson["subject"].containsKey("questionTypes"), true);
    expect(gameJson["subject"].containsKey("topics"), true);
    expect(gameJson["topic"], isA<Map<String, dynamic>>());
    expect(gameJson["topic"].containsKey("name"), true);
    expect(gameJson["topic"].containsKey("subTopics"), true);
    expect(gameJson["topic"].containsKey("week"), true);
    expect(gameJson["id"], "gameid123");
    expect(gameJson["board"], isA<Map<String, dynamic>>());
    expect(gameJson["board"].containsKey("rows"), true);
    expect(gameJson["board"].containsKey("cols"), true);
    expect(gameJson["board"].containsKey("state"), true);
    expect(gameJson["players"], isA<Map<dynamic, dynamic>>());
    expect(gameJson["players"].length, 1);
    expect(gameJson["history"], isA<Map<String, dynamic>>());
    expect(gameJson["history"].containsKey("activityHistory"), true);
    expect(gameJson["history"].containsKey("questionHistory"), true);
    
    final gameObj = Game.fromJson(gameJson);
    expect(gameObj.board.cols, 10);
    expect(gameObj.board.rows, 10);
    expect(gameObj.board.state.length, 10);
    expect(gameObj.board.state[0].length, 10);
    expect(gameObj.startTime, DateTime.parse("2026-07-20 20:18:04"));
    expect(gameObj.endTime, DateTime.parse("2026-07-23 20:18:04"));
    expect(gameObj.id, "gameid123");
    expect(gameObj.subject.name, "Subject A");
    expect(gameObj.subject.questionTypes, isA<List<String>>());
    expect(gameObj.subject.questionTypes.length, 2);
    expect(gameObj.subject.name, "Subject A");
    expect(gameObj.topic.name, "Topic A");
    expect(gameObj.topic.subTopics, isA<List<String>>());
    expect(gameObj.topic.subTopics.length, 2);
    expect(gameObj.players, isA<Map<String, Player>>());
    expect(gameObj.players.length, 1);
    expect(gameObj.history.activityHistory, isA<List<String>>());
    expect(gameObj.history.activityHistory.length, 2);
    expect(gameObj.history.questionHistory, isA<Map<String, List<String>>>());
    expect(gameObj.history.questionHistory.keys.length, 2);
    expect(gameObj.history.questionHistory["multipleChoice"]!.length, 2);
    expect(gameObj.history.questionHistory["codingProblem"]!.length, 2);
  });

  /// Tests that the containsPlayerWithId method returns true when an id is found and false when it is not.
  test("containsPlayerWithId", () {
    String userId = "id1";
    expect(testGame.containsPlayerWithId(userId), true);
    String userId2 = "falseid";
    expect(testGame.containsPlayerWithId(userId2), false);
  });

  /// Tests that players are successfully added to the game.
  group("addPlayer", () {
    final player2 = Player(
      id: "id2",
      displayName: "name2",
      propertyColor: Colors.white,
    );

    final player3 = Player(
      id: "id3",
      displayName: "name3",
      propertyColor: Colors.white,
    );
    
    /// Tests that players are successfully added to the game.
    test("addPlayer", () {
      testGame.addPlayer(player2);
      expect(testGame.players.length, 2);
    });

    test("addPlayer - blocks when list is full already", () {
      testGame.addPlayer(player2);
      testGame.addPlayer(player3);
      expect(testGame.players.length, 2);
    });
  });

  


  
}