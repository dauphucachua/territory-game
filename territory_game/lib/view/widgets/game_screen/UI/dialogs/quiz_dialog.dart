import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smooth_markdown/flutter_smooth_markdown.dart';
import 'package:flutter_smooth_markdown/widgets/smooth_markdown.dart';
import 'package:provider/provider.dart';
import 'package:sortedmap/sortedmap.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/question_models/coding_exercise.dart';
import 'package:territory_game/model/quiz_models/question_models/coding_problem.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_type.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';
import 'package:territory_game/view/widgets/game_screen/UI/dialogs/new_feedback_dialog.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/python.dart';

// An enum for reference by elements that change based on quiz mode.
enum QuizMode { creation, attack, strengthen }

/// A dialog box for displaying quizzes.
///
/// It dynamically selects the correct layout based on the type of quiz that it is passed in its constructor.
// ignore: must_be_immutable
class QuizDialog extends StatelessWidget {
  final Quiz quiz;
  QuizMode mode;
  Property? propertyToStrengthen;

  QuizDialog({
    required this.quiz,
    this.mode = QuizMode.creation,
    this.propertyToStrengthen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      backgroundColor: const Color.fromARGB(255, 33, 48, 68),
      insetPadding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.95,
          maxHeight: MediaQuery.of(context).size.height * 0.95,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              selectLayout(quiz, mode, propertyToStrengthen),
              Positioned(
                top: 0,
                right: 0,
                child: CloseButton(
                  color: AppColors.opaqueWhite,
                  onPressed: () async {
                    Navigator.pop(context);
                    if (mode == QuizMode.attack) {
                      try {
                        await gameController.cancelBattle();
                      } catch (e) {
                        debugPrint("Battle cancel failed: $e");
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Facilitates the selection of a quiz layout based on the type of quiz.
Widget selectLayout(Quiz quiz, QuizMode mode, Property? propertyToStrengthen) =>
    switch (quiz.type) {
      QuizType.multipleChoice => MultipleChoiceLayout(
        quiz: quiz,
        mode: mode,
        propertyToStrengthen: propertyToStrengthen,
      ),
      QuizType.codingProblem => CodingProblemLayout(
        quiz: quiz,
        mode: mode,
        propertyToStrengthen: propertyToStrengthen,
      ),
      QuizType.codingExercise => CodingExerciseLayout(
        quiz: quiz,
        mode: mode,
        propertyToStrengthen: propertyToStrengthen,
      ),
      _ => throw ArgumentError("Quiz type not implemented yet."),
    };

/// A layout for multiple choice quizzes.
class MultipleChoiceLayout extends StatefulWidget {
  final Quiz quiz;
  final QuizMode mode;
  // A propertyToStrengthen is present when quizMode is .strengthen.
  // It is passed into the feedback dialog so strengthening can be triggered there.
  Property? propertyToStrengthen;

  MultipleChoiceLayout({
    required this.quiz,
    required this.mode,
    this.propertyToStrengthen,
    super.key,
  });

  @override
  State<MultipleChoiceLayout> createState() => _MultipleChoiceLayoutState();
}

class _MultipleChoiceLayoutState extends State<MultipleChoiceLayout> {
  int currentQuestionIndex = 0;
  // Stores the answers selected by the user and automatically sorts them by key (question ID).
  SortedMap<int, String> userAnswers = SortedMap(Ordering.byKey());
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    final questions = List<MultipleChoiceQuestion>.from(widget.quiz.questions);
    final currentQuestion = questions[currentQuestionIndex];
    final randomizedAnswers = currentQuestion.allAnswersRandomized;

    /// Adds a user answer to the userAnswers Map.
    void logUserAnswer(String answer) {
      setState(() {
        userAnswers[currentQuestion.id] = answer;
      });
    }

    return Column(
      children: [
        TitleText(text: "Multiple-choice | ${widget.quiz.subTopic}"),
        TitleText(text: "Question ${currentQuestion.id}/${questions.length}"),
        SizedBox(height: 12.0),
        Divider(color: AppColors.opaqueWhite),
        SizedBox(height: 12.0),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                    ),
                    child: SmoothMarkdown(
                      data: currentQuestion.question,
                      styleSheet: MarkdownStyles.markdownStyle,
                      config: MarkdownStyles.markdownConfig,
                      builderRegistry: MarkdownStyles.markdownBuilders,
                      useEnhancedComponents: true,
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                // The multiple choice options in clickable containers
                LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;
                    final crossAxisCount = screenWidth > 800 ? 2 : 1;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisExtent: 225,
                      ),
                      itemCount: randomizedAnswers.length,
                      itemBuilder: (context, index) {
                        final option = randomizedAnswers[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => logUserAnswer(option),
                            child: Container(
                              padding: .all(20.0),
                              decoration: BoxDecoration(
                                color: userAnswers[currentQuestion.id] == option
                                    ? AppColors.selectedBlue
                                    : AppColors.blue,
                                borderRadius: AppDimensions.cornerRadius,
                              ),
                              child: Center(
                                child: SingleChildScrollView(
                                  child: SmoothMarkdown(
                                    data: option,
                                    styleSheet: MarkdownStyles.markdownStyle,
                                    config: MarkdownStyles.markdownConfig,
                                    builderRegistry:
                                        MarkdownStyles.markdownBuilders,
                                    useEnhancedComponents: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 40),
        // The next and previous question buttons
        Row(
          mainAxisAlignment: .center,
          spacing: 50,
          children: [
            if (currentQuestionIndex > 0)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  padding: .all(24.0),
                ),
                child: Text(
                  "Previous question",
                  style: TextStyle(fontSize: 18, color: AppColors.opaqueWhite),
                ),
                onPressed: () => setState(() => currentQuestionIndex--),
              ),
            _isLoading
                ? LoaderWithText(text: "Getting feedback from chatbot... ")
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      padding: .all(24.0),
                    ),
                    child: Text(
                      currentQuestion.id < questions.length
                          ? "Next question"
                          : "Finish quiz",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.opaqueWhite,
                      ),
                    ),
                    onPressed: () async {
                      if (userAnswers.length == questions.length) {
                        widget.quiz.storeUserAnswers(userAnswers);
                        // widget.gameController
                        setState(() => _isLoading = true);
                        final quizFeedback = await gameController.getFeedback(
                          widget.quiz,
                        );

                        setState(() => _isLoading = false);
                        if (context.mounted) {
                          Navigator.pop(context);
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (newContext) =>
                                ChangeNotifierProvider.value(
                                  value: gameController,
                                  child: FeedbackDialog(
                                    feedbackFixture: (
                                      feedback: quizFeedback,
                                      quiz: widget.quiz,
                                    ),
                                    mode: widget.mode,
                                    propertyToStrengthen:
                                        widget.propertyToStrengthen,
                                  ),
                                ),
                          );
                        }
                      } else {
                        setState(() {
                          if (currentQuestionIndex < questions.length - 1) {
                            currentQuestionIndex++;
                          }
                        });
                      }
                    },
                  ),
          ],
        ),
      ],
    );
  }
}

/// A layout for coding questions.
class CodingProblemLayout extends StatefulWidget {
  final Quiz quiz;
  final QuizMode mode;
  // A propertyToStrengthen is present when quizMode is .strengthen.
  // It is passed into the feedback dialog so strengthening can be triggered there.
  Property? propertyToStrengthen;

  CodingProblemLayout({
    required this.quiz,
    required this.mode,
    this.propertyToStrengthen,
    super.key,
  });

  @override
  State<CodingProblemLayout> createState() => _CodingProblemLayoutState();
}

class _CodingProblemLayoutState extends State<CodingProblemLayout> {
  int currentQuestionIndex = 0;
  // Stores the answers selected by the user and automatically sorts them by key (question ID).
  SortedMap<int, String> userAnswers = SortedMap(Ordering.byKey());
  bool _isLoading = false;
  // Configures the settings for the code text field widget.
  final codeController = CodeController(
    text: "# Write your code here",
    language: python,
    params: EditorParams(tabSpaces: 4),
  );

  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    final questions = List<CodingProblem>.from(widget.quiz.questions);
    final currentQuestion = questions[currentQuestionIndex];
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1200;

    /// Adds a user answer to the userAnswers Map.
    void logUserAnswer(String answer) {
      userAnswers[currentQuestion.id] = answer;
    }

    final questionColumn = SingleChildScrollView(
      child: Column(
        spacing: 8.0,
        children: [
          SubtitleText(text: "Question"),
          ScrollableTextCard(
            width: isWideScreen ? 500 : 300,
            height: 225,
            text: currentQuestion.question,
          ),
          SizedBox(height: 8.0),
          SubtitleText(text: "Input example"),
          ScrollableTextCard(
            width: isWideScreen ? 500 : 300,
            text: currentQuestion.inputExample,
          ),
          SizedBox(height: 8.0),
          SubtitleText(text: "Output example"),
          ScrollableTextCard(
            width: isWideScreen ? 500 : 300,
            text: currentQuestion.outputExample,
          ),
        ],
      ),
    );

    final codeColumn = Column(
      children: [
        SubtitleText(text: "Your solution"),
        SizedBox(height: 8.0),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 550,
            maxHeight: 600,
            maxWidth: isWideScreen ? 700 : 500,
          ),
          child: Container(
            padding: .symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: AppDimensions.cornerRadius,
              border: BoxBorder.all(color: AppColors.opaqueWhite),
              color: const Color.fromARGB(255, 20, 30, 42),
            ),
            child: CodeTheme(
              data: CodeThemeData(styles: monokaiSublimeTheme),
              child: SingleChildScrollView(
                scrollDirection: .vertical,
                child: CodeField(
                  controller: codeController,
                  background: const Color.fromARGB(255, 20, 30, 42),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 32.0),
        _isLoading == true
            ? LoaderWithText(text: "Getting feedback from chatbot...")
            : ElevatedButton(
                style: ElevatedButton.styleFrom(padding: .all(18.0)),
                onPressed: () async {
                  logUserAnswer(codeController.text);
                  if (userAnswers.length == questions.length) {
                    widget.quiz.storeUserAnswers(userAnswers);
                    setState(() => _isLoading = true);
                    final quizFeedback = await gameController.getFeedback(
                      widget.quiz,
                    );
                    setState(() => _isLoading = false);
                    if (context.mounted) {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (newContext) => ChangeNotifierProvider.value(
                          value: gameController,
                          child: FeedbackDialog(
                            feedbackFixture: (
                              feedback: quizFeedback,
                              quiz: widget.quiz,
                            ),
                            mode: widget.mode,
                            propertyToStrengthen: widget.propertyToStrengthen,
                          ),
                        ),
                      );
                    }
                  } else {
                    codeController.clear();
                    setState(() {
                      currentQuestionIndex++;
                    });
                  }
                },
                child: Text(
                  "Submit for review",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
      ],
    );

    return Column(
      children: [
        TitleText(text: "Coding problem | ${widget.quiz.subTopic}"),
        SizedBox(height: 25),
        if (isWideScreen)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(child: questionColumn),
                SizedBox(width: 18.0),
                VerticalDivider(color: AppColors.dividerWhite),
                SizedBox(width: 18.0),
                Flexible(child: SingleChildScrollView(child: codeColumn)),
              ],
            ),
          )
        else
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [questionColumn, Divider(), codeColumn]),
            ),
          ),
      ],
    );
  }
}

