import 'package:territory_game/model/topic.dart';

abstract interface class ChatbotApiService {
  const ChatbotApiService();

  Future<Map<String, dynamic>?> getQuizJson(
    Topic topic, 
    String subTopic, 
    String questionType,
    int questionCount
  );
  // Future<Map<String, dynamic>?> getTheoryJson(Topic topic);
  // Future<Map<String, dynamic>?> getCodingProblemJson(Topic topic);
  // Future<Map<String, dynamic>?> getCodingExerciseJson(Topic topic);
}