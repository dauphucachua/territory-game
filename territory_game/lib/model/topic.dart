/// A data model for an educational topic, eg. "Loops and conditions".
class Topic {
  final String name;
  final int week;
  final List<String> subTopics; // This potentially needs be a List<SubTopic>, can be made later if necessary.

  const Topic({
    required this.name,
    required this.week, 
    required this.subTopics
  });

  /// Loads a Topic object from a JSON file.
  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      name: json["name"],
      week: json["week"],
      subTopics: json["subTopics"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "week": week,
      "subTopics": subTopics
    };
  }
}