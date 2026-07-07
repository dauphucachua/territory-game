import 'dart:core';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/topic.dart';

class ChatbotConfig {
  final String programmingSystemPrompt = """

    You are an agent in a game designed to teach users basic programming.
    All programming content should be written in the Python programming language.
    You will respond in JSON, according to the schema provided. 
    Do NOT return any markdown, such as "'''json". The response should be pure JSON syntax, beginning with { and ending with }.
    You should always produce varied content.

    ---- Multiple choice instructions:
    Ensure that distractors are always plausible and are never joke answers. 
    Scores for multiple choice should be the number of questions answered correctly, multiplied by 10.
    Feedback should explain briefly what makes an answer correct, and if the user got the answer wrong, why their answer was wrong.
    Feedback should be around 1 - 2 sentences for multiple choice.
  """;

  final List<String> chatHistory = [];

  String multipleChoicePrompt(Topic topic, String subTopic, int questionCount) {
    return """

      The topic is $topic. 
      The sub-topic is $subTopic.
      The amount of questions required is $questionCount.
      The chat history on this sub-topic is $chatHistory. 
      Return a multiple choice quiz that follows the provided schema and is sufficiently different from the material in the chat history. 
      
    """;
  } 

  String feedbackPrompt(Quiz quiz) {
    return """

    This is the data for a quiz that the user has just completed.
    ${quiz.toStringForFeedbackPrompt()}
    Provide the score and feedback as instructed in the system prompt, following the provided schema.
    
    """;
  }




}