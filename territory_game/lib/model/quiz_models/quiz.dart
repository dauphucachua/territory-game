import 'package:territory_game/model/quiz_models/question_models/multiple_choice_question.dart';

class Quiz {

  final String type;
  final List<dynamic> questions; // This should be List<Question>, having type issues, need to return to this
  List<String> userAnswers;

  Quiz({
    required this.type,
    required this.questions,
    List<String>? userAnswers
  }) : userAnswers = userAnswers ?? []; 
  
  
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

  Map<dynamic, dynamic> get questionAnswerMap {

    if (questions.length == userAnswers.length) {
      final result = {};
      
      for (int i = 0; i < questions.length; i++) {
        final questionNo = questions[i].id;
        final question = questions[i].question;
        final userAnswer = userAnswers[i]; 
        
        result["question $questionNo"] = {
          "question": question,
          "userAnswer": userAnswer 
        };

        return result;
      }
    }  

    throw "Number of questions != number of answers";
  }

  String toStringForFeedbackPrompt() {
    if (userAnswers.length == questions.length) {
      final String header = "Quiz type: $type\nQuestions:\n\n";
      String body = "";
      for (int i = 0; i < questions.length; i++) {
        body += "${questions[i].toString()}\n";
        body += "${userAnswers[i]}\n\n";
      }

      return header + body;
    }

    throw "Number of questions != number of answers";
  }

 

  @override toString() {
    return """
      Quiz type: $type\n
      Questions: $questions\n
    """;
  }

  void storeUserAnswer(String answer) {
    userAnswers.add(answer);
  }
}

