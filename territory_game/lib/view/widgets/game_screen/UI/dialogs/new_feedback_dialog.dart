import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_smooth_markdown/flutter_smooth_markdown_editor_experimental.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/question_feedback.dart';
import 'package:territory_game/model/quiz_models/question_models/coding_exercise.dart';
import 'package:territory_game/model/quiz_models/question_models/coding_problem.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';
import 'package:territory_game/model/quiz_models/question_models/theory_question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_feedback.dart';
import 'package:territory_game/model/quiz_models/quiz_type.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';
import 'package:territory_game/view/widgets/game_screen/UI/dialogs/quiz_dialog.dart';

typedef FeedbackFixture = ({Quiz quiz, QuizFeedback feedback});

final FeedbackFixture dummyMultipleChoice = (
  quiz: Quiz(
    type: QuizType.multipleChoice,
    subTopic: "Lists",
    difficulty: "easy",
    questions: [
      MultipleChoiceQuestion(
        id: 1,
        question: "Which method adds an item to the end of a list?",
        correctAnswer: "append()",
        distractors: ["add()", "push()", "insert_end()"],
      ),
      MultipleChoiceQuestion(
        id: 2,
        question: "What does len([1, 2, 3]) return?",
        correctAnswer: "3",
        distractors: ["2", "4", "Error"],
      ),
      MultipleChoiceQuestion(
        id: 3,
        question: "Which index refers to the last item in a list?",
        correctAnswer: "-1",
        distractors: ["0", "len(list)", "last"],
      ),
    ],
    userAnswers: ["append()", "4", "-1"],
  ),
  feedback: QuizFeedback(
    results: [
      QuestionFeedback(
        id: 1,
        score: 10,
        feedback: "Correct! append() adds a single item to the end of a list.",
      ),
      QuestionFeedback(
        id: 2,
        score: 0,
        feedback: "Not quite. len() counts the items in the list, and this list has three.",
      ),
      QuestionFeedback(
        id: 3,
        score: 10,
        feedback: "Correct! Negative indexes count backwards from the end.",
      ),
    ],
  ),
);

final FeedbackFixture dummyTheory = (
  quiz: Quiz(
    type: QuizType.theory,
    subTopic: "Recursion",
    difficulty: "medium",
    questions: [
      TheoryQuestion(
        id: 1,
        question: "Explain what a base case is and why recursion needs one.",
      ),
      TheoryQuestion(
        id: 2,
        question: "When might iteration be preferable to recursion?",
      ),
    ],
    userAnswers: [
      "A base case is where the function stops calling itself, otherwise it would loop forever.",
      "Not sure.",
    ],
  ),
  feedback: QuizFeedback(
    results: [
      QuestionFeedback(
        id: 1,
        score: 85,
        feedback:
            "Good answer. You correctly identified that the base case stops the recursion. "
            "You could also mention that it prevents a stack overflow.",
      ),
      QuestionFeedback(
        id: 2,
        score: 10,
        feedback: "This answer doesn't attempt the question. Think about stack depth, memory use and readability.",
      ),
    ],
  ),
);

