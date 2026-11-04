enum QuizType {
  multipleChoice,
  codingProblem,
  codingExercise,
  theory;

  static QuizType fromString(String value) => switch (value) {
    "multipleChoice" => QuizType.multipleChoice,
    "codingProblem" => QuizType.codingProblem,
    "codingExercise" => QuizType.codingExercise,
    "theory" => QuizType.theory,
    _ => throw FormatException("Unknown quiz type: $value"),
  };

  String toReadableString() => switch (this) {
    .multipleChoice => "Multiple-choice",
    .codingProblem => "Coding problem",
    .codingExercise => "Coding exercise",
    .theory => "Theory"
  };
}
