import 'package:territory_game/model/quiz_models/question_models/question.dart';

/// A data model for the coding problem question type.
class CodingProblem extends Question {
  final String inputExample;
  final String outputExample;

  const CodingProblem({
    required super.id,
    required super.question,
    required this.inputExample,
    required this.outputExample
  });
  
  /// Loads a CodingProblem object from a JSON file.
  factory CodingProblem.fromJson(Map<String, dynamic> json) {
    return CodingProblem(
      id: json["id"],
      question: json["question"],
      inputExample: json["inputExample"],
      outputExample: json["outputExample"]
    );  
  }

  /// Returns a JSON-friendly Map version of the question.
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "question": question,
      "inputExample": inputExample,
      "outputExample": outputExample
    };
  }

  /// Returns a string version of the question.
  @override
  String toString() {
    return "id: $id\nquestion: $question\ninputExample: $inputExample\noutputExample: $outputExample";
  }
}