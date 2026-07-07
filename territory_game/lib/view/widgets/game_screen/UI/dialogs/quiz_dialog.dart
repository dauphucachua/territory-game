import 'package:flutter/material.dart';
import 'package:sortedmap/sortedmap.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/view/widgets/game_screen/UI/dialogs/custom_elements.dart';

/// A dialog box for displaying quizzes.
/// 
/// It dynamically selects the correct layout based on the type of quiz that it is passed in its constructor.
class QuizDialog extends StatelessWidget {
  final GameController gameController;
  final Quiz quiz;

  const QuizDialog(
    this.gameController, {
    required this.quiz,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      backgroundColor: const Color.fromARGB(255, 33, 48, 68),
      insetPadding: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10.0
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: selectLayout(quiz)
      ),
    );
  }
}

/// Facilitates the selection of a quiz layout based on the type of quiz.
Widget selectLayout(Quiz quiz) {
  if (quiz.type == "multipleChoice") {
      return MultipleChoiceLayout(
        quiz: quiz,
      );
    // } else if (quiz.type == "theory") {
    //   return TheoryLayout(
    //     quiz: quiz
    //   );
    // } else if (quiz.type == "codingProblem" || quiz.type == "codingExercise") {
    //   return CodingQuizLayout(
    //     quiz: quiz
    //   );
    } else {
      print("Quiz type not recognised.");
    }
    return const Placeholder();
}

/// A layout for multiple choice quizzes.
class MultipleChoiceLayout extends StatefulWidget {
  final Quiz quiz;
  const MultipleChoiceLayout({
    required this.quiz,
    super.key
  });

  @override
  State<MultipleChoiceLayout> createState() => _MultipleChoiceLayoutState();
}

class _MultipleChoiceLayoutState extends State<MultipleChoiceLayout> {
  int currentQuestionIndex = 0;
  // Stores the answers selected by the user and automatically sorts them by key (question ID).
  SortedMap<int, String> userAnswers = SortedMap(Ordering.byKey());
  
  @override
  Widget build(BuildContext context) {
    final questions = List<MultipleChoiceQuestion>.from(widget.quiz.questions);
    final currentQuestion = questions[currentQuestionIndex];

    /// Adds a user answer to the userAnswers Map.
    void logUserAnswer(String answer) {
      userAnswers[currentQuestion.id] = answer;
      print(userAnswers);
    }

    return Column(
      children: [
        DialogTitleText(text: "Question ${currentQuestion.id}"),
        SizedBox(height: 25),
        DialogSubtitleText(text: currentQuestion.question),
          
        ...currentQuestion.getRandomizedAnswers().map((answer) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                logUserAnswer(answer);
              },
              child: Text(
                answer
              )
            ),
          );
        }),

        Row(
          mainAxisAlignment: .center,
          spacing: 50,
          children: [
            if (currentQuestionIndex > 0)
              ElevatedButton(
                child: Text("Previous question"),
                onPressed: () => setState(() {
                  currentQuestionIndex--; 
                })
              ),
            ElevatedButton(
              child: Text(
                currentQuestion.id < questions.length ? "Next question" : "Finish quiz"
              ),
              onPressed: () {
                if (userAnswers.length == questions.length) {
                  widget.quiz.storeUserAnswers(userAnswers);
                  // widget.gameController
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Column(
                          children: [
                            for (String answer in userAnswers.values)
                              Text(answer)
                          ]
                        )
                      );
                    }); 
                } else {
                  setState(() {
                    currentQuestionIndex++;
                  });
                } 
              }
            )
          ],
        )
      ]
    );
  }
}

// class ChoiceButton extends StatelessWidget {
//   final String text;
//   final void Function() onPressed;

//   const ChoiceButton({
//     required this.text,
//     required this.onPressed,
//     super.key
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () => onPressed,
//       style: ElevatedButton.styleFrom(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 40.0,
//           vertical: 10.0
//         ),
//         backgroundColor: Colors.blue
//       ),
//       child: Text(
//         text,
//         textAlign: .center
//       ),
//     );
//   }
// }


