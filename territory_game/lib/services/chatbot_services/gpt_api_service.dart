import 'package:territory_game/api_keys/api_keys.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_type.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_service.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class GptApiService implements ChatbotApiService {
  @override
  final ChatbotConfig config;
  final String apiKey = gptKey;

  GptApiService({required this.config});

  @override
  Future<Map<String, dynamic>?> getFeedbackJson(Quiz quiz) async {
    final prompt = config.feedbackPrompt(quiz);
    final schema = ChatbotSchemas.feedbackSchemas[quiz.type.name];
    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/responses"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-5",
        "instructions": config.programmingSystemPrompt,
        "input": prompt,
        "reasoning": {"effort": "low"},
        "text": {
          "format": {
            "type": "json_schema",
            "name": "feedback",
            "strict": false,
            "schema": {
              "type": "object",
              "properties": schema,
            },
          },
        },
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      final message = (data["output"] as List).firstWhere(
        (o) => o["type"] == "message",
      );
      return jsonDecode(message["content"][0]["text"]);
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
      Uri.parse("https://api.openai.com/v1/responses"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-5",
        "instructions": config.programmingSystemPrompt,
        "input": prompt,
        "reasoning": {"effort": "low"},
        "text": {
          "format": {
            "type": "json_schema",
            "name": "quiz",
            "strict": false,
            "schema": {
              "type": "object",
              "properties": schema,
            },
          },
        },
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      print(data);
      final message = (data["output"] as List).firstWhere(
        (o) => o["type"] == "message",
      );
      print(message);
      return jsonDecode(message["content"][0]["text"]);
    } else {
      throw StateError("${response.statusCode}: ${response.body}");
    }
  }
}
