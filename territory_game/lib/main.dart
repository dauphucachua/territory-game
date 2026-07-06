import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/firebase_options.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/services/chatbot_api_provider.dart';
import 'package:territory_game/services/chatbot_config.dart';
import 'package:territory_game/services/mistral_api.dart';
import 'package:territory_game/view/screens/game_screen.dart';

void main() async {

  Map<String, dynamic> exampleSubject = {
    "name": "Introduction to Programming",
    "topics": [
      {
          "name": "Variables",
          "week": 1,
          "subTopics": [
              "Naming",
              "Conventions",
              "Values"
          ]
      },
      {
          "name": "Functions",
          "week": 2,
          "subTopics": [
              "Scope",
              "Iteration"
          ]
      },
    ],
    "questionTypes": [
        "multipleChoice",
        "theory",
        "codingProblem",
        "codingExercise"
    ]
  };


  Subject subject = Subject.fromJson(exampleSubject);
  print(subject);

  // Example objects for testing
  final board = Board(
    rows: 10,
    cols: 10
  );

  final ChatbotApiProvider chatbotProvider = ChatbotApiProvider();
  final mistralClient = MistralApiService(
    config: ChatbotConfig());
  chatbotProvider.addChatbot(mistralClient);
  
  final gameController = GameController(
    chatbotProvider: chatbotProvider,
    board: board, 
    subject: subject,
    topic: subject.topics[0]
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MainApp(gameController));
}

class MainApp extends StatelessWidget {
  final GameController gameController;
  const MainApp(this.gameController, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(gameController)
    );
  }
}