class CodingExerciseLayout extends StatefulWidget {
  final Quiz quiz;
  final QuizMode mode;
  // A propertyToStrengthen is present when quizMode is .strengthen.
  // It is passed into the feedback dialog so strengthening can be triggered there.
  Property? propertyToStrengthen;

  CodingExerciseLayout({
    required this.quiz,
    required this.mode,
    this.propertyToStrengthen,
    super.key,
  });

  @override
  State<CodingExerciseLayout> createState() => _CodingExerciseLayoutState();
}

class _CodingExerciseLayoutState extends State<CodingExerciseLayout> {
  int currentQuestionIndex = 0;
  // Stores the answers selected by the user and automatically sorts them by key (question ID).
  SortedMap<int, String> userAnswers = SortedMap(Ordering.byKey());
  bool _isLoading = false;
  // Configures the settings for the code text field widget.
  final codeController = CodeController(
    text: "# Write your code here",
    language: python,
    params: EditorParams(tabSpaces: 4),
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1200;
    final gameController = context.watch<GameController>();
    final questions = List<CodingExercise>.from(widget.quiz.questions);
    final currentQuestion = questions[currentQuestionIndex];

    /// Adds a user answer to the userAnswers Map.
    void logUserAnswer(String answer) {
      userAnswers[currentQuestion.id] = answer;
    }

    final cardWidth = isWideScreen ? 500.0 : 300.0;

    final stepsColumn = SingleChildScrollView(
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: cardWidth),
            child: Column(
              children: [
                SubtitleText(text: "Task summary"),
                SizedBox(height: 8.0),
                ScrollableTextCard(
                  width: cardWidth,
                  height: 225,
                  text: currentQuestion.question,
                  markdown: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          for (int i = 0; i < currentQuestion.steps.length; i++)
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: cardWidth),
              child: Column(
                spacing: 8.0,
                children: [
                  SubtitleText(text: "Step ${i + 1}"),
                  ScrollableTextCard(
                    width: cardWidth,
                    height: 150,
                    text: currentQuestion.steps[i],
                    markdown: true,
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
        ],
      ),
    );

    final codeColumn = Column(
      children: [
        SubtitleText(text: "Your solution"),
        SizedBox(height: 8.0),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 550,
            maxHeight: 600,
            maxWidth: isWideScreen ? 700 : 500,
          ),
          child: Container(
            padding: .symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: AppDimensions.cornerRadius,
              border: BoxBorder.all(color: AppColors.opaqueWhite),
              color: const Color.fromARGB(255, 20, 30, 42),
            ),
            child: CodeTheme(
              data: CodeThemeData(styles: monokaiSublimeTheme),
              child: SingleChildScrollView(
                scrollDirection: .vertical,
                child: CodeField(
                  controller: codeController,
                  background: const Color.fromARGB(255, 20, 30, 42),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 32.0),
        _isLoading == true
            ? LoaderWithText(text: "Getting feedback from chatbot...")
            : ElevatedButton(
                style: ElevatedButton.styleFrom(padding: .all(18.0)),
                onPressed: () async {
                  logUserAnswer(codeController.text);
                  if (userAnswers.length == questions.length) {
                    widget.quiz.storeUserAnswers(userAnswers);
                    // widget.gameController
                    setState(() => _isLoading = true);
                    final quizFeedback = await gameController.getFeedback(
                      widget.quiz,
                    );
                    setState(() => _isLoading = false);
                    if (context.mounted) {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (newContext) => ChangeNotifierProvider.value(
                          value: gameController,
                          child: FeedbackDialog(
                            feedbackFixture: (
                              feedback: quizFeedback,
                              quiz: widget.quiz,
                            ),
                            mode: widget.mode,
                            propertyToStrengthen: widget.propertyToStrengthen,
                          ),
                        ),
                      );
                    }
                  } else {
                    codeController.clear();
                    setState(() {
                      currentQuestionIndex++;
                    });
                  }
                },
                child: Text(
                  "Submit for review",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
      ],
    );

    return Column(
      children: [
        TitleText(text: "Coding exercise"),
        SizedBox(height: 25),
        if (isWideScreen)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(child: stepsColumn),
                SizedBox(width: 18.0),
                VerticalDivider(color: AppColors.dividerWhite),
                SizedBox(width: 18.0),
                Flexible(child: SingleChildScrollView(child: codeColumn)),
              ],
            ),
          )
        else
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [stepsColumn, Divider(), codeColumn]),
            ),
          ),
      ],
    );
  }
}

