import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/history.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';

void main() {
  final history = History();
  final author = Player(
    displayName: "displayName",
    id: "id1",
    propertyColor: Colors.black,
  );
  
  test("json", () {
    final historyJson = history.toJson();
    print(historyJson);
    final historyObj = History.fromJson(historyJson);
    print(historyObj.activityHistory);
    print(historyObj.questionHistory);
  });

  test("addChatMessage", () {
    history.addChatMessage(author, "test chat message");
    expect(history.activityHistory[0].contains("displayName"), true);
    expect(history.activityHistory[0].contains("test chat message"), true);
  });

  test("addEventMessage", () {
    history.addEvent("test event message");
    expect(history.activityHistory[0].contains("test event message"), true);
  });

  test("addQuestions", () {
    final questionType = "multipleChoice";
    
    final testQues1 = MultipleChoiceQuestion(
      id: 1, 
      question: "Question 1", 
      distractors: ["Answer 2", "Answer 3", "Answer 4"], 
      correctAnswer: "Answer 1"
    );
    
    final testQues2 = MultipleChoiceQuestion(
      id: 2, 
      question: "Question 2", 
      distractors: ["Answer 2", "Answer 3", "Answer 4"], 
      correctAnswer: "Answer 1"
    );
    
    final questions = [testQues1, testQues2];
  
    history.addQuestions(questionType, questions);
    expect(history.questionHistory[questionType]![0], "Question 1");
    expect(history.questionHistory[questionType]![1], "Question 2");
  });
}