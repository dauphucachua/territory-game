import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/quiz_models/question_models/question.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';

void main() {

  final testQues1 = MultipleChoiceQuestion(id: 1, question: "Question 1", distractors: ["d1", "d2" ], correctAnswer: "Question 1");
  final testQues2 = MultipleChoiceQuestion(id: 2, question: "Question 2", distractors: ["d3", "d4"], correctAnswer: "Question 2");
  final testQues3 = MultipleChoiceQuestion(id: 3, question: "Question 3", distractors: ["d5", "d6"], correctAnswer: "Question 3");

  final testQuestions = [testQues1, testQues2, testQues3];
  final testAnswers = ["Answer 1", "Answer 2", "Answer 3"];

  final testQuiz = Quiz(type: "multipleChoice", questions: testQuestions, userAnswers: testAnswers, subTopic: "subTopic");

  test("get questionAnswerMap", () {
    final testMap = testQuiz.questionAnswerMap;
    print(testMap);
    expect(testMap["question 1"]["question"], "Question 1");
    expect(testMap["question 1"]["userAnswer"], "Answer 1");
    
  });

  test("toStringForFeedbackPrompt", () {
    print(testQuiz.toStringForFeedbackPrompt());
  });

  test("toJson", () {
    Map<String, dynamic> quizJson = testQuiz.toJson();
    print(quizJson);
    Quiz quizObj = Quiz.fromJson(quizJson);
    print(quizObj);
  });

  
}