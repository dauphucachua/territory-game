import 'package:flutter/material.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';

class QuizDialog extends StatelessWidget {
  final Quiz quiz;

  const QuizDialog({
    required this.quiz,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: selectLayout(quiz)
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
  final userAnswers = [];

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
        Text("Question $currentQuestion"),
        SizedBox(height: 25),
        Text(currentQuestion.question),
          
        ...currentQuestion.getRandomizedAnswers().map((answer) {
          return ElevatedButton(
            onPressed: () {
              addUserAnswer(answer);
            },
            child: Text(
              answer
            )
          );
        }),

        ElevatedButton(
          child: Text("Next question"),
          onPressed: () {
            if (userAnswers.length == questions.length) {
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
              setState(() {currentQuestionIndex++;});
            } 
          }
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


