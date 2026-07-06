import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';

class Quiz {

  final String type;
  final List<dynamic> questions;
  List<String> userAnswers;

  Quiz({
    required this.type,
    required this.questions,
    List<String>? userAnswers
  }) : userAnswers = userAnswers ?? [];

  factory Quiz.fromJson(Map<String, dynamic> json) {
    if (json["quizType"] == "multipleChoice") {
      return Quiz(
      type: json["quizType"],
      questions: (
        json["questions"].map((question) => MultipleChoiceQuestion.fromJson(question))).toList());
    } else {
      throw "Quiz type not recognised";
    }
  }

  @override toString() {
    return """
      Quiz type: $type\n
      Questions: $questions
    """;
  }

  void storeUserAnswer(String answer) {
    userAnswers.add(answer);
  }
}

