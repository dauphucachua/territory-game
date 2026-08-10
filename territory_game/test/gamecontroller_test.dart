import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/question_feedback.dart';
import 'package:territory_game/model/quiz_models/question_models/coding_problem.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_feedback.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';
import 'package:territory_game/services/chatbot_services/mistral_api_service.dart';
import 'dummy_firebase_auth.dart';
import 'dummy_gamecontroller.dart';

void main() {
  late Topic topic;
  late ChatbotApiProvider chatbotProvider;
  late MistralApiService mistralClient;
  late DummyGameController gameController;
  late DummyGameController gameController2;
  late Player testPlayer;
  late Property testProperty;
  late Property testProperty2;
  late Property testProperty3;
  late Property testProperty4;
  late Property testProperty5;
  late Quiz testQuiz;

  setUp(() {
    topic = Topic(
      name: "topic A",
      subTopics: ["subTopic A", "subTopic B", "subTopic C"],
      week: 1,
    );

    chatbotProvider = ChatbotApiProvider();
    mistralClient = MistralApiService(config: ChatbotConfig());
    chatbotProvider.addChatbot(mistralClient);

    gameController = DummyGameController(
      chatbotProvider: chatbotProvider,
      game: Game(
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
      ),
      firebaseAuth: DummyFirebaseAuthService(
        activeUser: GameUser(
          email: "email1",
          id: "id1",
        )
      )
    );
  });

  testProperty = Property(
    health: 100,
    ownerId: "id1",
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

  group("Board area - limitation of property counts", () {
    setUp(() {
      
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

  group("placeProperty", () {
    test("placeProperty - accepted", () {
      expect(gameController.placeProperty(testProperty, row: 1, col: 1), true);
      expect(gameController.boardState[1][1], testProperty);    
    });

    test("placeProperty - rejected", () {
      gameController.boardState[1][1] = testProperty;
      expect(gameController.placeProperty(testProperty, row: 1, col: 1), false);
    });
  });

  group("addPlayerToGame", () {
    setUp(() {
      // A GameController with only one player in the game
      gameController2 = DummyGameController(
        chatbotProvider: chatbotProvider,
        game: Game(
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
          },
          subject: Subject(
            name: "subject A",
            questionTypes: ["questionType1", "questionType2"],
            topics: [topic],
          ),
          topic: topic,
        ),
        firebaseAuth: DummyFirebaseAuthService(
          activeUser: GameUser(
            email: "email2",
            id: "id2",
          )
        )
      );
    });
    
    testPlayer = Player(
      displayName: "name2",
      id: "id2",
      propertyColor: Colors.white
    );

    test("addPlayerToGame - success", () {
      gameController2.addPlayerToGame(testPlayer);
      expect(gameController2.game.players.length, 2);
      expect(gameController2.activeUser.activeGameIds.contains("gameid123"), true);
    });

    test("addPlayerToGame - failure", () {
      final mismatchedIdPlayer = Player(
        displayName: "name3",
        id: "id3",
        propertyColor: Colors.white
      );
      
      expect(() => gameController2.addPlayerToGame(mismatchedIdPlayer), 
        throwsA('Authorized user ID does not match Player object ID.')
      );
      expect(gameController2.game.players.length, 1);
    });

    test("setPropertyToPlace", () {
      gameController.setPropertyToPlace(testProperty);
      expect(gameController.activePlayer.propertyToPlace, testProperty); 
    });
    
    test("strengthenProperty", () {
      testQuiz = Quiz( 
        difficulty: "Easy",
        questions: [
          CodingProblem(
            id: 1, 
            question: "Question 1", 
            inputExample: "inputExample", 
            outputExample: "outputExample"
          ),
        ],
        subTopic: "subTopic A",
        type: "codingProblem",
      );

      final newQuizScore = 70;

      gameController.strengthenProperty(testProperty, testQuiz, newQuizScore);
      expect(testProperty.questionCount, 2);
      expect(testProperty.health, 170);
    });

    late Property attackingProperty;
    late Property defendingProperty;

    group("battling", () {
      setUp(() {
        attackingProperty = Property(
          health: 100,
          ownerId: "id1",
          quiz: Quiz(
            questions: [
              CodingProblem(
                id: 1,
                question: "Test question",
                inputExample: "inputExample",
                outputExample: "outputExample",
              ),
            ],
            subTopic: "subTopic A",
            type: "codingProblem",
            difficulty: "Easy",
          ),
          row: 1,
          col: 1,
        );
        
        defendingProperty = Property(
          health: 50,
          ownerId: "id2",
          quiz: Quiz(
            questions: [
              CodingProblem(
                id: 1,
                question: "Test question",
                inputExample: "input",
                outputExample: "output",
              ),
            ],
            subTopic: "subTopic C",
            type: "codingProblem",
            difficulty: "Easy",
          ),
          row: 1,
          col: 2,
        );
      });

      test("setBattle result", () {  
        
        gameController.setBattle(attackingProperty, defendingProperty);
        expect(gameController.activePlayer.activeBattle!.attacker, attackingProperty);  
        expect(gameController.activePlayer.activeBattle!.defender, defendingProperty);   
        expect(attackingProperty.isBattling, true);
        expect(defendingProperty.isBattling, true); 
      });

      test("battle - attacker wins", () {
        gameController.boardState[1][1] = attackingProperty;
        gameController.boardState[1][2] = defendingProperty;
        expect(gameController.boardState[1][2].ownerId, "id2");

        gameController.setBattle(attackingProperty, defendingProperty);
        final attackerScore = 80;
        gameController.battle(attackerScore);
        expect(gameController.boardState[1][2].ownerId, "id1");
        expect(gameController.boardState[1][1].isBattling, false);
        expect(gameController.boardState[1][2].isBattling, false);
      });

      test("battle - attacker loses", () {
        gameController.boardState[1][1] = attackingProperty;
        gameController.boardState[1][2] = defendingProperty;
        expect(gameController.boardState[1][2].ownerId, "id2");
        
        gameController.setBattle(attackingProperty, defendingProperty);
        final attackerScore = 20;
        gameController.battle(attackerScore);
        expect(gameController.boardState[1][2].ownerId, "id2");
        expect(gameController.boardState[1][1].health, 50);
        expect(gameController.boardState[1][1].isBattling, false);
        expect(gameController.boardState[1][2].isBattling, false);
      });      
    });
    
    group("get by playerId", () {
      setUp(() {
         testProperty2 = Property(
          health: 100,
          ownerId: "id1",
          quiz: Quiz(
            questions: [
              CodingProblem(
                id: 1,
                question: "Test question",
                inputExample: "inputExample",
                outputExample: "outputExample",
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
          health: 50,
          ownerId: "id2",
          quiz: Quiz(
            questions: [
              CodingProblem(
                id: 1,
                question: "Test question",
                inputExample: "input",
                outputExample: "output",
              ),
            ],
            subTopic: "subTopic C",
            type: "codingProblem",
            difficulty: "Easy",
          ),
          row: 3,
          col: 3,
        );
      });
      
      test("getPropertiesByPlayerId", () {
        gameController.boardState[1][1] = testProperty;
        gameController.boardState[2][2] = testProperty2;
        gameController.boardState[3][3] = testProperty3;

        expect(gameController.getPropertiesByPlayerId("id1").length, 2);
        expect(gameController.getPropertiesByPlayerId("id2").length, 1);
      });

      test("getControlPointsByPlayerId", () {
        gameController.boardState[1][1] = testProperty;
        gameController.boardState[2][2] = testProperty2;
        gameController.boardState[3][3] = testProperty3;

        expect(gameController.getControlPointsByPlayerId("id1"), 3);
        expect(gameController.getControlPointsByPlayerId("id2"), 5);
      });
    });

    group("quiz methods", () {
      setUp(() {
        testQuiz = Quiz( 
          difficulty: "Easy",
          questions: [
            CodingProblem(
              id: 1, 
              question: "Write a function that returns the sum of two numbers.", 
              inputExample: "2, 3", 
              outputExample: "5"
            ),
          ],
          subTopic: "Functions",
          type: "codingProblem",
        );
      });
      test("getQuiz", () async {
        final quiz = await gameController.getQuiz(
          "Variables",
          "multipleChoice",
          5,
          "Easy"
        );

        expect(quiz.runtimeType, Quiz);
        expect(quiz.questions.length, 5);
        expect(quiz.type, "multipleChoice");
        expect(quiz.subTopic, "Variables");
        expect(quiz.difficulty, "Easy");
      });

      test("getFeedback", () async {
        final feedback = await gameController.getFeedback(testQuiz);

        expect(feedback.runtimeType, QuizFeedback);
        expect(feedback.results.length, 1);
        expect(feedback.results[0].runtimeType, QuestionFeedback);
        expect(feedback.results[0].feedback.runtimeType, String);
        expect(feedback.results[0].score.runtimeType, int);
      });

      test("addBonusQuestionToQuiz", () async {
        await gameController.addBonusQuestionToQuiz(testQuiz);

        expect(testQuiz.questions.length, 2);
        expect(testQuiz.questions[0].id, 1);
        expect(testQuiz.questions[1].id, 2);
      });
    });

    group("message saving methods", () {
      test("saveToQuestionHistory", () {
        final questionType = "multipleChoice";
        final questions = [
          MultipleChoiceQuestion(
            id: 1,
            correctAnswer: "Answer 1",
            distractors: ["Answer 2, Answer 3, Answer 4"],
            question: "Question 1"
          ),
          MultipleChoiceQuestion(
            id: 2,
            correctAnswer: "Answer 1",
            distractors: ["Answer 2, Answer 3, Answer 4"],
            question: "Question 2"
          )
        ];

        gameController.saveToQuestionHistory(
          questionType,
          questions
        );

        expect(gameController.game.history.questionHistory["multipleChoice"]!.length, 2);
        expect(gameController.game.history.questionHistory["multipleChoice"]![0], "Question 1");
        expect(gameController.game.history.questionHistory["multipleChoice"]![1], "Question 2");
      });

      test("saveChatMessage", () {
        final message = "Hello";
        gameController.saveChatMessage(message);

        expect(gameController.game.history.activityHistory.length, 1);
        expect(gameController.game.history.activityHistory[0].contains("name1"), true);
        expect(gameController.game.history.activityHistory[0].contains("Hello"), true);
      });

      test("saveEventMessage", () {
        final event = "Event message";
        gameController.saveEventMessage(event);

        expect(gameController.game.history.activityHistory.length, 1);
        expect(gameController.game.history.activityHistory[0].contains("Event message"), true); 
      });
    });

    test("endGame", () {
      gameController.endGame();
      expect(gameController.game.isActive, false);
      expect(gameController.activeUser.activeGameIds.contains(gameController.game.id), false);
    });
  });
}
