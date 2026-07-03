class Topic {
  final String name;
  final List<String> subTopics;

  const Topic({
    required this.name, 
    required this.subTopics
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      name: json["name"],
      subTopics: json["subTopics"]
    );
  }
}