import 'package:territory_game/model/quiz_models/question_models/question.dart';

class TheoryQuestion extends Question {
  const TheoryQuestion({
    required super.id,
    required super.question
  });

  factory TheoryQuestion.fromJson(Map<String, dynamic> json) {
    return TheoryQuestion(
      id: json["id"],
      question: json["question"]
    );
  }
}