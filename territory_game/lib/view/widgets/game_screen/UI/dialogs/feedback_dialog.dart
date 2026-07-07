import 'package:flutter/material.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';

/// A dialog box showing the quiz feedback and scores provided by the chatbot model.
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
    // Column -
    //    Dynamic title: You got numCorrectAnswers / questions.length correct
    //    Dynamic subtitle: Score: feedback.score
    //    Divider()
    //    Questions and Feedback titles - Row [Text, Text]
    //    ListView - returns Row[QuestionAnswerItem, FeedbackItem] - vertical scrollable listview
    //    Exit and place property button - closes dialog, saves quiz questions to config.chatHistory, 
    //    saves quiz and feedback to user's quiz history
    //    begins placeProperty process
    //  
    return const Placeholder();
  }
}