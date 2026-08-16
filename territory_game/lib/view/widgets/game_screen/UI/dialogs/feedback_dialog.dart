import 'dart:ui';
import 'package:flutter/material.dart';
import "package:flutter_smooth_markdown/flutter_smooth_markdown.dart";
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/question_models/coding_problem.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_feedback.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';
import 'package:territory_game/view/widgets/game_screen/UI/dialogs/quiz_dialog.dart';

/// A dialog box showing the quiz feedback and scores provided by the chatbot model.
class FeedbackDialog extends StatelessWidget {
  final Quiz quiz;
  final QuizFeedback quizFeedback;
  final QuizMode mode;
  Property? propertyToStrengthen;

  FeedbackDialog({
    required this.quiz,
    required this.quizFeedback,
    required this.mode,  
    this.propertyToStrengthen,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();

    return Dialog(
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      backgroundColor: const Color.fromARGB(255, 33, 48, 68),
      insetPadding: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10.0
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: FeedbackLayout(
              mode: mode,
              quiz: quiz,
              quizFeedback: quizFeedback,   
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 84, 104, 138) 
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                switch (mode) {
                  .creation => "Exit and place property",
                  .attack => "Finish attack",
                  .strengthen => "Strengthen property"
                },
                style: TextStyle(
                  color: const Color.fromARGB(141, 255, 255, 255),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                )
              
              ),
            ),
            onPressed: () async {
              if (mode == .creation) {
                // Save the questions to a global question history
                gameController.saveToQuestionHistory(quiz.type, quiz.questions);
                // Load a new Property object with the ownerId, quiz data and score
                final newProperty = Property(
                  ownerId: gameController.activePlayer.id, 
                  quiz: quiz, 
                  health: quizFeedback.totalScore, 
                );
                // Add that property to the current player's propertyToPlace attribute;
                await gameController.setPropertyToPlace(newProperty);
                // Return to the GameScreen
                if (context.mounted) {
                  Navigator.pop(context);
                  quiz.userAnswers.clear(); 
                }
              } else if (mode == .attack) { 
                if (context.mounted) {
                  Navigator.pop(context);
                  await Future.delayed(Duration(seconds: 1));
                  quiz.userAnswers.clear();
                  await gameController.battle(quizFeedback.totalScore);
                }
              } else { // mode == .strengthen
                if (context.mounted) {
                  Navigator.pop(context);
                  await Future.delayed(Duration(seconds: 1));
                  quiz.userAnswers.clear();
                  await gameController.strengthenProperty(
                    propertyToStrengthen!, 
                    quiz, 
                    quizFeedback.totalScore
                  );
                }
              }
            }
          ),
        ],
      ),
    );
  }
}

// Widget selectLayout(Quiz quiz, QuizFeedback quizFeedback, QuizMode mode) {
//   if (quiz.type == "multipleChoice") {
//     return FeedbackLayout( 
//       quiz: quiz,
//       quizFeedback: quizFeedback,
//       mode: mode
//     );
//   } else if (quiz.type == "codingProblem") {
//     return CodingProblemFeedbackLayout(
//       quiz: quiz,
//       quizFeedback: quizFeedback,
//       mode: mode
//     );
//   }
  

//   throw "Quiz type not found / not recognised";
// }

class FeedbackLayout extends StatelessWidget {
  final Quiz quiz;
  final QuizFeedback quizFeedback;
  final QuizMode mode;

  const FeedbackLayout({
    required this.quiz,
    required this.quizFeedback,
    required this.mode,
    super.key
  });

  // Useful getters
  dynamic get questions { 
    if (quiz.type == "multipleChoice") {
      return List<MultipleChoiceQuestion>.from(quiz.questions);
    } else if (quiz.type == "codingProblem") {
      return List<CodingProblem>.from(quiz.questions);
    }
  }

  int get numQuestions => questions.length;
  List<String> get correctAnswers => List<String>.from(questions.map((question) => question.correctAnswer));
  int get numCorrectAnswers {
    int correctCounter = 0;

    for (int i = 0; i < questions.length; i++) {
      if (quiz.userAnswers[i] == correctAnswers[i]) {
        correctCounter += 1;
      } 
    }

    return correctCounter;
  }

  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    int? opponentScore;
    if (mode == .attack) {
      opponentScore = gameController.activePlayer.activeBattle!.defender!.health;
    }

