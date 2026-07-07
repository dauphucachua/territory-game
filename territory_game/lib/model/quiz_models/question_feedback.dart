class QuestionFeedback {
  final int id;
  final String feedback;
  final int score;

  const QuestionFeedback({
    required this.id,
    required this.feedback,
    required this.score
  });

  factory QuestionFeedback.fromJson(Map<String, dynamic> json) {
    return QuestionFeedback(
      id: json["id"],
      feedback: json["feedback"],
      score: json["score"]
    );
  }
}