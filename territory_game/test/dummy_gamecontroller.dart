import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_feedback.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_service.dart';

class DummyGameController {
  final ChatbotApiProvider chatbotProvider;
  final Game game;

  
  const DummyGameController({
    required this.chatbotProvider,
    required this.game
  });

  String get topicName => game.topic.name;
  List<String> get subTopics => game.topic.subTopics;
  ChatbotApiService get chatbot => chatbotProvider.chatbot;


    /// Gets a Quiz object with the specified parameters from the active chatbot.
  Future<Quiz> getQuiz(String subTopic, String questionType, int questionCount) async {
    final questionHistory = game.history.questionHistory[questionType]!;

    Map<String, dynamic>? quizJson = await chatbot.getQuizJson(
      game.topic, 
      subTopic, 
      questionType, 
      questionCount,
      questionHistory
    );

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
}