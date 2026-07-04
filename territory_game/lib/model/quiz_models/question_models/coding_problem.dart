import 'package:territory_game/model/quiz_models/question.dart';

class CodingProblem extends Question {
  final String inputExample;
  final String outputExample;

  const CodingProblem({
    required super.id,
    required super.question,
    required this.inputExample,
    required this.outputExample
  });

  factory CodingProblem.fromJson(Map<String, dynamic> json) {
    return CodingProblem(
      id: json["id"],
      question: json["question"],
      inputExample: json["inputExample"],
      outputExample: json["outputExample"]
    );  
  }
}