final FeedbackFixture dummyCodingProblem = (
  quiz: Quiz(
    type: QuizType.codingProblem,
    subTopic: "Strings",
    difficulty: "medium",
    questions: [
      CodingProblem(
        id: 1,
        question: "Write a function is_palindrome(s) that returns True if s reads the same forwards and backwards, ignoring case.",
        inputExample: "is_palindrome('Racecar')",
        outputExample: "True",
      ),
      CodingProblem(
        id: 2,
        question: "Write a function count_vowels(s) that returns the number of vowels in s.",
        inputExample: "count_vowels('hello world')",
        outputExample: "3",
      ),
    ],
    userAnswers: [
      "def is_palindrome(s):\n    s = s.lower()\n    return s == s[::-1]",
      "def count_vowels(s):\n    n = 0\n    for c in s:\n        if c in 'aeiou':\n            n += 1\n    return n",
    ],
  ),
  feedback: QuizFeedback(
    results: [
      QuestionFeedback(
        id: 1,
        score: 90,
        summary: "A correct and concise solution.",
        correctness: "Your function returns True for 'Racecar' and False for clearly non-palindromic input, so it meets the stated requirement. Lower-casing the string before comparing handles mixed-case input exactly as the question asks. I traced several inputs, including single characters and the empty string, and each produced the expected result. The logic is sound for the problem as written. The only gaps appear when you consider inputs beyond the example given.",
        approach: "Lower-casing the string and comparing it to its reversed slice is the idiomatic Python way to solve this problem. It avoids manual index juggling and makes the intent obvious at a glance. A two-pointer approach would also work, but it is more verbose and offers no real advantage here. Choosing the simplest tool that fits the job shows good judgement. Keep favouring readable built-in features like slicing when they fit.",
        edgeCases: "Spaces and punctuation are not ignored, so a phrase like 'A man, a plan, a canal: Panama' would incorrectly return False. The question only mentions ignoring case, so this is not strictly an error, but real palindrome checks usually skip non-alphanumeric characters. An empty string returns True, which is the conventional answer. Single-character strings also behave correctly. Consider asking yourself what unusual input a user might realistically provide.",
        efficiency: "The function runs in O(n) time because lower-casing and slicing each walk the string once. It also uses O(n) extra space because s[::-1] builds a full reversed copy. For typical inputs this is perfectly acceptable and not worth optimising. A two-pointer loop could reduce the extra space to O(1) and exit early on the first mismatch. That trade-off only matters for very large strings.",
        codeQuality: "The function name and parameter are clear, and the body is just two short lines, which makes it very easy to read. Reassigning s to its lower-cased version is fine, though a separate variable such as lowered would avoid overwriting the argument. There is no docstring, which would be helpful for explaining the case-insensitive behaviour. Adding a type hint such as s: str -> bool would also improve clarity. Overall the style is tidy and consistent.",
        improvements: "Try stripping non-alphanumeric characters before comparing, for example with c.isalnum() inside a generator expression. This makes your function work for real phrases as well as single words. Next, add a short docstring describing what the function ignores. Finally, write a few test cases, including an empty string and a sentence with punctuation, to confirm the behaviour. Practising this habit will help you catch edge-case bugs before anyone else does.",
        codeExample: "```python\ndef is_palindrome(s):\n    cleaned = ''.join(c.lower() for c in s if c.isalnum())\n    return cleaned == cleaned[::-1]\n```",
      ),
      QuestionFeedback(
        id: 2,
        score: 55,
        summary: "Works for lowercase input but misses uppercase vowels.",
        correctness: "Your function returns 3 for 'hello world', so it passes the provided example. However, count_vowels('HELLO') returns 0 because the check only matches lowercase letters. Any input with capital vowels will be undercounted. This means the solution is only partly correct. The core counting logic is right, but the comparison is too narrow to handle realistic text.",
        approach: "Looping over each character and incrementing a counter is a perfectly reasonable approach for this problem. It is easy to follow and shows that you understand iteration and conditionals. The structure of the loop is clean and the accumulator is initialised correctly. The weakness is not the overall strategy but the condition inside the loop. A small change to how characters are compared would fix it.",
        edgeCases: "Uppercase vowels are the main failure, so 'AEIOU' returns 0 instead of 5. An empty string correctly returns 0, and strings with no vowels also work. Accented characters such as 'é' are not counted, though the question does not require them. Numbers and punctuation are ignored correctly. Testing with a mix of upper and lower case would have revealed the bug immediately.",
        efficiency: "The function runs in O(n) time and O(1) space, which is optimal for this task because every character must be inspected. The membership test c in 'aeiou' scans a short string each time, which is negligible for five characters. Using a set of vowels would be marginally faster and signals intent more clearly. In practice the difference is tiny. There is no need to optimise further.",
        codeQuality: "The variable name n is short and does not describe what it stores, so count or vowel_count would be more readable. The explicit loop is easy to understand, but Python offers a more compact form using sum() with a generator expression. Indentation and spacing are consistent. A brief docstring would help future readers. Overall the code is clear, just slightly longer than it needs to be.",
        improvements: "Lower-case the input before checking, for example by looping over s.lower(), so that capital vowels are counted. Rename n to something more descriptive like vowel_count. Then try rewriting the function as a one-line sum() with a generator expression and compare the readability. Finally, test with 'HELLO', 'AEIOU' and an empty string to confirm everything works. This will build the habit of testing varied inputs.",
        codeExample: "```python\ndef count_vowels(s):\n    return sum(1 for c in s.lower() if c in 'aeiou')\n```",
      ),
    ],
  ),
);

