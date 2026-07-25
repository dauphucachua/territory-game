import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
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
  String selectedSubtopic = "";
  String selectedQuestionType = "";
  String selectedDifficulty = "";
  final difficulties = ["Easy", "Medium", "Hard"];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    
    Widget getCardDataBody(String subTopic) {
      Map subTopicCount = gameController.subTopicCountPerArea();
      Map currentSubTopicCount = subTopicCount[subTopic];

      return Column(
        children: [
          for (String area in currentSubTopicCount.keys) 
            Text(
              "$area: ${currentSubTopicCount[area]}/${gameController.game.board.areaLimits[area]}",
              style: TextStyle(
                color: AppColors.opaqueWhite,
                fontSize: 12
              ),
            )
        ]
      );
    }
    
    List<SelectionCardData> getCardDataList(List<String> titles) {
      List<SelectionCardData> cardData = (titles.map((title) => SelectionCardData(
        title: title, 
        body: gameController.subTopics.contains(title)
          ? getCardDataBody(title)
          : null
      ))).toList();
      return cardData;
    }

    

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
              selectedTitle: selectedSubtopic,
              cardData: getCardDataList(gameController.subTopics),
              onTapCallback: (String subTopic) => setState(() => selectedSubtopic = subTopic),
            ),
            SizedBox(height: 10.0),
            Divider(),
            SizedBox(height: 20.0),
            // Second subtitle
            SubtitleText(
              text: "Select a question type",
            ),
            // Question type choice ListView
            ScrollableHorizontalListView(
              height: 100,
              selectedTitle: selectedQuestionType,
              cardData: getCardDataList(gameController.subject.questionTypes), 
              onTapCallback: (String questionType) => setState(() => selectedQuestionType = questionType)
            ),
            Divider(),
            SizedBox(height: 20.0),
            // Second subtitle
            SubtitleText(
              text: "Select a difficulty",
            ),
            ScrollableHorizontalListView(
              height: 100,
              selectedTitle: selectedDifficulty,
              cardData: getCardDataList(difficulties), 
              onTapCallback: (String difficulty) => setState(() => selectedDifficulty = difficulty)
            ),
            Spacer(),
            Row(
              mainAxisAlignment: .end,
              children: [
                // Start quiz button
                _isLoading ? LoaderWithText(text: "Getting quiz from chatbot...")
                : ElevatedButton(      
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 57, 92, 109),
                    elevation: 2.0,
                    fixedSize: Size(150, 50)
                  ),
                  child: Text(
                    "Start quiz", 
                    style: TextStyle(
                      color: const Color.fromARGB(164, 255, 255, 255),
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  onPressed: () async { // Still to refactor
                    // Close dialog
                    if (selectedSubtopic.isNotEmpty && selectedQuestionType.isNotEmpty) {
                      setState(() => _isLoading = true);
                      Quiz newQuiz = await gameController.getQuiz(
                        selectedSubtopic,
                        selectedQuestionType,
                        selectedQuestionType == "multipleChoice" ? 5 : 1,
                        selectedDifficulty // Temporarily hardcoded while buttons not implemented
                      );
                      setState(() => _isLoading = false);
                      if (context.mounted) {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (newContext) => ChangeNotifierProvider.value(
                            value: context.read<GameController>(),
                            child: QuizDialog(
                              quiz: newQuiz,
                            )
                          )
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Select a topic and quiz type"),
                        )
                      );
                    }
                  }
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}

class SelectionCardData {
  final String title;
  final Widget? body;

  const SelectionCardData({
    required this.title,
    this.body
  });
}

class SelectionCard extends StatelessWidget { 
  final String title;
  bool isSelected;
  final Widget? body;
  final void Function() onTap;
  final double width;
  
  
  SelectionCard({
    required this.title,
    this.isSelected = false,
    this.body,
    required this.onTap,
    this.width = 150, 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        color: isSelected ? Color.fromARGB(255, 82, 132, 157) : Color.fromARGB(255, 57, 92, 109),
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
                    fontSize: 15.0
                    
                  ),
                  textAlign: .left
                ),
                if (body != null)
                  Column(
                    children: [
                      Divider(),
                      body!
                    ]
                  ) 
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScrollableHorizontalListView extends StatelessWidget {
  final List<SelectionCardData> cardData;
  final double height;
  final void Function(String) onTapCallback;
  String? selectedTitle;
 
 ScrollableHorizontalListView({
    required this.cardData,
    this.height = 150,
    required this.onTapCallback,
    this.selectedTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
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
                isSelected: title == selectedTitle,
                onTap: () => onTapCallback(title)
              ),
            );
          },
        ),
      ),
    );
  }
}



