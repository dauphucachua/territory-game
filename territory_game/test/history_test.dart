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
  
  /// Tests that the JSON serialisation/deserialisation methods produce the expected result.
  test("json", () {
    history.activityHistory = ["Event message 1", "Event message 2"];
    history.questionHistory["multipleChoice"] = ["MC question 1", "MC question 2"];
    history.questionHistory["codingProblem"] = ["CP question 1", "CP question 2"];

    final historyJson = history.toJson();
    expect(historyJson["activityHistory"][0], "Event message 1");
    expect(historyJson["activityHistory"][1], "Event message 2");
    expect(historyJson["questionHistory"]["multipleChoice"][0], "MC question 1");
    expect(historyJson["questionHistory"]["multipleChoice"][1], "MC question 2");
    expect(historyJson["questionHistory"]["codingProblem"][0], "CP question 1");
    expect(historyJson["questionHistory"]["codingProblem"][1], "CP question 2");
    
    final historyObj = History.fromJson(historyJson);
    expect(historyObj.activityHistory[0], "Event message 1");
    expect(historyObj.activityHistory[1], "Event message 2");
    expect(historyObj.questionHistory["multipleChoice"]![0], "MC question 1");
    expect(historyObj.questionHistory["multipleChoice"]![1], "MC question 2");
    expect(historyObj.questionHistory["codingProblem"]![0], "CP question 1");
    expect(historyObj.questionHistory["codingProblem"]![1], "CP question 2");

  });

  /// Tests that chat messages are saved in the activityHistory List.
  test("addChatMessage", () {
    history.addChatMessage(author, "test chat message");
    expect(history.activityHistory[0].contains("displayName"), true);
    expect(history.activityHistory[0].contains("test chat message"), true);
  });

  /// Tests that event messages are saved in the activityHistory List.
  test("addEventMessage", () {
    history.addEvent("test event message");
    expect(history.activityHistory[0].contains("test event message"), true);
  });

  /// Tests that questions are saved in the questionHistory Map under the right key.
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