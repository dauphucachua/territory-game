import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';

class Quiz {

  final String type;
  final List<dynamic> questions;
  List<String> userAnswers;

  Quiz({
    required this.type,
    required this.questions,
    List<String>? userAnswers
  }) : userAnswers = userAnswers ?? [];

  Map<dynamic, dynamic> get questionAnswerMap {

    if (questions.length == userAnswers.length) {
      final result = {};
      
      for (int i = 0; i < questions.length;) {
        var questionNo = (i + 1).toString();
        
        result["question $questionNo"] = {
          "question": questions[i],
          "userAnswer": userAnswers[i] 
        };

        return result;
      }
    } 

    throw "Number of questions != number of answers";

    
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    if (json["quizType"] == "multipleChoice") {
      return Quiz(
      type: json["quizType"],
      questions: (
        json["questions"].map((question) => MultipleChoiceQuestion.fromJson(question))).toList());
    } else {
      throw "Quiz type not recognised";
    }
  }

  @override toString() {
    return """
      Quiz type: $type\n
      Questions: $questions
    """;
  }

  void storeUserAnswer(String answer) {
    userAnswers.add(answer);
  }
}

