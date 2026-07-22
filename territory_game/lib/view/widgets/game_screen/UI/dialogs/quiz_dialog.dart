import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sortedmap/sortedmap.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/quiz_models/question_models/coding_problem.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';
import 'package:territory_game/view/widgets/game_screen/UI/dialogs/feedback_dialog.dart';
import "package:flutter_highlight/themes/monokai-sublime.dart";
import 'package:highlight/languages/python.dart';

enum QuizMode {creation, attack}

/// A dialog box for displaying quizzes.
/// 
/// It dynamically selects the correct layout based on the type of quiz that it is passed in its constructor.
// ignore: must_be_immutable
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
        padding: const EdgeInsets.all(40.0),
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
    } else if (quiz.type == "codingProblem" || quiz.type == "codingExercise") {
      return CodingQuizLayout(
        quiz: quiz,
        mode: mode
      );
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
            child: GestureDetector(
              onTap: () => logUserAnswer(answer),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.blue
                ),
                child: ContentText(text: answer),
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

class CodingQuizLayout extends StatefulWidget {
  final Quiz quiz;
  final QuizMode mode;

  const CodingQuizLayout({
    required this.quiz,
    required this.mode,
    super.key,

  });

  @override
  State<CodingQuizLayout> createState() => _CodingQuizLayoutState();
}

class _CodingQuizLayoutState extends State<CodingQuizLayout> {
  int currentQuestionIndex = 0;
  // Stores the answers selected by the user and automatically sorts them by key (question ID).
  SortedMap<int, String> userAnswers = SortedMap(Ordering.byKey());
  // Configures the setting for the code text field widget.
  final codeController = CodeController(
    text: "# Write your code here",
    language: python,
    params: EditorParams(
      tabSpaces: 4, 
    ),
  );


  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    final questions = List<CodingProblem>.from(widget.quiz.questions);
    final currentQuestion = questions[currentQuestionIndex];

    /// Adds a user answer to the userAnswers Map.
    void logUserAnswer(String answer) {
      userAnswers[currentQuestion.id] = answer;
      print(userAnswers);
    }

    return Column(
      children: [
        TitleText(text: "Coding problem"),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: .spaceBetween,
          crossAxisAlignment: .start,
          children: [
            // Question, input example, output example
            Column(
              children: [
                SubtitleText(text: "Question"),
                ScrollableTextCard(
                  width: 500,
                  height: 225,
                  text: currentQuestion.question
                ),
                SizedBox(height: 8.0),
                SubtitleText(text: "Input example"),
                ScrollableTextCard(
                  width: 500,
                  text: currentQuestion.inputExample
                ),
                SizedBox(height: 8.0),
                SubtitleText(text: "Output example"),
                ScrollableTextCard(
                  width: 500,
                  text: currentQuestion.outputExample
                ),
              ],
            ),
            SizedBox(width: 12.0),
            Divider(),
            SizedBox(width: 12.0),
            // Entry box
            Column(
              children: [
                SubtitleText(text: "Your solution"),
                Container(
                  padding: .symmetric(horizontal: 8.0, vertical: 8.0),
                  height: 450,
                  width: 700,
                  decoration: BoxDecoration(
                    borderRadius: AppDimensions.cornerRadius,
                    border: BoxBorder.all(
                      color: AppColors.opaqueWhite
                    ),
                    color: const Color.fromARGB(255, 20, 30, 42)
                  ),
                  child: CodeTheme(
                    data: CodeThemeData(styles: monokaiSublimeTheme),
                    child: SingleChildScrollView(
                      scrollDirection: .vertical,
                      child: CodeField(
                        controller: codeController,
                        background: const Color.fromARGB(255, 20, 30, 42)           
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: .all(18.0)
                  ),
                  onPressed: () async {
                    logUserAnswer(codeController.text);
                    if (userAnswers.length == questions.length) {
                      widget.quiz.storeUserAnswers(userAnswers);
                      // widget.gameController
                      final quizFeedback = await gameController.getFeedback(widget.quiz);
                      if (context.mounted) {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (newContext) => ChangeNotifierProvider.value(
                            value: context.read<GameController>(),
                            child: FeedbackDialog(
                              quiz: widget.quiz,
                              quizFeedback: quizFeedback,
                              mode: widget.mode
                            ),
                          ),
                        ); 
                      }
                    } else {
                      setState(() {
                        currentQuestionIndex++;
                      }); 
                    }
                  },
                  child: Text(
                    "Submit for review",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ScrollableTextCard extends StatelessWidget {
  final double width;
  double? height;
  final String text;

  ScrollableTextCard({
    this.width = 500,
    this.height,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(24.0),
      width: width,
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: AppDimensions.cornerRadius,
      ),
      child: SingleChildScrollView(
        scrollDirection: .vertical,
        child: ContentText(
          text: text
        )
      )
    );
  }
}