    return Column(
      mainAxisAlignment: .start,
      crossAxisAlignment: .center,

      children: [
        SizedBox(height: 20),
        if (quiz.type == "multipleChoice")
          TitleText(
            text: "You got $numCorrectAnswers out of $numQuestions correct",
          ),
        SubtitleText(
          text: opponentScore != null
          ? "Your score: ${quizFeedback.totalScore} | Opponent's health: $opponentScore"
          : "Your score: ${quizFeedback.totalScore}"
        ),
        Divider(),
        Row(
          mainAxisAlignment: .spaceEvenly,
          children: [
            SubtitleText(
              text: "Questions"
            ),
            SizedBox(),
            SubtitleText(
              text: "Feedback"
            ),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 500, 
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: ListView.builder(
              itemCount: numQuestions,
              scrollDirection: .vertical,
              itemBuilder: (context, index) {
                final results = quizFeedback.results;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: quiz.type == "multipleChoice" 
                  ? FeedbackListItem(
                    quizType: quiz.type,
                    correctAnswerText: correctAnswers[index],
                    feedbackText: results[index].feedback,
                    questionScore: results[index].score,
                    questionText: questions[index].question,
                    userAnswerText: quiz.userAnswers[index],
                    distractors: questions[index].distractors
                  )
                  : FeedbackListItem(
                    quizType: quiz.type,
                    feedbackText: results[index].feedback,
                    questionScore: results[index].score,
                    questionText: questions[index].question,
                    userAnswerText: quiz.userAnswers[index],
                  ),
                );
              },
            ),
          ),
        ),
      ]
    );
  }
}

class FeedbackListItem extends StatelessWidget {
  final String quizType;
  final String questionText;
  final String userAnswerText;
  final String feedbackText;
  String? correctAnswerText;
  final int questionScore;
  List<String>? distractors;

  FeedbackListItem({
    required this.quizType,
    required this.questionText,
    required this.userAnswerText,
    required this.feedbackText,
    this.correctAnswerText,
    required this.questionScore,
    this.distractors,
    super.key
  });
  
  Color getFeedbackBoxColor() {
    if (quizType == "multipleChoice") {
      if (userAnswerText == correctAnswerText) {
        return AppColors.correctBoxGreen;
      } else {
        return AppColors.wrongBoxRed;
      }
    } else if (quizType == "codingProblem") {
      if (questionScore > 75) {
        return AppColors.correctBoxGreen;
      } else if (questionScore > 40) {
        return AppColors.midBoxYellow;
      } else {
        return AppColors.wrongBoxRed;
      }
    }

    throw ("Quiz type not recognized."); 
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceEvenly,
      children: [
        Container(
          width: 600,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 45, 65, 90),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: [
              ContentText(text: questionText),
              Divider(color: const Color.fromARGB(26, 193, 193, 193)),
              if (quizType == "multipleChoice" && distractors != null && correctAnswerText != null)
               ...[correctAnswerText, ...distractors!].map((item) => Text(
                item!,
                style: item == correctAnswerText 
                ? TextStyle(
                    color: Colors.green,
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                  )
                : TextStyle(
                    color: const Color.fromARGB(144, 255, 255, 255),
                    fontSize: 15
                  ), 
                ),
              )
              else if (quizType == "codingProblem")
              Column(
                children: [
                  Text(
                    "Your answer",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: AppColors.opaqueWhite
                    ),
                  ),
                  ContentText(text: userAnswerText)
                ],
              )
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward,
          color: const Color.fromARGB(136, 255, 255, 255)
        ),
        Container(
          width: 600,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: getFeedbackBoxColor(),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: [
              if (quizType == "multipleChoice")
                Text(
                  "You answered: '$userAnswerText'",
                  style: TextStyle(
                    color: const Color.fromARGB(144, 255, 255, 255),
                    fontSize: 18.0
                  ),
                ),
              SizedBox(height: 10),
              quizType == "codingProblem" 
              ? SingleChildScrollView(
                scrollDirection: .vertical,
                child: SmoothMarkdown(
                  data: feedbackText,
                  styleSheet: MarkdownStyleSheet.dark(
                    baseStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors.opaqueWhite
                    )
                  ),
                ),
              )
              : ContentText(text: feedbackText),
              SizedBox(height: 10),
              Text(
                "Score: $questionScore",
                style: TextStyle(
                  color: const Color.fromARGB(144, 255, 255, 255),
                  fontSize: 18.0
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