/// A custom scrollable text card to account for situations where the chatbot produces longer content.
class ScrollableTextCard extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final bool markdown;

  ScrollableTextCard({
    this.width,
    this.height,
    required this.text,
    this.markdown = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final finalWidth = width ?? (screenWidth > 1200 ? 500 : 300).toDouble();
    final constrainedWidth = finalWidth.clamp(0.0, screenWidth * 0.8);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: constrainedWidth,
        maxHeight: height ?? 300,
      ),
      child: Container(
        width: constrainedWidth,
        padding: .all(24.0),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: AppDimensions.cornerRadius,
        ),
        child: SingleChildScrollView(
          scrollDirection: .vertical,
          child: markdown
              ? SmoothMarkdown(
                  data: text,
                  styleSheet: MarkdownStyles.markdownStyle,
                  config: MarkdownStyles.markdownConfig,
                  builderRegistry: MarkdownStyles.markdownBuilders,
                  useEnhancedComponents: true,
                )
              : ContentText(text: text),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: QuizDialog(
            quiz: dummyCodingProblemQuiz,
            mode: QuizMode.creation,
          ),
        ),
      ),
    ),
  );
}

final dummyCodingProblemQuiz = Quiz(
  type: QuizType.codingProblem,
  subTopic: "String manipulation",
  difficulty: "easy",
  questions: [
    CodingProblem(
      id: 1,
      question:
          "Write a function called count_words that takes a string and "
          "returns a dictionary containing the number of times each word appears. "
          "Ignore capitalization and treat words as sequences separated by spaces. "
          "If the input is empty, return an empty dictionary.",
      inputExample: 'count_words("Cat dog cat bird DOG")',
      outputExample: '{"cat": 2, "dog": 2, "bird": 1}',
    ),
  ],
);

