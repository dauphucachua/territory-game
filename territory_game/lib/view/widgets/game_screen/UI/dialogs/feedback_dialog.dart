import 'package:flutter/material.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';

class FeedbackDialog extends StatelessWidget {
  final GameController gameController;
  final Quiz quiz;

  const FeedbackDialog(
    this.gameController, {
    required this.quiz,  
    super.key
  });

  @override
  Widget build(BuildContext context) {
    // Quiz.type will dictate layout again
    // Dynamic title: You got numCorrectAnswers / questions.length correct
    // Dynamic subtitle: Score: feedback.score
    // Row, divider, column
    // 
    return const Placeholder();
  }
}