final FeedbackFixture dummyCodingExercise = (
  quiz: Quiz(
    type: QuizType.codingExercise,
    subTopic: "Dictionaries",
    difficulty: "medium",
    questions: [
      CodingExercise(
        id: 1,
        question: "Build a word-frequency counter.",
        steps: [
          "Create an empty dictionary called counts.",
          "Loop over each word in the list words.",
          "Increase the count for each word, adding it if missing.",
          "Print the dictionary.",
        ],
      ),
    ],
    userAnswers: [
      "counts = {}\nfor w in words:\n    counts[w] += 1\nprint(counts)",
    ],
  ),
  feedback: QuizFeedback(
    results: [
      QuestionFeedback(
        id: 1,
        score: 60,
        summary:
            "Good structure, but the program crashes on the first new word.",
        stepFeedback: const [
          StepFeedback(
            id: 1,
            completed: true,
            feedback: "Dictionary created correctly.",
            codeExample: "```python\ncounts = {}\n```",
          ),
          StepFeedback(
            id: 2,
            completed: true,
            feedback: "Loop is correct.",
            codeExample: "```python\nfor word in words:\n    ...\n```",
          ),
          StepFeedback(
            id: 3,
            completed: false,
            feedback: "Missing keys are not handled, which causes a KeyError.",
            codeExample:
                "```python\ncounts[word] = counts.get(word, 0) + 1\n```",
          ),
          StepFeedback(
            id: 4,
            completed: true,
            feedback: "Printed as required.",
            codeExample: "```python\nprint(counts)\n```",
          ),
        ],
      ),
    ],
  ),
);

class FeedbackDialog extends StatelessWidget {
  final FeedbackFixture feedbackFixture;
  final QuizMode mode;
  final Property? propertyToStrengthen;

  const FeedbackDialog({
    required this.feedbackFixture,
    this.mode = QuizMode.creation,
    this.propertyToStrengthen,
    super.key,
  });

  const FeedbackDialog.strengthen({
    required this.feedbackFixture,
    required Property propertyToStrengthen,
    super.key,
  }) : mode = QuizMode.strengthen,
       propertyToStrengthen = propertyToStrengthen;

  Color getScoreBoxColor(int score) => switch (score) {
    > 75 => AppColors.correctBoxGreen,
    > 40 => AppColors.midBoxYellow,
    _ => AppColors.wrongBoxRed,
  };

  @override
  Widget build(BuildContext context) {
    final gameController = context.read<GameController>();

    final body = switch (feedbackFixture.quiz.type) {
      QuizType.multipleChoice => MultipleChoiceFeedbackList(
        feedbackFixture: feedbackFixture,
      ),
      QuizType.codingProblem => CodingProblemFeedbackList(
        feedbackFixture: feedbackFixture,
      ),
      QuizType.codingExercise => CodingExerciseFeedbackList(
        feedbackFixture: feedbackFixture,
      ),
      QuizType.theory => TheoryQuestionFeedbackList(
        feedbackFixture: feedbackFixture,
      ),
    };

    final buttonText = switch (mode) {
      QuizMode.creation => "Exit and place property",
      QuizMode.attack => "Exit and attack property",
      QuizMode.strengthen => "Exit and strengthen property",
    };

    final totalScore = feedbackFixture.feedback.totalScore;
    final scoreColor = getScoreBoxColor(totalScore);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      backgroundColor: const Color.fromARGB(255, 33, 48, 68),
      insetPadding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.9,
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
          minHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              TitleText(text: "Activity complete!"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TitleText(text: "Score: "),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: scoreColor,
                      borderRadius: AppDimensions.cornerRadius,
                    ),
                    child: TitleText(text: "$totalScore"),
                  ),
                ],
              ),
              Divider(color: AppColors.dividerWhite),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(child: body),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 84, 104, 138),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                  minimumSize: Size(40.0, 40.0),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: const Color.fromARGB(141, 255, 255, 255),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  await gameController.endQuiz(
                    feedback: feedbackFixture.feedback,
                    quiz: feedbackFixture.quiz,
                    mode: mode,
                    propertyToStrengthen: propertyToStrengthen
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                    await Future.delayed(Duration(seconds: 1));
                    feedbackFixture.quiz.userAnswers.clear();
                  }
                },
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}

