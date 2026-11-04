import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_type.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';
import 'package:territory_game/view/widgets/game_screen/UI/dialogs/quiz_dialog.dart';

/// A dialog box for selecting quiz settings.
///
/// Quiz settings include subtopic, question type, number of questions (unimplemented), difficulty (unimplemented).
class AddPropertyDialog extends StatefulWidget {
  const AddPropertyDialog({super.key});

  @override
  State<AddPropertyDialog> createState() => _AddPropertyDialogState();
}

class _AddPropertyDialogState extends State<AddPropertyDialog> {
  // Empty strings for storing user selections.
  String selectedSubtopic = "";
  QuizType? selectedQuestionType;
  String selectedDifficulty = "";
  final difficulties = ["Easy", "Medium", "Hard"];
  bool _isLoading = false;

  List<QuizType> getAvailableQuizTypes(Subject subject) {
    return QuizType.values
        .where((type) => subject.questionTypes.contains(type.name))
        .toList();
  }

  /// Gets the sub-topic limit data for display in sub-topic cards.
  Widget getCardDataBody(String subTopic, GameController gameController) {
    Map subTopicCount = gameController.subTopicCountPerArea();
    Map currentSubTopicCount = subTopicCount[subTopic];

    return Column(
      children: [
        for (String area in currentSubTopicCount.keys)
          Text(
            "$area: ${currentSubTopicCount[area]}/${gameController.game.board.areaLimits[area]}",
            style: TextStyle(color: AppColors.opaqueWhite, fontSize: 12),
          ),
      ],
    );
  }

  /// Returns a list of card data for building the scrollable ListViews.
  List<SelectionCardData> getCardDataList(
    List<String> titles,
    GameController gameController,
  ) {
    List<SelectionCardData> cardData = (titles.map(
      (title) => SelectionCardData(
        title: title,
        value: title,
        body: gameController.subTopics.contains(title)
            ? getCardDataBody(title, gameController)
            : null,
      ),
    )).toList();
    return cardData;
  }

  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    final quizTypeCards = getAvailableQuizTypes(gameController.subject)
        .map(
          (type) => SelectionCardData(
            title: type.toReadableString(),
            value: type.name,
          ),
        )
        .toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      backgroundColor: const Color.fromARGB(255, 33, 48, 68),
      insetPadding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Header title and 'X' button
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                TitleText(text: "New property"),
                CloseWindowButton(),
              ],
            ),
            Divider(),
            SizedBox(height: 20.0),
            // First subtitle
            SubtitleText(text: "Select a sub-topic"),
            // Sub-topic selection ListView
            ScrollableHorizontalListView(
              selectedValue: selectedSubtopic,
              cardData: getCardDataList(
                gameController.subTopics,
                gameController,
              ),
              onTapCallback: (String subTopic) =>
                  setState(() => selectedSubtopic = subTopic),
            ),
            SizedBox(height: 10.0),
            Divider(),
            SizedBox(height: 20.0),
            // Second subtitle
            SubtitleText(text: "Select an activity type"),
            // Question type choice ListView
            ScrollableHorizontalListView(
              height: 100,
              selectedValue: selectedQuestionType?.name,
              cardData: quizTypeCards,
              onTapCallback: (String quizType) => setState(
                () => selectedQuestionType = QuizType.fromString(quizType),
              ),
            ),
            Divider(),
            SizedBox(height: 20.0),
            // Second subtitle
            SubtitleText(text: "Select a difficulty"),
            ScrollableHorizontalListView(
              height: 100,
              selectedValue: selectedDifficulty,
              cardData: getCardDataList(difficulties, gameController),
              onTapCallback: (String difficulty) =>
                  setState(() => selectedDifficulty = difficulty),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: .end,
              children: [
                // Start quiz button
                _isLoading
                    ? LoaderWithText(text: "Getting quiz from chatbot...")
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            57,
                            92,
                            109,
                          ),
                          elevation: 2.0,
                          fixedSize: Size(150, 50),
                        ),
                        child: Text(
                          "Start quiz",
                          style: TextStyle(
                            color: const Color.fromARGB(164, 255, 255, 255),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          final allOptionsSelected =
                              selectedSubtopic.isNotEmpty &&
                              selectedQuestionType != null &&
                              selectedDifficulty.isNotEmpty;
                          // Still to refactor
                          // Close dialog
                          if (allOptionsSelected) {
                            setState(() => _isLoading = true);
                            try {
                              Quiz newQuiz = await gameController.getQuiz(
                                selectedSubtopic,
                                selectedQuestionType!,
                                selectedQuestionType == QuizType.multipleChoice
                                    ? 5
                                    : 1,
                                selectedDifficulty, // Temporarily hardcoded while buttons not implemented
                              );
                              if (context.mounted) {
                                Navigator.pop(context);
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (newContext) =>
                                      ChangeNotifierProvider.value(
                                        value: gameController,
                                        child: QuizDialog(quiz: newQuiz),
                                      ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Could not load quiz: $e"))
                                );
                              }
                            } 
                            finally {
                              if (context.mounted) {
                                setState(() => _isLoading = false);
                              }
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "Select a topic, quiz type and difficulty.",
                                ),
                              ),
                            );
                          }
                        },
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Data model for the selection cards.
class SelectionCardData {
  final String title;
  final String value;
  final Widget? body;

  const SelectionCardData({
    required this.title,
    required this.value,
    this.body,
  });
}

/// Custom widget for selection cards.
class SelectionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Widget? body;
  final void Function() onTap;
  final double width;

  const SelectionCard({
    required this.title,
    this.isSelected = false,
    this.body,
    required this.onTap,
    this.width = 150,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        color: isSelected
            ? Color.fromARGB(255, 82, 132, 157)
            : Color.fromARGB(255, 57, 92, 109),
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: width,
            child: Column(
              mainAxisAlignment: .start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color.fromARGB(164, 255, 255, 255),
                    fontSize: 15.0,
                  ),
                  textAlign: .left,
                ),
                if (body != null) Column(children: [Divider(), body!]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A custom widget for a horizontally scrollable ListView.
class ScrollableHorizontalListView extends StatelessWidget {
  final List<SelectionCardData> cardData;
  final double height;
  final void Function(String) onTapCallback;
  final String? selectedValue;

  const ScrollableHorizontalListView({
    required this.cardData,
    this.height = 150,
    required this.onTapCallback,
    required this.selectedValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
        child: ListView.builder(
          scrollDirection: .horizontal,
          itemCount: cardData.length,
          itemBuilder: (context, index) {
            String title = cardData[index].title;
            Widget? body = cardData[index].body;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectionCard(
                title: title,
                body: body,
                isSelected: cardData[index].value == selectedValue,
                onTap: () => onTapCallback(cardData[index].value),
              ),
            );
          },
        ),
      ),
    );
  }
}
