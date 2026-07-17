import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';
import 'package:territory_game/services/chatbot_services/mistral_api_service.dart';
import 'package:territory_game/services/firebase_services/firebase_auth_service.dart';
import 'package:territory_game/services/timer_service/timer_service.dart';

void main() {
  
  Topic topic = Topic(
    name: "topic A",
    subTopics: ["subTopic A", "subTopic B"],
    week: 1
  );

  Game game = Game(
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

  final FirebaseAuthService firebaseAuth = FirebaseAuthService(
    activeUser: GameUser(email: "test@test.com", id: "id1")
  );

  final timer = TimerService(
    endTime: game.endTime
  );

  final chatbotProvider = ChatbotApiProvider();
  final mistralClient = MistralApiService(
    config: ChatbotConfig());
  chatbotProvider.addChatbot(mistralClient);

  final gameController = GameController(
    chatbotProvider: chatbotProvider,
    game: game,
    firebaseAuth: firebaseAuth,
    timer: timer
  );

  test("opponent", () {
    final opponent = gameController.opponent;
    print(gameController.boardState);
    print(gameController.activePlayer.id);
    print(opponent!.id);
  });
}