class MultipleChoiceFeedbackSection {
  final String question;
  final String correctAnswer;
  final String answer;
  final List<String> distractors;
  final String feedback;
  final int score;

  const MultipleChoiceFeedbackSection({
    required this.question,
    required this.correctAnswer,
    required this.answer,
    required this.distractors,
    required this.feedback,
    required this.score,
  });
}

class MultipleChoiceFeedbackList extends StatelessWidget {
  final FeedbackFixture feedbackFixture;

  const MultipleChoiceFeedbackList({required this.feedbackFixture, super.key});

  List<MultipleChoiceFeedbackSection> linkFeedbackContent() {
    int _getQuestionScore(String ans, String correctAns) {
      if (ans == correctAns) {
        return 20;
      } else {
        return 0;
      }
    }

    final questions = feedbackFixture.quiz.questions;
    final answers = feedbackFixture.quiz.userAnswers;
    final feedback = feedbackFixture.feedback.results;

    List<MultipleChoiceFeedbackSection> linkedContent = [];

    for (int i = 0; i < questions.length; i++) {
      final convertedQuestion = questions[i] as MultipleChoiceQuestion;
      final questionString = convertedQuestion.question;
      final correctAnswerString = convertedQuestion.correctAnswer;
      final answerString = answers[i];
      final feedbackString = feedback[i].feedback!;
      final distractors = convertedQuestion.distractors;
      final score = _getQuestionScore(answerString, correctAnswerString);

      final currentSection = MultipleChoiceFeedbackSection(
        question: questionString,
        correctAnswer: correctAnswerString,
        answer: answerString,
        distractors: distractors,
        feedback: feedbackString,
        score: score,
      );
      linkedContent.add(currentSection);
    }
    return linkedContent;
  }

  @override
  Widget build(BuildContext context) {
    final feedbackContent = linkFeedbackContent();

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Column(
        children: [
          for (final content in feedbackContent) ...[
            MultipleChoiceQuestionCard(content: content),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class MultipleChoiceQuestionCard extends StatelessWidget {
  final MultipleChoiceFeedbackSection content;

  const MultipleChoiceQuestionCard({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    final options = [content.correctAnswer, ...content.distractors];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: AppDimensions.cornerRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmoothMarkdown(
            data: content.question,
            builderRegistry: MarkdownStyles.markdownBuilders,
            config: MarkdownStyles.markdownConfig,
            styleSheet: MarkdownStyles.markdownStyle,
            useEnhancedComponents: true
          ),
          const SizedBox(height: 12),

          for (final option in options)
            MultipleChoiceOption(
              text: option,
              isCorrect: option == content.correctAnswer,
              isSelected: option == content.answer,
            ),

          const SizedBox(height: 16),

          MultipleChoiceResponseCard(content: content),
        ],
      ),
    );
  }
}

class MultipleChoiceOption extends StatelessWidget {
  final String text;
  final bool isCorrect;
  final bool isSelected;

  const MultipleChoiceOption({
    required this.text,
    required this.isCorrect,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;

    if (isCorrect) {
      backgroundColor = AppColors.correctBoxGreen;
    } else if (isSelected) {
      backgroundColor = AppColors.wrongBoxRed;
    } else {
      backgroundColor = AppColors.blue;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppDimensions.cornerRadius,
        border: Border.all(color: AppColors.dividerWhite)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: 12.0),
          Expanded(child: SmoothMarkdown(
            data: text, 
            styleSheet: MarkdownStyles.markdownStyle,
            config: MarkdownStyles.markdownConfig,
            builderRegistry: MarkdownStyles.markdownBuilders,
            useEnhancedComponents: true,
          )),
          if (isCorrect) ContentText(text: "Correct answer"),
          if (isSelected && !isCorrect) ContentText(text: "Your answer"),
        ],
      ),
    );
  }
}

class MultipleChoiceResponseCard extends StatelessWidget {
  final MultipleChoiceFeedbackSection content;

