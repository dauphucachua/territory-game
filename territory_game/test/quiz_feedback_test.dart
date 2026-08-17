import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/quiz_models/question_feedback.dart';
import 'package:territory_game/model/quiz_models/quiz_feedback.dart';

void main() {
  final testJson = {
    "results": [
      {
        "id": 1,
        "feedback": "Feedback 1",
        "score": 100,
      },
      {
        "id": 2,
        "feedback": "Feedback 2",
        "score": 50,
      }
    ]
  };
  /// Tests that JSON deserialisation produces the expected result.
  test("fromJson", () {
    final quizFeedbackObj = QuizFeedback.fromJson(testJson);

    expect(quizFeedbackObj.results, isA<List<QuestionFeedback>>());
    expect(quizFeedbackObj.results.length, 2);
    expect(quizFeedbackObj.results[0].id, 1);
    expect(quizFeedbackObj.results[0].feedback, "Feedback 1");
    expect(quizFeedbackObj.results[0].score, 100);
    expect(quizFeedbackObj.results[1].id, 2);
    expect(quizFeedbackObj.results[1].feedback, "Feedback 2");
    expect(quizFeedbackObj.results[1].score, 50);
  });

  /// Tests that totalScore is calculated correctly.
  test("totalScore", () {
    final testQuizFeedback = QuizFeedback(
      results: [
        QuestionFeedback(id: 1, feedback: "", score: 100),
        QuestionFeedback(id: 2, feedback: "", score: 50),
      ]
    );

    expect(testQuizFeedback.totalScore, 150);
  });

}