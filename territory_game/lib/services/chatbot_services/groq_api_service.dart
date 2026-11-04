import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:territory_game/api_keys/api_keys.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_type.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_service.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';

class GroqApiService implements ChatbotApiService {
  final String apiKey = groqKey;

  @override
  final ChatbotConfig config;
  GroqApiService({required this.config});

  @override
  Future<Map<String, dynamic>?> getFeedbackJson(Quiz quiz) async {
    final prompt = config.feedbackPrompt(quiz);
    final schema = ChatbotSchemas.feedbackSchemas[quiz.type.name];
    final response = await http.post(
      Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "openai/gpt-oss-120b",
        "messages": [
          {"role": "system", "content": config.programmingSystemPrompt},
          {"role": "user", "content": prompt},
        ],
        "response_format": {
          "type": "json_schema",
          "json_schema": {
            "name": "feedback",
            "description":
                "Provides the data for quiz feedback in the application.",
            "schema": {"type": "object", "properties": schema},
            "strict": false,
          },
        },
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      final jsonContent = data["choices"][0]["message"]["content"] as String;
      return jsonDecode(jsonContent);
    } else {
      throw StateError("${response.statusCode}: ${response.body}");
    }
  }

  @override
  Future<Map<String, dynamic>?> getQuizJson(
    Topic topic,
    String subTopic,
    QuizType quizType,
    int questionCount,
    List<String> questionHistory,
    String difficulty,
  ) async {
    final prompt = config.quizPrompt(
      quizType,
      topic,
      subTopic,
      questionCount,
      questionHistory,
      difficulty,
    );

    final schema = ChatbotSchemas.quizSchemas[quizType.name];

    final response = await http.post(
      Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "openai/gpt-oss-120b",
        "messages": [
          {"role": "system", "content": config.programmingSystemPrompt},
          {"role": "user", "content": prompt},
        ],
        "response_format": {
          "type": "json_schema",
          "json_schema": {
            "name": "quiz",
            "description": "Provides the data for a quiz in the application.",
            "schema": {"type": "object", "properties": schema},
            "strict": false,
          },
        },
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      print(data);
      final jsonContent = data["choices"][0]["message"]["content"] as String;
      print(jsonContent);
      return jsonDecode(jsonContent);
    } else {
      throw StateError("${response.statusCode}: ${response.body}");
    }
  }
}
