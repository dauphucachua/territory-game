import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_feedback.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/model/user.dart';
import 'package:territory_game/services/chatbot_api.dart';
import 'package:territory_game/services/chatbot_api_provider.dart';

class GameController {
  final ChatbotApiProvider chatbotProvider;
  final Board board;
  final Subject subject;
  final Topic topic;
  
  const GameController({
    required this.chatbotProvider,
    required this.board, 
    required this.subject,
    required this.topic
  });

  String get topicName => topic.name;
  List<String> get subTopics => topic.subTopics;
  ChatbotApiService get chatbot => chatbotProvider.chatbot;

  void placeProperty(int x, int y, User owner, int health) {
    board.board[x][y] = Property(
      owner: owner, 
      health: health, 
      x: x, 
      y: y
    );
  }

  void attack(Property attacker, Property target, int damage) {
    if (attacker.isAttackable(target)) {
      target.takeDamage(damage);
    } else {
      print("You can't attack this property.");
    }
  }

  Future<Quiz> getQuiz(String subTopic, String questionType, int questionCount) async {
    Map<String, dynamic>? quizJson = await chatbot.getQuizJson(topic, subTopic, questionType, questionCount);
    if (quizJson != null) {
      return Quiz.fromJson(quizJson);
    } else {
      throw "Failed to get quiz from chatbot";
    }
  }

  Future<QuizFeedback> getFeedback(Quiz quiz) async {
    Map<String, dynamic>? quizFeedbackJson = await chatbot.getFeedbackJson(quiz);
    if (quizFeedbackJson != null) {
      return QuizFeedback.fromJson(quizFeedbackJson);
    } else {
      throw "Failed to get feedback for chatbot";
    }
  }
}
