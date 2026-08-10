import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/quiz_models/question_feedback.dart';
import 'package:territory_game/model/quiz_models/question_models/coding_problem.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_feedback.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';
import 'package:territory_game/services/chatbot_services/mistral_api_service.dart';

import 'dummy_gamecontroller.dart';

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