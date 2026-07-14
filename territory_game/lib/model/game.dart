import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';

class Game {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final List<Player> players;
  final Board board;
  final Subject subject;
  final Topic topic;

  const Game({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.players,
    required this.board,
    required this.subject,
    required this.topic
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json["id"],
      startTime: DateTime.parse(json["startTime"]),
      endTime: DateTime.parse(json["endTime"]),
      players: List<Player>.from(json["players"].map((player) => player.fromJson())),
      board: json["board"].fromJson(),
      subject: json["subject"].fromJson(),
      topic: json["topic"].fronJson()
    );
  }
    
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "startTime": startTime.toString(),
      "endTime": endTime.toString(),
      "players": players.map((player) => player.toJson()),
      "board": board.toJson(),
      "subject": subject.toJson(),
      "topic": topic.toJson()
    };
  }
}