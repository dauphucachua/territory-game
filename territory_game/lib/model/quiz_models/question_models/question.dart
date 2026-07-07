/// An abstract class that serves as a basis for all question type classes.
abstract class Question {
  final int id;
  final String question;

  const Question({
    required this.id,
    required this.question
  });
}