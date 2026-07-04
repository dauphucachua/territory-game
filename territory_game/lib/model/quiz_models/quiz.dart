import 'package:territory_game/model/quiz_models/question.dart';

class Quiz {
  final String id;
  final String type;
  final List<dynamic> questions;
  List<String> userAnswers;

  Quiz({
    required this.id,
    required this.type,
    required this.questions,
    List<String>? userAnswers
  }) : userAnswers = userAnswers ?? [];

  void storeUserAnswer(String answer) {
    userAnswers.add(answer);
  }
}

