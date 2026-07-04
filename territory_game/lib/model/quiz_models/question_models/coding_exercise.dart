import 'package:territory_game/model/quiz_models/question.dart';

class CodingExercise extends Question {
  final List<String> steps;

  const CodingExercise({
    required super.id,
    required super.question,
    required this.steps
  });

  factory CodingExercise.fromJson(Map<String, dynamic> json) {
    return CodingExercise(
      id: json["id"],
      question: json["question"],
      steps: json["steps"]
    );
  }
}