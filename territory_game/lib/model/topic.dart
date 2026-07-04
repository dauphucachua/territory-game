class Topic {
  final String name;
  final int week;
  final List<String> subTopics;

  const Topic({
    required this.name,
    required this.week, 
    required this.subTopics
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      name: json["name"],
      week: json["week"],
      subTopics: json["subTopics"]
    );
  }
}