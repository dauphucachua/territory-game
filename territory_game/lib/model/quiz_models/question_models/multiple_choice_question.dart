import 'package:territory_game/model/quiz_models/question.dart';

class MultipleChoiceQuestion extends Question {
  final String correctAnswer;
  final List<dynamic> distractors;

  const MultipleChoiceQuestion({
    required super.id, 
    required super.question,
    required this.correctAnswer,
    required this.distractors, 
  }); 

  List<dynamic> get allAnswers => [correctAnswer, ...distractors];

  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceQuestion(
      id: json["id"],
      question: json["question"],
      correctAnswer: json["correct_answer"],
      distractors: json["distractors"]
    );
  }

  @override
  String toString() {
    return """
      Question $id: $question\n
      Correct answer: $correctAnswer\n
      Distractors: $distractors
    """;
  }

  List<dynamic> getRandomizedAnswers() {
    final answers = allAnswers;
    answers.shuffle();
    return answers;
  }
}