import 'package:flutter/material.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/question_models/question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_feedback.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_service.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/firebase_services/firebase_auth_service.dart';
import 'package:territory_game/services/timer_service/timer_service.dart';

/// A controller class that manages interactions between the major classes of the game.
class GameController extends ChangeNotifier {
  final FirebaseAuthService firebaseAuth;
  final ChatbotApiProvider chatbotProvider;
  final TimerService timer;
  final Game game;
  late final Player activePlayer = game.players.where(
    (player) => player.id == firebaseAuth.activeUser!.id).first;
  
  GameController({
    required this.firebaseAuth,
    required this.chatbotProvider,
    required this.timer,
    required this.game
  });

  Subject get subject => game.subject;
  Topic get topic => game.topic;
  String get topicName => game.topic.name;
  List<String> get subTopics => game.topic.subTopics;
  ChatbotApiService get chatbot => chatbotProvider.chatbot;
  Board get board => game.board;
  List<List<dynamic>> get boardState => game.board.state;
  DateTime get endTime => game.endTime;

  

  void setPropertyToPlace(Property property) {
    activePlayer.propertyToPlace = property;
    notifyListeners();
  } 

  void removePropertyToPlace() {
    activePlayer.propertyToPlace = null;
  }

  void addToPlayerProperties(Property property) {
    activePlayer.properties.add(property);
  }

  /// Places a property at the coordinate indicated by the x and y parameters.
  void placeProperty(Property property, {required int x, required int y}) {
    boardState[x][y] = property;
    property.x = x;
    property.y = y;
    removePropertyToPlace();
    addToPlayerProperties(property);
    notifyListeners();
  }

  /// Facilitates an attack from one selected property to a target one.
  // void attack(Property attacker, Property target, int damage) {
  //   if (attacker.canAttack(target)) {
  //     target.takeDamage(damage);
  //   } else {
  //     print("You can't attack this property.");
  //   }
  // }

  /// Gets a Quiz object with the specified parameters from the active chatbot.
  Future<Quiz> getQuiz(String subTopic, String questionType, int questionCount) async {
    Map<String, dynamic>? quizJson = await chatbot.getQuizJson(game.topic, subTopic, questionType, questionCount);
    if (quizJson != null) {
      return Quiz.fromJson(quizJson);
    } else {
      throw "Failed to get quiz from chatbot";
    }
  }

  /// Gets a QuizFeedback object based on a completed quiz from the active chatbot.
  Future<QuizFeedback> getFeedback(Quiz quiz) async {
    Map<String, dynamic>? quizFeedbackJson = await chatbot.getFeedbackJson(quiz);
    print(quizFeedbackJson.toString());
    if (quizFeedbackJson != null) {
      return QuizFeedback.fromJson(quizFeedbackJson);
    } else {
      throw "Failed to get feedback from chatbot";
    }
  }

  void saveToQuestionHistory(List<Question> questions) {
    List<String> questionStrings = List<String>.from(questions.map((questionObj) => questionObj.question));
    chatbot.config.chatHistory.addAll(questionStrings);
  }
}
