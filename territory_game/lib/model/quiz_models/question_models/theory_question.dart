import 'package:territory_game/model/quiz_models/question_models/question.dart';

/// A data model for the theory question type.
class TheoryQuestion extends Question {
  TheoryQuestion({
    // The question number.
    required super.id,
    // The question as a String.
    required super.question
  });

  /// Load a TheoryQuestion object from a JSON file.
  factory TheoryQuestion.fromJson(Map<String, dynamic> json) {
    return TheoryQuestion(
      id: json["id"],
      question: json["question"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "question": question
    };
  }
}