  const MultipleChoiceResponseCard({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    final answeredCorrectly = content.answer == content.correctAnswer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 33, 48, 68),
        borderRadius: AppDimensions.cornerRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubtitleText(
            text: answeredCorrectly ? "Your answer was correct" : "Your answer",
          ),
          const SizedBox(height: 6),
          ContentText(text: content.answer),
          const SizedBox(height: 12),
          SubtitleText(text: "Feedback"),
          const SizedBox(height: 6),
          ContentText(text: content.feedback),
        ],
      ),
    );
  }
}

class CodingProblemFeedbackList extends StatefulWidget {
  final FeedbackFixture feedbackFixture;

  const CodingProblemFeedbackList({required this.feedbackFixture, super.key});

  List<FeedbackSection> getSectionData(QuestionFeedback feedback) => [
    FeedbackSection(
      title: "Summary",
      content: feedback.summary ?? "No summary provided.",
    ),
    FeedbackSection(
      title: "Correctness",
      content: feedback.correctness ?? "No content provided.",
    ),
    FeedbackSection(
      title: "Approach",
      content: feedback.approach ?? "No content provided.",
    ),
    FeedbackSection(
      title: "Edge cases",
      content: feedback.edgeCases ?? "No content provided.",
    ),
    FeedbackSection(
      title: "Efficiency",
      content: feedback.efficiency ?? "No content provided.",
    ),
    FeedbackSection(
      title: "Code quality",
      content: feedback.codeQuality ?? "No content provided.",
    ),
    FeedbackSection(
      title: "Improvements",
      content: feedback.improvements ?? "No content provided.",
    ),
  ];

  @override
  State<CodingProblemFeedbackList> createState() => _CodingProblemFeedbackListState();
}
class _CodingProblemFeedbackListState extends State<CodingProblemFeedbackList> {
  int currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final feedbackList = widget.feedbackFixture.feedback.results;
    final currentQuestion = feedbackList[currentQuestionIndex];
    final sections = widget.getSectionData(currentQuestion);
    final summarySection = sections.firstWhere((s) => s.title == "Summary");
    final detailSections = sections.where((s) => s.title != "Summary").toList();
    final codeExample = currentQuestion.codeExample;
    final userAnswer = widget.feedbackFixture.quiz.userAnswers[currentQuestionIndex];
    final hasMultipleQuestions = feedbackList.length > 1;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 1000),
      child: Column(
        children: [
          FeedbackSectionCard(section: summarySection),
          const SizedBox(height: 12),
          CodeCard(title: "Your solution", code: userAnswer),
          const SizedBox(height: 12),

          for (var index = 0; index < detailSections.length; index += 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: FeedbackSectionCard(
                        section: detailSections[index],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: index + 1 < detailSections.length
                          ? FeedbackSectionCard(
                              section: detailSections[index + 1],
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          CodeCard(
            title: "Code example",
            code: codeExample ?? "No example needed.",
          ),
          hasMultipleQuestions
              ? Row(
                children: [
                  currentQuestionIndex > 0
                      ? ElevatedButton(
                          child: Text("Previous"),
                          onPressed: () {
                            setState(() => currentQuestionIndex--);
                          }
                      )
                      : SizedBox(),
                  ElevatedButton(
                      child: Text("Next"),
                      onPressed: () {
                        if (currentQuestionIndex < feedbackList.length - 1) {
                          setState(() => currentQuestionIndex++);
                        }
                      }
                  ),
                ],
              )
              : SizedBox()
        ],
      ),
    );
  }
}

class CodingExerciseFeedbackList extends StatefulWidget {
  final FeedbackFixture feedbackFixture;

  const CodingExerciseFeedbackList({required this.feedbackFixture, super.key});

  @override
  State<CodingExerciseFeedbackList> createState() => _CodingExerciseFeedbackListState();
}

class _CodingExerciseFeedbackListState extends State<CodingExerciseFeedbackList> {
  int currentQuestionIndex = 0;

  List<FeedbackSection> getSectionData(List<StepFeedback> stepFeedback) {
    final List<FeedbackSection> sectionList = [];
    for (int i = 0; i < stepFeedback.length; i++) {
      sectionList.add(
        FeedbackSection(
          title: "Step ${i + 1}",
          content: stepFeedback[i].feedback,
        ),
      );
    }
    return sectionList;
  }

