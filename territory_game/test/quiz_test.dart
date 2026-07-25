import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/quiz_models/question_models/question.dart';
import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';

void main() {

  final testQues1 = MultipleChoiceQuestion(id: 1, question: "Question 1", distractors: ["Answer 2", "Answer 3", "Answer 4"], correctAnswer: "Answer 1");
  final testQues2 = MultipleChoiceQuestion(id: 2, question: "Question 2", distractors: ["Answer 2", "Answer 3", "Answer 4"], correctAnswer: "Answer 1");
  final testQues3 = MultipleChoiceQuestion(id: 3, question: "Question 3", distractors: ["Answer 2", "Answer 3", "Answer 4"], correctAnswer: "Answer 1");
  final testQues4 = MultipleChoiceQuestion(id: 1, question: "Question 4", distractors: ["Answer 2", "Answer 3", "Answer 4"], correctAnswer: "Answer 1");
  final testQues5 = MultipleChoiceQuestion(id: 2, question: "Question 5", distractors: ["Answer 2", "Answer 3", "Answer 4"], correctAnswer: "Answer 1");
  final testQues6 = MultipleChoiceQuestion(id: 3, question: "Question 6", distractors: ["Answer 2", "Answer 3", "Answer 4"], correctAnswer: "Answer 1");



  final testQuestions = [testQues1, testQues2, testQues3];
  final testQuestions2 = [testQues4, testQues5, testQues6];
  final testAnswers = ["Answer 1", "Answer 2", "Answer 3"];

  final testQuiz = Quiz(
    type: "multipleChoice", 
    questions: testQuestions, 
    userAnswers: testAnswers, 
    subTopic: "subTopic",
    difficulty: "Easy"
  );

  final testQuiz2 = Quiz(
    type: "multipleChoice", 
    questions: testQuestions2, 
    userAnswers: testAnswers, 
    subTopic: "subTopic",
    difficulty: "Easy"
  );

  test("toStringForFeedbackPrompt", () {
    print(testQuiz.toStringForFeedbackPrompt());
  });

  test("toJson", () {
    Map<String, dynamic> quizJson = testQuiz.toJson();
    print(quizJson);
    Quiz quizObj = Quiz.fromJson(quizJson);
    print(quizObj);
  });

  test("addQuestionsFromQuiz", () {
    testQuiz.addQuestionsFromQuiz(testQuiz2);
    expect(testQuiz.questions.length, 6); // Checks that questions have been added.
    expect(testQuiz.questions.first.id, 1);
    expect(testQuiz.questions.last.id, 6); // Checks that ids have increased to account for the updated quantity of the set.
  });



  
}