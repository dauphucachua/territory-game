import 'package:territory_game/model/quiz_models/question_models/question.dart';

/// A data model for the coding exercise question type.
class CodingExercise extends Question {
  // A series of steps for the user to carry out, as Strings.
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
      steps: List<String>.from(json["steps"])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "question": question,
      "steps": steps
    };
  }

  @override
  String toString() {
    return "id:$id\nquestion:$question\nsteps:$steps";
  }
}