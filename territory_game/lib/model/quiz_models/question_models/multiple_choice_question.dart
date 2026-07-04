import 'package:territory_game/model/quiz_models/question.dart';

class MultipleChoiceQuestion extends Question {
  final String correctAnswer;
  final List<String> distractors;

  const MultipleChoiceQuestion({
    required super.id, 
    required super.question,
    required this.correctAnswer,
    required this.distractors, 
  }); 

  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceQuestion(
      id: json["id"],
      question: json["question"],
      correctAnswer: json["correct_answer"],
      distractors: json["distractors"]
    );
  }

  List<String> getRandomizedAnswers() {
    final answers = distractors;
    answers.add(correctAnswer);
    answers.shuffle();
    return answers;
  }
}