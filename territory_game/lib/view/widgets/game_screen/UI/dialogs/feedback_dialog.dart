import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_feedback.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';

/// A dialog box showing the quiz feedback and scores provided by the chatbot model.
class FeedbackDialog extends StatelessWidget {
  final Quiz quiz;
  final QuizFeedback quizFeedback;

  const FeedbackDialog({
    required this.quiz,
    required this.quizFeedback,  
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
            child: selectLayout(gameController, quiz, quizFeedback),
          ),
           SizedBox(
          height: 20.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 84, 104, 138) 
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Exit and place property",
                style: TextStyle(
                  color: const Color.fromARGB(141, 255, 255, 255),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                )
              
              ),
            ),
            onPressed: () async {
              // Save the questions to a global question history
              gameController.saveToQuestionHistory(quiz.questions);
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
                
                // Clear the current user's answers from the quiz
                quiz.userAnswers.clear(); 
              }
            }
          ),
        ],
      ),
    );
  }
}

Widget selectLayout(GameController gameController, Quiz quiz, QuizFeedback quizFeedback) {
  if (quiz.type == "multipleChoice") {
    return MultipleChoiceFeedbackLayout( 
      quiz: quiz,
      quizFeedback: quizFeedback
    );
  } 

  throw "Quiz type not found / not recognised";
}

class MultipleChoiceFeedbackLayout extends StatelessWidget {
  final Quiz quiz;
  final QuizFeedback quizFeedback;

  const MultipleChoiceFeedbackLayout({
    required this.quiz,
    required this.quizFeedback,
    super.key
  });

  // Useful getters
  List<MultipleChoiceQuestion> get questions => List<MultipleChoiceQuestion>.from(quiz.questions);
  
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
    return Column(
      mainAxisAlignment: .start,
      crossAxisAlignment: .center,

      children: [
        SizedBox(height: 20),
        TitleText(
          text: "You got $numCorrectAnswers out of $numQuestions correct",
        ),
        SubtitleText(
          text: "Score: ${quizFeedback.totalScore}"),
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
          height: 400, 
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FeedbackListItem(
                    correctAnswerText: correctAnswers[index],
                    feedbackText: quizFeedback.results[index].feedback,
                    questionScore: quizFeedback.results[index].score.toString(),
                    questionText: questions[index].question,
                    userAnswerText: quiz.userAnswers[index],
                    distractors: questions[index].distractors
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
  final String questionText;
  final String userAnswerText;
  final String feedbackText;
  final String correctAnswerText;
  final String questionScore;
  final List<String> distractors;

  const FeedbackListItem({
    required this.questionText,
    required this.userAnswerText,
    required this.feedbackText,
    required this.correctAnswerText,
    required this.questionScore,
    required this.distractors,
    super.key
  });

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
              ...[correctAnswerText, ...distractors].map((item) => Text(
                item,
                style: item == correctAnswerText 
                ? TextStyle(
                  color: Colors.green,
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  )
                : TextStyle(
                  color: const Color.fromARGB(144, 255, 255, 255),
                  fontSize: 15
                  ) 
                )
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
            color: userAnswerText == correctAnswerText 
              ? AppColors.correctBoxGreen
              : AppColors.wrongBoxRed,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: [
              Text(
                "You answered: '$userAnswerText'",
                style: TextStyle(
                  color: const Color.fromARGB(144, 255, 255, 255),
                  fontSize: 18.0
                ),
              ),
              SizedBox(height: 10),
              ContentText(text: feedbackText),
              SizedBox(height: 10),
              Text(
                "Score: $questionScore",
                style: TextStyle(
                  color: const Color.fromARGB(144, 255, 255, 255),
                  fontSize: 18.0
                )
              )
            ],
          ),
        ),
      ],
    );
  }
}

