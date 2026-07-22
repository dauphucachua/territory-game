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
    Do NOT return any markdown such as "'''json", unless required . The response should be pure JSON syntax, beginning with { and ending with }.
    You should always produce varied content.
    Requests will be made for content with varying difficulty levels. 
    Bear in mind that this application is designed for students at a first-year university level.
    Therefore, the difficulty of 'hard' questions should still be fairly low.

    ---- Coding problem instructions:
    'Easy' questions should be based around fundamentals and allow user to practice and study with simple processes.
    'Medium' questions should include some more complex concepts but still be fundamentally simplistic.
    'Hard' questions should be complex in both content and process, but should not go past what a first-year university student should know.
    Questions should never be too long - always be concise with the instructions. A maximum of 6 - 7 sentences is appropriate.
     Coding problems should be written in the style of the exercises found on websites like Leetcode, Codewars, Hackerrank, etc.

    ---- Multiple choice instructions:
    Ensure that distractors are always plausible and are never joke answers. 
    Scores for multiple choice should be 20 points per correct answer. So, 1 correct answer = 20 points, and 5 correct = 100.
    Always defer to the correctAnswer provided in the prompt. The user's answer must be an EXACT SYNTACTICAL MATCH to the correct answer. Pay close attention to this. 
    Make sure that there is never more than one correct answer in the choices you provide. All distractors MUST be false.
    Feedback should explain briefly what makes an answer correct, and if the user got the answer wrong, why their answer was wrong.
    Feedback should be around 1 - 2 sentences for multiple choice.
      
    """;
    

  /// A template for a prompt that requests a multiple choice quiz.
  String multipleChoicePrompt(Topic topic, String subTopic, int questionCount, List<String> questionHistory, String difficulty) {
    return """

      The topic is ${topic.name}. 
      The sub-topic is $subTopic.
      The number of questions required is $questionCount.
      The requested difficulty is $difficulty.
      The question history on this sub-topic is $questionHistory. 
      Return a multiple choice quiz that follows the provided schema and is sufficiently different from the material in the chat history. 
    
    """;
  }

  /// A template for a prompt that requests a coding problem.
  String codingProblemPrompt(Topic topic, String subTopic, List<String> questionHistory, String difficulty) {
    return """
    
    The topic is ${topic.name}. 
    The sub-topic is $subTopic.
    The question history on this sub-topic is $questionHistory. 
    The requested difficulty is $difficulty.
    Return a coding problem that follows the provided schema and is sufficiently different from the material in the chat history.

    """;
  } 

  /// A template for a prompt that requests feedback on a completed quiz.
  String feedbackPrompt(Quiz quiz) {
    return """

    This is the data for a ${quiz.type} quiz that the user has just completed.
    ${quiz.toStringForFeedbackPrompt()}
    Provide the score and feedback, following the provided schema.


    Your feedback should provide a score out of 100 for the user's submission. 
    Prioritize good code practices in your marking, which means considering:
    Proper syntax
    Indentation
    Space complexity
    Time complexity
    Unnecessary repetition
    Readability
    Style conventions
    and more...

    For coding problems, solutions should rarely get 100 points, but if one is really perfect, full marks can be awarded. 
    Make sure you award marks for getting parts of the solution right even if the code doesn't run properly. You should award marks like an examiner would.
    In the explanation, you should always justify why the grade you gave was chosen, and what could have been done differently to achieve a higher grade.
    Feedback should be specific and detailed for coding problems. Try to educate the user on their mistakes as much as possible, with context and conventions.
    ALWAYS INCLUDE AN EXAMPLE SOLUTION IN CODE.
    
    
    """;
  }




}