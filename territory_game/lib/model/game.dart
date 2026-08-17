import 'package:intl/intl.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/model/history.dart';

/// A class that serves to group all game-state relevant classes in one place.
/// 
/// Taken together, these elements form a full representation of a single game state.
class Game {
  // Firestore-generated unique ID.
  final String id;
  // The time the game started at.
  final DateTime startTime;
  // The time that the game is set to end.
  final DateTime endTime;
  // A map of {id:Player object} for each player in the game.
  final Map<String, Player> players;
  // The game board.
  final Board board;
  // Storage for questions and events.
  final History history;
  // The chosen subject of the game.
  final Subject subject;
  // The chosen topic of the game.
  final Topic topic;
  // A bool which is true if the endTime has not been surpassed.
  bool isActive;

  Game({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.players,
    required this.board,
    History? history,
    required this.subject,
    required this.topic,
    this.isActive = true
  }) 
    : history = history ?? History();

  /// Returns the endTime as a String for UI display.
  String get endTimeAsString => DateFormat.yMMMMd().add_jm().format(endTime);

  /// Loads a Game from a JSON object.
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
      history: History.fromJson(json["history"]),
      subject: Subject.fromJson(json["subject"]),
      topic: Topic.fromJson(json["topic"]),
      isActive: json["isActive"] == "true"
    );
  }
  
  /// Returns a JSON-friendly Map representation of the Game object.
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
      "history": history.toJson(),
      "subject": subject.toJson(),
      "topic": topic.toJson(),
      "isActive": isActive.toString()
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
  
  /// Returns true if the game contains a player with the given user ID.
  bool containsPlayerWithId (String userId) {
      return players.keys.any((playerId) => playerId == userId);
  }
}