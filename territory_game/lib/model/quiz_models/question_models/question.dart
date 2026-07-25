/// An abstract class that serves as a basis for all question type classes.
abstract class Question {
  int id;
  final String question;

  Question({
    required this.id,
    required this.question
  });
}