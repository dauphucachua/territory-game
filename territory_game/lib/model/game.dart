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
      players: json["players"] != null 
        ? List<Player>.from(json["players"].map(
          (player) => Player.fromJson(player)
          )) 
        : [],
      board: Board.fromJson(json["board"]),
      subject: Subject.fromJson(json["subject"]),
      topic: Topic.fromJson(json["topic"])
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

  /// Adds a player to the players list if the game is not at max capacity.
  void addPlayer(Player player) {
    if (players.length < 2) {
      players.add(player);
    } else {
      print("Game at max capacity.");
    }
  }
}