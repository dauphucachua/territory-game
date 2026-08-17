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

  final testQuiz = Quiz(
    type: "multipleChoice", 
    questions: testQuestions, 
    subTopic: "subTopic",
    difficulty: "Easy"
  );

  final testQuiz2 = Quiz(
    type: "multipleChoice", 
    questions: testQuestions2, 
    subTopic: "subTopic",
    difficulty: "Easy"
  );

  /// Tests that the JSON serialisation/deserialisation methods produce the expected result.
  test("json", () {
    Map<String, dynamic> quizJson = testQuiz.toJson();

    expect(quizJson["quizType"], "multipleChoice");
    expect(quizJson["questions"], isA<List<Map<String, dynamic>>>());
    expect(quizJson["subTopic"], "subTopic");
    expect(quizJson["difficulty"], "Easy");
    
    Quiz quizObj = Quiz.fromJson(quizJson);

    expect(quizObj.type, "multipleChoice");
    expect(quizObj.questions, isA<List<Question>>());
    expect(quizObj.subTopic, "subTopic");
    expect(quizObj.difficulty, "Easy");
  });

  /// Tests that questions can be added from another quiz and question numbers are updated appropriately.
  /// 
  /// This is for strengtheing a property. 
  test("addQuestionsFromQuiz", () {
    testQuiz.addQuestionsFromQuiz(testQuiz2);
    expect(testQuiz.questions.length, 6); // Checks that questions have been added.
    expect(testQuiz.questions.first.id, 1);
    expect(testQuiz.questions.last.id, 6); // Checks that ids have increased to account for the updated quantity of the set.
  });

  /// Tests that the temporary userAnswers field can be successfully added to.
  test("storeUserAnswers", () {
    final answers = {
      1: "Answer 1",
      2: "Answer 2"
    };

    testQuiz.storeUserAnswers(answers);

    expect(testQuiz.userAnswers[0], "Answer 1");
    expect(testQuiz.userAnswers[1], "Answer 2");
    expect(testQuiz.userAnswers.length, 2);
  });



  
}