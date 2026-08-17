/// An abstract class that serves as a basis for all question type classes.
abstract class Question {
  // The question number.
  int id;
  // The question as a String.
  final String question;

  Question({
    required this.id,
    required this.question
  });
}