final dummyCodingExerciseQuiz = Quiz(
  type: QuizType.codingExercise,
  subTopic: "String manipulation",
  difficulty: "easy",
  questions: [
    CodingExercise(
      id: 1,
      question: "Write a function to reverse a string and count vowels in it.",
      steps: [
        "Define a function named reverse_and_count that accepts one string parameter. "
            "The function should work with empty strings as well as strings containing spaces and punctuation.",
        "Create a variable for the reversed string. Use slicing or a loop to put the characters in reverse order, "
            "while keeping their original capitalization and punctuation.",
        "Count the vowels in the reversed string. Include both uppercase and lowercase A, E, I, O, and U, "
            "but do not count spaces, digits, or punctuation. The count should be zero if there are no vowels.",
        "Return both the reversed string and its vowel count as a tuple. "
            "For example, the input 'Hello!' should produce ('!olleH', 2).",
        "Test the function with an empty string, a string with no vowels, and a mixture of uppercase and lowercase letters. "
            "Print each result so that you can check both the reversed text and the count.",
      ],
    ),
    CodingExercise(
      id: 2,
      question: "Create a function to check if a string is a palindrome.",
      steps: [
        "Define a function named is_palindrome that accepts one string parameter. "
            "It should determine whether the text reads the same forwards and backwards.",
        "Create a normalized version of the input by removing spaces and converting the remaining characters to lowercase. "
            "Keep the original input unchanged so that it can still be displayed later.",
        "Compare the normalized string with its reverse. Consider how the comparison behaves for an empty string "
            "and for a string containing only one character.",
        "Return True when the normalized string is the same forwards and backwards, and False otherwise. "
            "For example, 'Never odd or even' should return True, while 'Python' should return False.",
        "Test the function with at least two different inputs, including one with mixed capitalization and spaces. "
            "Print the original input alongside each result.",
      ],
    ),
  ],
);