  List<String> getCodeExamples(List<StepFeedback> stepFeedback) {
    final List<String> exampleList = [];
    for (int i = 0; i < stepFeedback.length; i++) {
      exampleList.add(stepFeedback[i].codeExample);
    }
    return exampleList;
  }

  @override
  Widget build(BuildContext context) {
    final feedbackList = widget.feedbackFixture.feedback.results;
    final feedback = feedbackList[currentQuestionIndex];
    final summary = feedback.summary!;
    final userAnswer = widget.feedbackFixture.quiz.userAnswers[currentQuestionIndex];
    final hasMultipleQuestions = feedbackList.length > 1;
    final stepSections = getSectionData(feedback.stepFeedback!);
    final codeExamples = getCodeExamples(feedback.stepFeedback!);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 1000),
      child: Column(
        spacing: 12.0,
        children: [
          FeedbackSectionCard(
            section: FeedbackSection(title: "Summary", content: summary),
          ),
          CodeCard(title: "Your answer", code: userAnswer),
          for (int i = 0; i < stepSections.length; i++)
            Column(
              children: [
                FeedbackSectionCard(section: stepSections[i]),
                SizedBox(height: 12.0),
                CodeCard(title: "Code example", code: codeExamples[i]),
              ],
            ),
          hasMultipleQuestions
              ? Row(
                children: [
                  currentQuestionIndex > 0
                      ? ElevatedButton(
                          child: Text("Previous"),
                          onPressed: () {
                            setState(() => currentQuestionIndex--);
                          }
                      )
                      : SizedBox(),
                  ElevatedButton(
                      child: Text("Next"),
                      onPressed: () {
                        if (currentQuestionIndex < feedbackList.length - 1) {
                          setState(() => currentQuestionIndex++);
                        }
                      }
                  ),
                ],
              )
              : SizedBox()
        ],
      ),
    );
  }
}

class TheoryQuestionFeedbackList extends StatelessWidget {
  final FeedbackFixture feedbackFixture;

  const TheoryQuestionFeedbackList({required this.feedbackFixture, super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class FeedbackSection {
  final String title;
  final String content;

  const FeedbackSection({required this.title, required this.content});
}

class FeedbackSectionCard extends StatelessWidget {
  final FeedbackSection section;

  const FeedbackSectionCard({required this.section, super.key});

  @override
  Widget build(BuildContext context) {
    final title = section.title;
    final content = section.content;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: AppDimensions.cornerRadius,
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Column(
              children: [
                SubtitleText(text: title),
                Divider(color: AppColors.dividerWhite),
              ],
            ),
            ContentText(text: content),
          ],
        ),
      ),
    );
  }
}

class CodeCard extends StatelessWidget {
  final String title;
  String code;

  CodeCard({required this.title, required this.code, super.key});

  @override
  Widget build(BuildContext context) {
    if (!code.startsWith("```python")) {
      code = "```python\n$code\n```";
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 19, 28, 38),
        borderRadius: AppDimensions.cornerRadius,
        border: Border.all(color: AppColors.blue),
      ),
      child: Column(
        children: [
          Column(
            children: [
              SubtitleText(text: title),
              Divider(color: AppColors.dividerWhite),
            ],
          ),
          SmoothMarkdown(
            data: code,
            styleSheet: MarkdownStyles.markdownStyle,
            config: MarkdownStyles.markdownConfig,
            builderRegistry: MarkdownStyles.markdownBuilders,
            useEnhancedComponents: true,
            selectable: true,
          ),
        ],
      ),
    );
  }
}

// @Preview()
// Widget previewCodeExample() {
//   final fixture = dummyCodingProblem;
//   return CodeExampleCard(
//     codeExample: fixture.feedback.results.first.codeExample!
//   );
// }

@Preview()
Widget previewDialog() {
  return FeedbackDialog(
    feedbackFixture: dummyCodingProblem,
    mode: QuizMode.creation,
  );
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: FeedbackDialog(
            feedbackFixture: dummyMultipleChoice,
            mode: QuizMode.creation,
          ),
        ),
      ),
    ),
  );
}

// @Preview()
// Widget previewCard() {
//   return FeedbackSectionCard(
//     section: FeedbackSection(title: "Correctness", content: "No correctness."),
//   );
// }
