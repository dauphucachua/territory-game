import 'dart:convert';
import 'package:mistralai_dart/mistralai_dart.dart';
import 'package:territory_game/api_keys/api_keys.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_service.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';

/// An API service for communicating with Mistral AI.
class MistralApiService implements ChatbotApiService {

  // The mistral client.
  final client = MistralClient.withApiKey(mistralKey);

  // A list of model strings for switching easily. This can be expanded, can also add functionality for dynamically switching
  // based on the need at hand. 
  final List<String> models = ["mistral-small-latest", "mistral-large-latest"];

  // A Map of schemas for use with various quiz types.
  final Map<String, dynamic> quizSchemas = {
    "multipleChoice": ResponseFormatJsonSchema(
      name: "multipleChoiceQuiz",
      schema: {
        "quizType": {
          "type": "String",
          "description": "This value must be: multipleChoice. It describes the quiz type."
        }, 
        "questions": {"type": "array"},
        "items": {
          "type": "object",
          "properties": {
            "id": {
              "type": "integer",
              "description": "The chronological number of the question in the set."
              },
            "question": {"type": "string"},
            "correct_answer": {"type": "string"},
            "distractors": {
              "type": "array",
              "items": {"type": "string"} 
            }         
          },
        }
      }
    ),
  };

  // A Map of feedback schemas, for use with various quiz types.
  final Map<String, dynamic> feedbackSchemas = {
    "multipleChoice": ResponseFormatJsonSchema(
      name: "multipleChoiceFeedback",
      schema: {
        "results": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
               "id": {
                  "type": "integer",
                  "description": "The chronological number of the question in the set",
                },
                "feedback": {"type": "string"},
                "score": {"type": "integer"},
            }
          }       
        }
      }
    )
  };

  // Configuration giving access to prompt templates and chat history.
  @override
  final ChatbotConfig config;

  MistralApiService({
    required this.config
  });
  
  /// Queries Mistral with the desired quiz properties via its API and returns a quiz as a Map.
  @override
  Future<Map<String, dynamic>?> getQuizJson(
    Topic topic, 
    String subTopic, 
    String questionType,
    int questionCount
  ) async {

    final ChatCompletionResponse response = await client.chat.create(
      request: ChatCompletionRequest(
        model: models[1],
        messages: [
          ChatMessage.system(config.programmingSystemPrompt),
          if (questionType == "multipleChoice") 
            ChatMessage.user(config.multipleChoicePrompt(topic, subTopic, questionCount))
        ],
        responseFormat: quizSchemas[questionType]
      ),
    );

    return jsonDecode(response.text!);
  }

  /// Sends Mistral a completed quiz via its API and returns feedback as a Map.
  @override
  Future<Map<String, dynamic>?> getFeedbackJson(Quiz quiz) async {
    final ChatCompletionResponse response = await client.chat.create(
      request: ChatCompletionRequest(
        model: models[1],
        messages: [
          ChatMessage.system(config.programmingSystemPrompt),
          ChatMessage.user(config.feedbackPrompt(quiz))
        ],
        responseFormat: feedbackSchemas[quiz.type]
      )
    );

    return jsonDecode(response.text!);
  }
  
 
}