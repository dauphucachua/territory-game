import 'package:territory_game/model/quiz_models/question_models/question.dart';

/// A data model for the multiple choice question type.
class MultipleChoiceQuestion extends Question {
  final String correctAnswer;
  final List<String> distractors;

  const MultipleChoiceQuestion({
    required super.id, 
    required super.question,
    required this.correctAnswer,
    required this.distractors, 
  }); 

  /// Returns all answers as a List with the correct answer at position 0.
  List<String> get allAnswers => [correctAnswer, ...distractors];

  /// Loads a MultipleChoiceQuestion object from a JSON structure.
  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceQuestion(
      id: json["id"],
      question: json["question"],
      correctAnswer: json["correct_answer"],
      distractors: List<String>.from(json["distractors"])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "question": question,
      "correctAnswer": correctAnswer,
      "distractors": distractors
    };
  }

  /// Returns the object as a reader-friendly string.
  @override
  String toString() {
    return "Question $id: $question\nCorrect answer: $correctAnswer\nDistractors: $distractors";
  }

  /// Returns all answers in random order for displaying in a quiz.
  List<String> getRandomizedAnswers() {
    final answers = allAnswers;
    answers.shuffle();
    return answers;
  }
}