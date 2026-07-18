import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sortedmap/sortedmap.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';
import 'package:territory_game/view/widgets/game_screen/UI/dialogs/feedback_dialog.dart';

enum QuizMode {creation, attack}

/// A dialog box for displaying quizzes.
/// 
/// It dynamically selects the correct layout based on the type of quiz that it is passed in its constructor.
class QuizDialog extends StatelessWidget {
  final Quiz quiz;
  QuizMode mode;

  QuizDialog({
    required this.quiz,
    this.mode = QuizMode.creation,
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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: selectLayout(quiz, mode)
      ),
    );
  }
}

/// Facilitates the selection of a quiz layout based on the type of quiz.
Widget selectLayout(Quiz quiz, QuizMode mode) {
  if (quiz.type == "multipleChoice") {
      return MultipleChoiceLayout(
        quiz: quiz,
        mode: mode
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
  final QuizMode mode;
  const MultipleChoiceLayout({
    required this.quiz,
    required this.mode,
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
    final gameController = context.watch<GameController>();
    final questions = List<MultipleChoiceQuestion>.from(widget.quiz.questions);
    final currentQuestion = questions[currentQuestionIndex];

    /// Adds a user answer to the userAnswers Map.
    void logUserAnswer(String answer) {
      userAnswers[currentQuestion.id] = answer;
      print(userAnswers);
    }

    return Column(
      children: [
        TitleText(text: "Question ${currentQuestion.id}"),
        SizedBox(height: 25),
        SubtitleText(text: currentQuestion.question),
          
        ...currentQuestion.getRandomizedAnswers().map((answer) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                logUserAnswer(answer);
              },
              child: Text(
                answer
              ),
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
              onPressed: () async {
                if (userAnswers.length == questions.length) {
                  widget.quiz.storeUserAnswers(userAnswers);
                  // widget.gameController
                  final quizFeedback = await gameController.getFeedback(widget.quiz);
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (newContext) => ChangeNotifierProvider.value(
                      value: context.read<GameController>(),
                      child: FeedbackDialog(
                        quiz: widget.quiz,
                        quizFeedback: quizFeedback,
                        mode: widget.mode
                      )
                    )
                  ); 
                } else {
                  setState(() {
                    currentQuestionIndex++;
                  });
                }
              }
            ),
          ],
        ),
      ],
    );
  }
}


