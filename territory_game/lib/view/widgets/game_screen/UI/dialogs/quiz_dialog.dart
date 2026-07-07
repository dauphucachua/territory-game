import 'package:flutter/material.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/view/widgets/game_screen/UI/dialogs/custom_elements.dart';

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
  List<String> userAnswers = [];

  @override
  Widget build(BuildContext context) {
    final questions = widget.quiz.questions;
    final currentQuestion = questions[currentQuestionIndex];

    void addUserAnswer(String answer) {
      userAnswers.add(answer);
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
                addUserAnswer(answer);
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
                  widget.quiz.userAnswers = userAnswers;
                  // widget.gameController
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Column(
                          children: [
                            for (String answer in userAnswers)
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


