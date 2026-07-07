import 'package:territory_game/model/topic.dart';

/// A data model for an educational subject.
/// 
/// The intention of this class is allow the application to be used by a range of subjects with 
/// different topics and types of questions.
class Subject {
  final String name;
  final List topics;
  final List questionTypes;

  Subject({
    required this.name,
    required this.topics,
    required this.questionTypes
  });

  /// Loads a Subject object from a JSON file.
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json["name"],
      topics: (json["topics"].map((topic) => Topic.fromJson(topic))).toList(),
      questionTypes: json["questionTypes"]
    );  
  }
}