import 'package:territory_game/model/quiz_models/question_models/coding_exercise.dart';
import 'package:territory_game/model/quiz_models/question_models/coding_problem.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';
import 'package:territory_game/model/quiz_models/question_models/question.dart';
import 'package:territory_game/model/quiz_models/question_models/theory_question.dart';
import 'package:territory_game/model/quiz_models/quiz_type.dart';

/// A data model for quizzes created by a chatbot model.
class Quiz {
  final QuizType type;
  final String subTopic;
  final String difficulty;
  final List<Question> questions;
  // A List for temporary storage of user answers, defaults as empty List.
  List<String> userAnswers;

  Quiz({
    required this.type,
    required this.subTopic,
    required this.questions,
    required this.difficulty,
    List<String>? userAnswers,
  }) : userAnswers = userAnswers ?? [];

  /// Loads a Quiz object from a JSON file.
  factory Quiz.fromJson(Map<String, dynamic> json) {
    // A function to help select the right fromJson() constructor for each type of question.
    List<Question> typeSelector(String type) => switch (type) {
      "multipleChoice" =>
        List<MultipleChoiceQuestion>.from(json["questions"]
            .map((question) => MultipleChoiceQuestion.fromJson(question))),
      "codingProblem" =>
        List<CodingProblem>.from(json["questions"]
            .map((question) => CodingProblem.fromJson(question))),
      "codingExercise" =>
        List<CodingExercise>.from(json["questions"]
            .map((question) => CodingExercise.fromJson(question))),
      "theory" =>
        List<TheoryQuestion>.from(json["questions"]
            .map((question) => TheoryQuestion.fromJson(question))),
      _ => throw FormatException("Unknown quiz type: $type"),
    };

    return Quiz(
      type: QuizType.fromString(json["quizType"]),
      subTopic: json["subTopic"],
      difficulty: json["difficulty"],
      questions: typeSelector(json["quizType"]),
    );
  }

  /// Return a JSON-friendly Map version of a Quiz.
  Map<String, dynamic> toJson() {
    return {
      "quizType": type.name,
      "subTopic": subTopic,
      "difficulty": difficulty,
      "questions": List<Map<String, dynamic>>.from(
        questions.map((question) {
          switch (type) {
            case .multipleChoice:
              question = question as MultipleChoiceQuestion;
              return question.toJson();
            case .codingProblem:
              question = question as CodingProblem;
              return question.toJson();
            case .codingExercise:
              question = question as CodingExercise;
              return question.toJson();
            case .theory:
              question = question as TheoryQuestion;
              return question.toJson();
          }
        }),
      ),
    };
  }

  /// Adds the question set from another quiz to the current one.
  ///
  /// This is designed to be used when a player strengthens one of their properties or when a bonus question needs to added to a quiz.
  void addQuestionsFromQuiz(Quiz newQuiz) {
    if (subTopic == newQuiz.subTopic && type == newQuiz.type) {
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
        body += "User's answer: ${userAnswers[i]}\n\n";
      }

      return header + body;
    }

    throw StateError("Number of questions != number of answers");
  }

  /// Returns a String display of the quiz for debugging.
  @override
  toString() {
    return """
      Quiz type: $type
      Sub-topic: $subTopic
      Difficulty: $difficulty
      Questions: $questions
    """;
  }

  /// Adds a user's answers to the userAnswers list.
  void storeUserAnswers(Map<int, String> userAnswerMap) {
    userAnswers.addAll(userAnswerMap.values);
  }
}
