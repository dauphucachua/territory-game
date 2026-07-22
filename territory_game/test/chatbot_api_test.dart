import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';
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
  
  test("multipleChoice test", () async {
    final topic = subject.topics[0];
    final subTopic = topic.subTopics[0];
    final questionType = "multipleChoice";
    final questionCount = 2;
    final List<String> questionHistory = [];
    final difficulty = "Easy";

    print("Hello");

    var quiz = await chatbotProvider.chatbot.getQuizJson(
      topic, 
      subTopic, 
      questionType, 
      questionCount,
      questionHistory,
      difficulty
    ); 
    
    if (quiz != null) {
      Quiz quizObj = Quiz.fromJson(quiz);
      print(quizObj);
    } else {
      print("Quiz null");
    }

    var quizTwo = await gameController.getQuiz(subTopic, questionType, questionCount, difficulty);
    print(quizTwo);
  });

  test("codingProblem test", () async {
    final topic = gameController.game.topic;
    final subTopic = gameController.game.topic.subTopics[0];
    final questionType = gameController.game.subject.questionTypes[1];
    final questionCount = 1;
    final List<String> questionHistory = [];
    final difficulty = "Easy";

    final quiz = await chatbotProvider.chatbot.getQuizJson(
      topic,
      subTopic,
      questionType,
      questionCount,
      questionHistory,
      difficulty
    );

    if (quiz != null) {
      Quiz quizObj = Quiz.fromJson(quiz);
      print(quizObj.questions);
    } else {
      print("Quiz null");
    }
  });

  test("getFeedback test", () async {
    final mockQuestion1 = MultipleChoiceQuestion(
      id: 1, 
      question: "How do you assign a string value to a variable in Python?", 
      correctAnswer: "x = 'Hello'", 
      distractors: ["x = hello", "x := hello", "x == 'hello'"]);

    final mockQuestion2 = MultipleChoiceQuestion(
      id: 2, 
      question: "How do you assign an integer value to a variable in Python?", 
      correctAnswer: "x = 1", 
      distractors: ["x = 1.0", "x := 1", "x == 1"]);

    Quiz mockQuiz = Quiz(
      type: "multipleChoice",
      subTopic: "Assignment",
      difficulty: "Easy",
      questions: [mockQuestion1, mockQuestion2],
    );

    Map<int, String> userAnswers = {1: "x = 'Hello'", 2: "x == 1"};

    mockQuiz.storeUserAnswers(userAnswers);

    var quizFeedback = await gameController.getFeedback(mockQuiz);
    
    expect(quizFeedback.results[0].id, 1);
    expect(quizFeedback.results[0].score, 10);
    expect(quizFeedback.results[0].feedback.isNotEmpty, true);
    expect(quizFeedback.results[1].id, 2);
    expect(quizFeedback.results[1].score, 0);
    expect(quizFeedback.results[1].feedback.isNotEmpty, true);
  });
}