import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/quiz_models/question_models/coding_problem.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';
import 'package:territory_game/services/chatbot_services/mistral_api_service.dart';

import 'dummy_gamecontroller.dart';

void main() {
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
  
  final ChatbotApiProvider chatbotProvider = ChatbotApiProvider();
  final mistralClient = MistralApiService(
    config: ChatbotConfig());
  chatbotProvider.addChatbot(mistralClient);
  
  Topic topic = Topic(
    name: "Functions",
    subTopics: ["Mutability", "Iteration"],
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
      name: "Introduction to Programming",
      questionTypes: ["multipleChoice", "codingProblem"],
      topics: [
        topic
      ],
    ),
    topic: topic
  );


  final gameController = DummyGameController(
    chatbotProvider: chatbotProvider, 
    game: testGame
  );

  final testQuiz = Quiz(
    questions: [
      CodingProblem(
        id: 1, 
        question: "Write a function that adds two numbers together", 
        inputExample: "1, 2", 
        outputExample: "3"
      )
    ],
    subTopic: "Functions",
    type: "codingProblem",
    userAnswers: [
      "def calculate(): 1 + 2 = 3"
    ]
  );

  test("QuizFeedback json", () async {
    final quizFeedback = await gameController.getFeedback(testQuiz);
    print(quizFeedback.results[0].score.runtimeType);
  });
}