import 'package:intl/intl.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';

class Game {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final Map<String, Player> players;
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

  String get endTimeAsString => DateFormat.yMMMMd().add_jm().format(endTime);

  factory Game.fromJson(Map<String, dynamic> json) {
    Map<String, Player> players = {};
    if (json["players"] != null) {
      for (String id in json["players"].keys) {
      players[id] = Player.fromJson(json["players"][id]);
      }
    }
    
    return Game(
      id: json["id"],
      startTime: DateTime.parse(json["startTime"]),
      endTime: DateTime.parse(json["endTime"]),
      players: json["players"] != null ? players : {},
      board: Board.fromJson(json["board"]),
      subject: Subject.fromJson(json["subject"]),
      topic: Topic.fromJson(json["topic"])
    );
  }
    
  Map<String, dynamic> toJson() {
    var playersMap = {};
    for (String id in players.keys) {
      playersMap[id] = players[id]!.toJson();
    }

    return {
      "id": id,
      "startTime": startTime.toString(),
      "endTime": endTime.toString(),
      "players": playersMap,
      "board": board.toJson(),
      "subject": subject.toJson(),
      "topic": topic.toJson()
    };
  }

  /// Adds a player to the players list if the game is not at max capacity.
  void addPlayer(Player player) {
    if (players.length < 2) {
      players[player.id] = player;
    } else {
      print("Game at max capacity.");
    }
  }
  
  bool containsPlayerWithId (String userId) {
      return players.keys.any((playerId) => playerId == userId);
  }
}