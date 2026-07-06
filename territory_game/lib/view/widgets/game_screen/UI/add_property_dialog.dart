import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/view/widgets/game_screen/UI/question_dialogs/quiz_dialog.dart';

class AddPropertyDialog extends StatefulWidget {
  final GameController gameController;

  AddPropertyDialog(this.gameController, {super.key});

  @override
  State<AddPropertyDialog> createState() => _AddPropertyDialogState();
}

class _AddPropertyDialogState extends State<AddPropertyDialog> {
  String selectedSubtopic = "";
  String selectedQuestionType = "";

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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  "New property", 
                  style: TextStyle(
                    fontSize: 25.0,
                    color: const Color.fromARGB(164, 255, 255, 255),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  icon: Icon(
                    Icons.close, 
                    color: const Color.fromARGB(139, 255, 255, 255)
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 20.0),
            Text(
              "Select a topic",
              style: TextStyle(
                color: const Color.fromARGB(164, 255, 255, 255),
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 150,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },),
                child: ListView.builder(
                  scrollDirection: .horizontal,
                  itemCount: widget.gameController.subTopics.length,
                  itemBuilder: (context, index) {
                    String subTopicName = widget.gameController.subTopics[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(                    
                        onTap: () {
                          setState(() {
                            selectedSubtopic = subTopicName;
                          });
                        },
                        child: SubTopicSelectionCard(
                          subTopicName: subTopicName
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Divider(),
            SizedBox(height: 20.0),
            Text(
              "Select a question type",
              style: TextStyle(
                color: const Color.fromARGB(164, 255, 255, 255),
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: .horizontal,
                children: [
                  for (int i = 0; i < widget.gameController.subject.questionTypes.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(           
                      onTap: () {
                        setState(() {
                          selectedQuestionType = widget.gameController.subject.questionTypes[i];
                        });
                      },
                      child: QuestionTypeSelectionCard(
                        questionType: widget.gameController.subject.questionTypes[i]),
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: .end,
              children: [
                ElevatedButton(      
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
                  onPressed: () async {
                    // Close dialog
                    if (selectedSubtopic.isNotEmpty && selectedQuestionType.isNotEmpty) {
                      Quiz newQuiz = await widget.gameController.getQuiz(
                        selectedSubtopic,
                        selectedQuestionType,
                        5 // Temporarily hardcoded while buttons not implemented
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return QuizDialog(quiz: newQuiz);
                          },
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

class SubTopicSelectionCard extends StatelessWidget { 
  final String subTopicName;
  final double? width;
  
  const SubTopicSelectionCard({
    required this.subTopicName,
    this.width = 150, 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 57, 92, 109),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: width,
          child: Text(
            subTopicName,
            style: TextStyle(
              color: const Color.fromARGB(164, 255, 255, 255),
              fontSize: 15.0,
            )
          ),
        ),
      ),
    );
  }
}

class QuestionTypeSelectionCard extends StatelessWidget {
  final String questionType;
  final double width;
  
  const QuestionTypeSelectionCard({
    required this.questionType,
    this.width = 150, 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 57, 92, 109),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 150,
          child: Text(
            "Question Type",
            style: TextStyle(
              color: const Color.fromARGB(164, 255, 255, 255),
              fontSize: 15.0,
            )
          ),
        ),
      ),
    );
  }
}

