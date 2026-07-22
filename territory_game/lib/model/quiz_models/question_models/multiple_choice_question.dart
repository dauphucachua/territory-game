import 'package:territory_game/model/quiz_models/question_models/question.dart';

/// A data model for the multiple choice question type.
class MultipleChoiceQuestion extends Question {
  // The correct answer to the question.
  final String correctAnswer;
  // The wrong answers to the question.
  final List<String> distractors;
  // A randomized list of the multiple choice options - initialized late to allow fixed-order storage for consistency with setState()
  late final List<String> allAnswersRandomized = getRandomizedAnswers();

  MultipleChoiceQuestion({
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
      id: json["id"] as int,
      question: json["question"] as String,
      correctAnswer: json["correctAnswer"] as String,
      distractors: List<String>.from(json["distractors"].map((distractor) => distractor as String))
    );
  }

  /// Returns a JSON-friendly Map representation of the question.
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