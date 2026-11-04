import 'dart:convert';

import 'package:mistralai_dart/mistralai_dart.dart';
import 'package:territory_game/api_keys/api_keys.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_type.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_service.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';

/// An API service for communicating with Mistral AI.
class MistralApiService implements ChatbotApiService {
  // The mistral client.
  final client = MistralClient.withApiKey(
    mistralKey,
    // Note: this directs to a Firebase cloud function that was written by Gemini to solve a CORS issue with web deployment.
    // This was suggested by the supervisor of this project as it was a game-breaking external problem that was delaying
    // user-testing.
    baseUrl: "https://us-central1-territory-game-final.cloudfunctions.net/mistralProxy",
  );

  // A list of model strings for switching easily. This can be expanded, can also add functionality for dynamically switching
  // based on the need at hand.
  final List<String> models = [
    "mistral-small-latest",
    "mistral-medium-latest",
    "mistral-large-latest",
  ];

  // A Map of schemas for use with various quiz types.
  final Map<QuizType, dynamic> quizSchemas = {
    QuizType.multipleChoice: ResponseFormatJsonSchema(
      name: "multipleChoice",
      schema: ChatbotSchemas.quizSchemas["multipleChoice"],
    ),
    QuizType.codingProblem: ResponseFormatJsonSchema(
      name: "codingProblem",
      schema: ChatbotSchemas.quizSchemas["codingProblem"],
    ),
    QuizType.codingExercise: ResponseFormatJsonSchema(
      name: "codingExercise",
      schema: ChatbotSchemas.quizSchemas["codingExercise"]
    ),
    QuizType.theory: ResponseFormatJsonSchema(
      name: "theory",
      schema: ChatbotSchemas.quizSchemas["theory"]
    )
  };

  // A Map of feedback schemas, for use with various quiz types.
  final Map<QuizType, dynamic> feedbackSchemas = {
    QuizType.multipleChoice: ResponseFormatJsonSchema(
      name: "multipleChoiceFeedback",
      schema: ChatbotSchemas.feedbackSchemas["multipleChoice"],
    ),
    QuizType.codingProblem: ResponseFormatJsonSchema(
      name: "codingProblemFeedback",
      schema: ChatbotSchemas.feedbackSchemas["codingProblem"],
    ),
     QuizType.codingExercise: ResponseFormatJsonSchema(
      name: "codingExercise",
      schema: ChatbotSchemas.feedbackSchemas["codingExercise"]
    ),
    QuizType.theory: ResponseFormatJsonSchema(
      name: "theory",
      schema: ChatbotSchemas.feedbackSchemas["theory"]
    ),
  };

  // Configuration giving access to prompt templates and chat history.
  @override
  final ChatbotConfig config;

  MistralApiService({required this.config});

  /// Queries Mistral with the desired quiz properties via its API and returns a quiz as a Map.
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
    final ChatCompletionResponse response = await client.chat.create(
      request: ChatCompletionRequest(
        model: models[1],
        messages: [
          ChatMessage.system(config.programmingSystemPrompt),
          ChatMessage.user(prompt),
        ],
        reasoningEffort: .medium,
        responseFormat: quizSchemas[quizType],
      ),
    );

    // A series of conversions to access the content.parts and part.text properties, which are only available in inherited
    // offshoots of the MessageContent and TextContent classes.
    final content =
        response.choices.first.message!.content! as MessagePartsContent;
    final part = content.parts[1] as TextContentPart;
    final responseText = part.text;

    return jsonDecode(responseText);
  }

  /// Sends Mistral a completed quiz via its API and returns feedback as a Map.
  @override
  Future<Map<String, dynamic>?> getFeedbackJson(Quiz quiz) async {
    final prompt = config.feedbackPrompt(quiz);
    final ChatCompletionResponse response = await client.chat.create(
      request: ChatCompletionRequest(
        model: models[1],
        messages: [
          ChatMessage.system(config.programmingSystemPrompt),
          ChatMessage.user(prompt),
        ],
        reasoningEffort: .medium,
        responseFormat: feedbackSchemas[quiz.type],
      ),
    );

    // A series of conversions to access the content.parts and part.text properties, which are only available in inherited
    // offshoots of the MessageContent and TextContent classes.
    final content =
        response.choices.first.message!.content! as MessagePartsContent;
    final part = content.parts[1] as TextContentPart;
    final responseText = part.text;

    return jsonDecode(responseText);
  }
}
