/// A data model for the per-question feedback provided by a chatbot.
class QuestionFeedback {
  final int id;
  final String feedback;
  final int score;

  const QuestionFeedback({
    required this.id,
    required this.feedback,
    required this.score
  });

  /// Loads a QuestionFeedback object from a JSON file.
  factory QuestionFeedback.fromJson(Map<String, dynamic> json) {
    return QuestionFeedback(
      id: json["id"],
      feedback: json["feedback"],
      score: json["score"]
    );
  }
}