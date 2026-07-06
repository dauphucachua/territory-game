import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_api_provider.dart';
import 'package:territory_game/services/chatbot_config.dart';
import 'package:territory_game/services/mistral_api.dart';

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

  print("Hello");
  
  final board = Board(
    cols: 10,
    rows: 10
  );

  final gameController = GameController(chatbotProvider: chatbotProvider, board: board, subject: subject, topic: subject.topics[0]);
  
  test("multipleChoice test", () async {
    Topic topic = subject.topics[0];
    String subTopic = topic.subTopics[0];
    String questionType = "multipleChoice";
    int questionCount = 2;

    print("Hello");

    var quiz = await chatbotProvider.chatbot.getQuizJson(
      topic, 
      subTopic, 
      questionType, 
      questionCount
    ); 
    
    if (quiz != null) {
      Quiz quizObj = Quiz.fromJson(quiz);
      print(quizObj);
    } else {
      print("Quiz null");
    }

    var quizTwo = await gameController.getQuiz(subTopic, questionType, questionCount);
    print(quizTwo);
  });
}