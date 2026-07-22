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
    required this.questionTypes
  });

  /// Loads a Subject object from a JSON file.
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json["name"],
      topics: List<Topic>.from((json["topics"].map((topic) => Topic.fromJson(topic))).toList()),
      questionTypes: List<String>.from(json["questionTypes"])
    );  
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "topics": topics.map((topic) => topic.toJson()),
      "questionTypes": questionTypes
    };
  }
}

 final Map<String, dynamic> exampleSubject = {
    "name": "Introduction to Programming",
    "topics": [
      {
          "name": "Week 1: Python and basic data types",
          "week": 1,
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
              "Dictionaries"
          ]
      },
      {
          "name": "Week 2: Control flow",
          "week": 2,
          "subTopics": [
              "Conditions",
              "For loops",
              "While loops",
              "Iterators",
              "Generators",
              "List comprehensions",
              
          ]
      },
    ],
    "questionTypes": [
        "multipleChoice",
        "codingProblem",
    ]
  };

final List<Subject> subjectList = [Subject.fromJson(exampleSubject)];