import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_service.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';

class DummyChatbotApi implements ChatbotApiService {
  @override
  ChatbotConfig get config => ChatbotConfig();

  @override
  Future<Map<String, dynamic>?> getFeedbackJson(Quiz quiz) async {
    return {
      "results": [
        for (int n = 0; n < quiz.questions.length; n++)
          {"id": n + 1, "score": 100, "feedback": "Very good!"},
      ],
    };
  }

  @override
  Future<Map<String, dynamic>?> getQuizJson(
    Topic topic,
    String subTopic,
    String quizType,
    int questionCount,
    List<String> questionHistory,
    String difficulty,
  ) async {
    return {
      "quizType": quizType,
      "subTopic": subTopic,
      "difficulty": difficulty,
      "questions": [
        if (quizType == "multipleChoice")
          for (int n = 0; n < questionCount; n++)
            {
              "id": n + 1,
              "question": "Test MC question ${n + 1}",
              "correctAnswer": "Correct answer $n",
              "distractors": ["Distractor 1", "Distractor 2", "Distractor 3"],
            }
        else if (quizType == "codingProblem")
          for (int n = 0; n < questionCount; n++)
            {
              "id": n + 1,
              "question": "Test CP question ${n + 1}",
              "inputExample": "Input example $n",
              "outputExample": "Output example $n",
            },
      ],
    };
  }
}
