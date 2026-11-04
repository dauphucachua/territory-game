/// A data model for the per-question feedback provided by a chatbot.
class QuestionFeedback {
  // The question number that the feedback relates to.
  final int id;
  // The written feedback as a String.
  final String? feedback;
  // The score for the question.
  final int score;
  final String? summary;
  final String? correctness;
  final String? approach;
  final String? edgeCases;
  final String? efficiency;
  final String? codeQuality;
  final String? improvements;
  final String? codeExample;
  final List<StepFeedback>? stepFeedback;

  const QuestionFeedback({
    required this.id,
    this.feedback,
    required this.score,
    this.summary,
    this.correctness,
    this.approach,
    this.edgeCases,
    this.efficiency,
    this.codeQuality,
    this.improvements,
    this.codeExample,
    this.stepFeedback
  });

  /// Loads a QuestionFeedback object from a JSON file.
  ///
  /// "feedback" is a plain String for multiple-choice and theory quizzes,
  /// and an object of categorised feedback for coding quizzes.
  factory QuestionFeedback.fromJson(Map<String, dynamic> json) {
    final rawFeedback = json["feedback"];

    if (rawFeedback is Map<String, dynamic>) {
      final rawSteps = rawFeedback["stepFeedback"];
      return QuestionFeedback(
        id: json["id"],
        score: json["score"],
        summary: rawFeedback["summary"],
        correctness: rawFeedback["correctness"],
        approach: rawFeedback["approach"],
        edgeCases: rawFeedback["edgeCases"],
        efficiency: rawFeedback["efficiency"],
        codeQuality: rawFeedback["codeQuality"],
        improvements: rawFeedback["improvements"],
        codeExample: json["codeExample"],
        stepFeedback: rawSteps is List
            ? rawSteps
                  .map((step) => StepFeedback.fromJson(step))
                  .toList()
            : null,
      );
    }

    return QuestionFeedback(
      id: json["id"],
      feedback: rawFeedback as String?,
      score: json["score"],
      codeExample: json["codeExample"],
    );
  }
}

class StepFeedback {
  final int id;
  final bool completed;
  final String feedback;
  final String codeExample;

  const StepFeedback({
    required this.id,
    required this.completed,
    required this.feedback,
    required this.codeExample
  });

  /// Loads a StepFeedback object from JSON. The schema names the id "stepId".
  factory StepFeedback.fromJson(Map<String, dynamic> json) {
    return StepFeedback(
      id: json["stepId"],
      completed: json["completed"],
      feedback: json["feedback"],
      codeExample: json["codeExample"]
    );
  }
}