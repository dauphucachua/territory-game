import 'package:territory_game/model/quiz_models/question_models/coding_problem.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';
import 'package:territory_game/model/quiz_models/question_models/question.dart';

/// A data model for quizzes created by a chatbot model.
class Quiz {
  final String type;
  final String subTopic;
  final String difficulty;
  final List<Question> questions; // This should be List<Question>, having type issues, need to return to this
  List<String> userAnswers;
  
  Quiz({
    required this.type,
    required this.subTopic,
    required this.questions,
    required this.difficulty,
    List<String>? userAnswers
  }) : userAnswers = userAnswers ?? [];
  
  /// Loads a Quiz object from a JSON file.
  factory Quiz.fromJson(Map<String, dynamic> json) {
    // A function to help select the right fromJson() constructor for each type of question.
    List<Question> typeSelector(String type) {
      if (type == "multipleChoice") {
        return List<MultipleChoiceQuestion>.from(
          json["questions"].map((question) => MultipleChoiceQuestion.fromJson(question))
        );
      } else if (type == "codingProblem") {
        return List<CodingProblem>.from(
          json["questions"].map((question) => CodingProblem.fromJson(question))
        );
      } else {
        throw "Question type not recognized.";
      }
    }

    return Quiz(
      type: json["quizType"],
      subTopic: json["subTopic"],
      difficulty: json["difficulty"],
      questions: typeSelector(json["quizType"])
    );
  }
  
  /// Return a JSON-friendly Map version of a Quiz.
  Map<String, dynamic> toJson() {
    return {
      "quizType": type,
      "subTopic": subTopic,
      "difficulty": difficulty,
      "questions": questions.map((question) {
        switch (type) {
          case "multipleChoice": 
            question = question as MultipleChoiceQuestion;
            return question.toJson();
          case "codingProblem":
            question = question as CodingProblem;
            return question.toJson();
        }
      })
    };
  }

  /// Adds the question set from another quiz to the current one.
  /// 
  /// This is designed to be used when a player strengthens one of their properties.
  void addQuestionsFromQuiz(Quiz newQuiz) {
    if (
      subTopic == newQuiz.subTopic
      && type == newQuiz.type
      && difficulty == newQuiz.difficulty
    ) {
      final lastQuestionId = questions.last.id;
      for (Question question in newQuiz.questions) {
        question.id += lastQuestionId;
      }
      
      questions.addAll(newQuiz.questions);
    } else {
      throw "Quizzes do not share enough attributes to be merged.";
    }
    
  }


  /// Returns a formatted string that allows a completed quiz to be submitted clearly to a chatbot.
  String toStringForFeedbackPrompt() {
    if (userAnswers.length == questions.length) {
      final String header = "Quiz type: $type\nQuestions:\n\n";
      String body = "";
      for (int i = 0; i < questions.length; i++) {
        body += "${questions[i].toString()}\n";
        body += "${userAnswers[i]}\n\n";
      }

      return header + body;
    }

    throw "Number of questions != number of answers";
  }

  @override toString() {
    return """
      Quiz type: $type
      Difficulty: $difficulty
      Questions: $questions
    """;
  }

  /// Adds a user's answers to the userAnswers list.
  void storeUserAnswers(Map<int, String> userAnswerMap) {
    userAnswers.addAll(userAnswerMap.values);
  }


}


