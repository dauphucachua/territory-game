import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/topic.dart';

/// An interface class that sets the required functionality for individual chatbot APIs to be used in the application.
abstract interface class ChatbotApiService {
  const ChatbotApiService();

  /// Queries the chatbot with the desired quiz properties via its API and returns a quiz as a Map.
  Future<Map<String, dynamic>?> getQuizJson(
    Topic topic, 
    String subTopic, 
    String questionType,
    int questionCount
  );

  /// Sends the chatbot a completed quiz via its API and returns feedback as a Map.
  Future<Map<String, dynamic>?> getFeedbackJson(Quiz quiz);
}