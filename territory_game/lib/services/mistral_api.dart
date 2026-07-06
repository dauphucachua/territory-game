import 'dart:convert';
import 'package:mistralai_dart/mistralai_dart.dart';
import 'package:territory_game/api_keys/api_keys.dart';
import 'package:territory_game/services/chatbot_api.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_config.dart';

class MistralApiService implements ChatbotApiService {
  final client = MistralClient.withApiKey(mistralKey);
  final List<String> models = ["mistral-small-latest", "mistral-large-latest"];
  
  final Map<String, dynamic> schemas = {
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

  final ChatbotConfig config;

  MistralApiService({
    required this.config
  });
  
  @override
  Future<Map<String, dynamic>?> getQuizJson(
    Topic topic, 
    String subTopic, 
    String questionType,
    int questionCount
  ) async {

    final ChatCompletionResponse response = await client.chat.create(
      request: ChatCompletionRequest(
        model: models[0],
        messages: [
          ChatMessage.system(config.systemPrompt),
          if (questionType == "multipleChoice") 
            ChatMessage.user(config.multipleChoicePrompt(topic, subTopic, questionCount))
        ],
        responseFormat: schemas[questionType]
      ),
    );
    
    return jsonDecode(response.text!);
  }
  
 
}