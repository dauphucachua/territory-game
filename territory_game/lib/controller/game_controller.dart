import 'package:flutter/material.dart';
import 'package:territory_game/model/board.dart';
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

/// A controller class that manages interactions between the major classes of the game.
class GameController extends ChangeNotifier {
  final Player player;
  final ChatbotApiProvider chatbotProvider;
  final Board board;
  final Subject subject;
  final Topic topic;
  
  GameController({
    required this.player,
    required this.chatbotProvider,
    required this.board, 
    required this.subject,
    required this.topic
  });

  String get topicName => topic.name;
  List<String> get subTopics => topic.subTopics;
  ChatbotApiService get chatbot => chatbotProvider.chatbot;
  List<List<dynamic>> get boardState => board.state;

  void setPropertyToPlace(Property property) {
    player.propertyToPlace = property;
    notifyListeners();
  }

  void removePropertyToPlace() {
    player.propertyToPlace = null;
  }

  void addToPlayerProperties(Property property) {
    player.properties.add(property);
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
    Map<String, dynamic>? quizJson = await chatbot.getQuizJson(topic, subTopic, questionType, questionCount);
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
      throw "Failed to get feedback for chatbot";
    }
  }

  void saveToQuestionHistory(List<Question> questions) {
    List<String> questionStrings = List<String>.from(questions.map((questionObj) => questionObj.question));
    chatbot.config.chatHistory.addAll(questionStrings);
  }
}
