import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/question_models/coding_problem.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';
import 'package:territory_game/services/chatbot_services/mistral_api_service.dart';
import 'dummy_gamecontroller.dart';

void main() {
  late Topic topic;
  late Game game;
  late ChatbotApiProvider chatbotProvider;
  late MistralApiService mistralClient;
  late DummyGameController gameController;
  late Property testProperty;
  late Property testProperty2;
  late Property testProperty3;
  late Property testProperty4;
  late Property testProperty5;

  setUp(() {
    topic = Topic(
      name: "topic A",
      subTopics: ["subTopic A", "subTopic B", "subTopic C"],
      week: 1,
    );

    game = Game(
      board: Board(cols: 10, rows: 10),
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(days: 1000)),
      id: "gameid123",
      players: {
        "id1": Player(
          id: "id1",
          displayName: "name1",
          propertyColor: Colors.black,
        ),
        "id2": Player(
          id: "id2",
          displayName: "name2",
          propertyColor: Colors.white,
        ),
      },
      subject: Subject(
        name: "subject A",
        questionTypes: ["questionType1", "questionType2"],
        topics: [topic],
      ),
      topic: topic,
    );

    chatbotProvider = ChatbotApiProvider();
    mistralClient = MistralApiService(config: ChatbotConfig());
    chatbotProvider.addChatbot(mistralClient);

    gameController = DummyGameController(
      chatbotProvider: chatbotProvider,
      game: game,
    );
  });

  group("Board area - limitation of property counts", () {
    setUp(() {
      testProperty = Property(
        health: 100,
        ownerId: "1",
        quiz: Quiz(
          questions: [
            CodingProblem(
              id: 1,
              question: "Test question",
              inputExample: "input",
              outputExample: "output",
            ),
          ],
          subTopic: "subTopic A",
          type: "codingProblem",
          difficulty: "Easy",
        ),
        row: 1,
        col: 1,
      );

      testProperty2 = Property(
        health: 100,
        ownerId: "1",
        quiz: Quiz(
          questions: [
            CodingProblem(
              id: 1,
              question: "Test question",
              inputExample: "input",
              outputExample: "output",
            ),
          ],
          subTopic: "subTopic A",
          type: "codingProblem",
          difficulty: "Easy",
        ),
        row: 2,
        col: 2,
      );

      testProperty3 = Property(
        health: 100,
        ownerId: "1",
        quiz: Quiz(
          questions: [
            CodingProblem(
              id: 1,
              question: "Test question",
              inputExample: "input",
              outputExample: "output",
            ),
          ],
          subTopic: "subTopic A",
          type: "codingProblem",
          difficulty: "Easy",
        ),
        row: 3,
        col: 3,
      );

      testProperty4 = Property(
        health: 100,
        ownerId: "1",
        quiz: Quiz(
          questions: [
            CodingProblem(
              id: 1,
              question: "Test question",
              inputExample: "input",
              outputExample: "output",
            ),
          ],
          subTopic: "subTopic A",
          type: "codingProblem",
          difficulty: "Easy",
        ),
        row: 4,
        col: 4,
      );

      testProperty5 = Property(
        health: 100,
        ownerId: "1",
        quiz: Quiz(
          questions: [
            CodingProblem(
              id: 1,
              question: "Test question",
              inputExample: "input",
              outputExample: "output",
            ),
          ],
          subTopic: "subTopic A",
          type: "codingProblem",
          difficulty: "Easy",
        ),
      );

      gameController.boardState[1][1] = testProperty;
      gameController.boardState[2][2] = testProperty2;
      gameController.boardState[3][3] = testProperty3;
      gameController.boardState[4][4] = testProperty4;
    });
    test("subTopicCountPerArea", () {
      final countMap = gameController.subTopicCountPerArea();
      expect(countMap["subTopic A"]!["The Dojo"], 1);
      expect(countMap["subTopic A"]!["The Arena"], 1);
      expect(countMap["subTopic A"]!["The Battleground"], 1);
      expect(countMap["subTopic A"]!["The Pit"], 1);
    });

    test("subTopicLimitSurpassed - false", () {
      expect(
        gameController.subTopicLimitSurpassed(testProperty5, row: 1, col: 2),
        false,
      );
    });

    test("subTopicLimitSurpassed - true", () {
      expect(
        gameController.subTopicLimitSurpassed(testProperty5, row: 5, col: 5),
        true,
      );
    });
  });
}
