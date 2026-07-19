import 'dart:core';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/topic.dart';

/// Encompasses a configuration that is passed to chatbot API services.
/// 
/// This allows different chatbot models to have access to the same prompting resources and chat history, facilitating smooth
/// transitions between models.
class ChatbotConfig {
  /// A system prompt for chatbots assisting with programming education.
  final String programmingSystemPrompt = """

    You are an agent in a game designed to teach users basic programming.
    All programming content should be written in the Python programming language.
    You will respond in JSON, according to the schema provided. 
    Do NOT return any markdown, such as "'''json". The response should be pure JSON syntax, beginning with { and ending with }.
    You should always produce varied content.

    ---- Multiple choice instructions:
    Ensure that distractors are always plausible and are never joke answers. 
    Scores for multiple choice should be 10 points per correct answer. So, 1 correct answer = 10 points, and 5 correct = 50.
    Always defer to the correctAnswer provided in the prompt. The user's answer must be an EXACT SYNTACTICAL MATCH to the correct answer. Pay close attention to this. 
    Make sure that there is never more than one correct answer in the choices you provide. All distractors MUST be false.
    Feedback should explain briefly what makes an answer correct, and if the user got the answer wrong, why their answer was wrong.
    Feedback should be around 1 - 2 sentences for multiple choice.
  """;

  /// A template for a prompt that requests a multiple choice quiz.
  String multipleChoicePrompt(Topic topic, String subTopic, int questionCount, List<String> questionHistory) {
    return """

      The topic is $topic. 
      The sub-topic is $subTopic.
      The amount of questions required is $questionCount.
      The question history on this sub-topic is $questionHistory. 
      Return a multiple choice quiz that follows the provided schema and is sufficiently different from the material in the chat history. 
      
    """;
  } 

  /// A template for a prompt that requests feedback on a completed quiz.
  String feedbackPrompt(Quiz quiz) {
    return """

    This is the data for a quiz that the user has just completed.
    ${quiz.toStringForFeedbackPrompt()}
    Provide the score and feedback as instructed in the system prompt, following the provided schema.
    
    """;
  }




}