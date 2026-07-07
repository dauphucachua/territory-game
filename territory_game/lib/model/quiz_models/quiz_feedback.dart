import 'package:territory_game/model/quiz_models/question_feedback.dart';

class QuizFeedback {
  final List<QuestionFeedback> results;

  const QuizFeedback({
    required this.results
  });

  factory QuizFeedback.fromJson(Map<String, dynamic> json) {
    return QuizFeedback(
      results: List<QuestionFeedback>.from(
        json["results"].map((question) => QuestionFeedback.fromJson(question)))
    );
  }



  
}