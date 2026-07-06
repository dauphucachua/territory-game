import 'dart:core';
import 'package:territory_game/model/topic.dart';

class ChatbotConfig {
  final String systemPrompt = """

    You are an agent in a game designed to teach users basic programming.
    All programming content should be written in the Python programming language.
    You will respond in JSON, according to the schema provided. 
    Do NOT return any markdown, such as "'''json". The response should be pure JSON syntax, beginning with { and ending with }.
    You should always produce varied content.

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




}