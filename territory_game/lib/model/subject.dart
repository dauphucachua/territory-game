import 'package:territory_game/model/topic.dart';

class Subject {
  final String name;
  final List topics;
  final List questionTypes;

  Subject({
    required this.name,
    required this.topics,
    required this.questionTypes
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json["name"],
      topics: (json["topics"].map((topic) => Topic.fromJson(topic))).toList(),
      questionTypes: json["questionTypes"]
    );  
  }
}