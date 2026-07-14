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
          "name": "Variables",
          "week": 1,
          "subTopics": [
              "Naming",
              "Conventions",
              "Values"
          ]
      },
      {
          "name": "Functions",
          "week": 2,
          "subTopics": [
              "Scope",
              "Iteration"
          ]
      },
    ],
    "questionTypes": [
        "multipleChoice",
        "theory",
        "codingProblem",
        "codingExercise"
    ]
  };

final List<Subject> subjectList = [Subject.fromJson(exampleSubject)];