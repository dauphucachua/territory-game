import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/view/widgets/game_screen/UI/question_dialogs/quiz_dialog.dart';

class AddPropertyDialog extends StatelessWidget {
  final GameController gameController;
  String? selectedSubtopic;
  String? selectedQuestionType;
  AddPropertyDialog(this.gameController, {super.key});

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
                  itemCount: gameController.subTopics.length,
                  itemBuilder: (context, index) {
                    String subTopicName = gameController.subTopics[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          selectedSubtopic = subTopicName;
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
                  for (int i = 0; i < gameController.subject.questionTypes.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(           
                      onTap: () {
                        selectedQuestionType = gameController.subject.questionTypes[i];
                      },
                      child: QuestionTypeSelectionCard(
                        questionType: gameController.subject.questionTypes[i]),
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
                  onPressed: () {
                    // Close dialog
                    Navigator.pop(context);
                    // Call to API with: 
                    // 1) topic / subtopic details
                    // 2) type of question required
                    // 
                    // Open question dialog passing in the JSON returned by Mistral
                    // Question dialog takes the question content and builds the UI per question
                    Quiz newQuiz = Quiz(
                      id: "1",
                      type: "multipleChoice",
                      questions: [
                        MultipleChoiceQuestion(
                          id: 1,
                          question: "Are you cool?",
                          correctAnswer: "Yes",
                          distractors: ["I don't know", "No"]
                        ),
                        MultipleChoiceQuestion(
                          id: 2, 
                          question: "Are you sure?",
                          correctAnswer: "Yes",
                          distractors: ["I don't know", "No"]
                        ),
                      ]
                    );
                    showDialog(
                      context: context,
                      builder: (context) {
                        return QuizDialog(quiz: newQuiz);
                      },
                    );
                  
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
        child: Container(
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
        child: Container(
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

