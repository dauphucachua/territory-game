import 'package:territory_game/model/topic.dart';

/// A data model for an educational subject.
///
/// The intention of this class is allow the application to be used by a range of subjects with
/// different topics and types of questions.
class Subject {
  final String name;
  final List<Topic> topics;
  final List<String> questionTypes;

  Subject({
    required this.name,
    required this.topics,
    required this.questionTypes,
  });

  /// Loads a Subject object from a JSON file.
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json["name"],
      topics: List<Topic>.from(
        (json["topics"].map((topic) => Topic.fromJson(topic))).toList(),
      ),
      questionTypes: List<String>.from(json["questionTypes"]),
    );
  }

  /// Return a JSON-friendly Map version of the Subject.
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "topics": topics.map((topic) => topic.toJson()),
      "questionTypes": questionTypes,
    };
  }
}

// The subject data that is used for the current proof of concept stage of the application.
final Map<String, dynamic> exampleSubject = {
  "name": "Introduction to Programming",
  "topics": [
    {
      "name": "Python, variables and basic data types",
      "subTopics": [
        "Python syntax",
        "Style conventions",
        "Variables",
        "Strings",
        "Booleans",
        "Operators",
        "Floats and integers",
        "Lists",
        "Tuples",
        "Sets",
        "Dictionaries",
      ],
    },
    {
      "name": "Control flow: loops and conditions",
      "subTopics": [
        "Conditions",
        "For loops",
        "While loops",
        "Iterators",
        "Generators",
      ],
    },
    {
      "name": "Mutability & functions",
      "subTopics": [
        "Mutability",
        "References",
        "Functions",
        "Scope",
      ]
    },
    {
      "name": "Object-oriented programming",
      "subTopics": [
        "Classes and objects",
        "Attributes and methods",
        "Encapsulation",
        "Inheritance",
        "Composition",
        "Polymorphism"
      ]
    },
    {
      "name": "Input & output",
      "subTopics": [
        "Text files",
        "JSON",
        "CSV",
      ]
    },
  ],
  "questionTypes": ["multipleChoice", "codingProblem", "codingExercise"],
};

// A List of subjects used for selection in the UI.
final List<Subject> subjectList = [Subject.fromJson(exampleSubject)];
