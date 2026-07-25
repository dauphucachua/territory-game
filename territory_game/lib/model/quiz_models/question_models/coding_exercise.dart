import 'package:territory_game/model/quiz_models/question_models/question.dart';

/// A data model for the coding exercise question type.
class CodingExercise extends Question {
  final List<String> steps;

  CodingExercise({
    required super.id,
    required super.question,
    required this.steps
  });

  /// Loads a CodingExercise object from a JSON file.
  factory CodingExercise.fromJson(Map<String, dynamic> json) {
    return CodingExercise(
      id: json["id"],
      question: json["question"],
      steps: json["steps"]
    );
  }
}