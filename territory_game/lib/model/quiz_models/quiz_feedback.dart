import 'package:territory_game/model/quiz_models/question_feedback.dart';

/// A data model for grouping QuestionFeedback objects that are part of the same quiz.
class QuizFeedback {
  final List<QuestionFeedback> results;

  const QuizFeedback({
    required this.results
  });

  /// Loads a QuizFeedback object from a JSON file.
  factory QuizFeedback.fromJson(Map<String, dynamic> json) {
    return QuizFeedback(
      results: List<QuestionFeedback>.from(
        json["results"].map((question) => QuestionFeedback.fromJson(question)))
    );
  }

  /// Gets the total score for all items of feedback in the quiz.
  int get totalScore {
    int scoreCounter = 0;
    for (QuestionFeedback feedback in results) {
      scoreCounter += feedback.score;
    } return scoreCounter;
  }



  
}