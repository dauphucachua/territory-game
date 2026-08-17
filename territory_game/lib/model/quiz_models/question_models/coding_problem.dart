import 'package:territory_game/model/quiz_models/question_models/question.dart';

/// A data model for the coding problem question type.
class CodingProblem extends Question {
  // An example of the expected input for the problem.
  final String inputExample; 
  // An example of the expected output for the problem.
  final String outputExample; 

  CodingProblem({
    required super.id,
    required super.question,
    required this.inputExample,
    required this.outputExample
  });
  
  /// Loads a CodingProblem object from a JSON file.
  factory CodingProblem.fromJson(Map<String, dynamic> json) {
    return CodingProblem(
      id: json["id"] ?? 0,
      question: json["question"] ?? "The model did not produce a question.",
      inputExample: json["inputExample"] ?? "Input example missing",
      outputExample: json["outputExample"] ?? "Output example missing"
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