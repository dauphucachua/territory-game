import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';

class Game {
  final DateTime startTime;
  final DateTime endTime;
  final List<Player> players;
  final Board board;
  final Subject subject;
  final Topic topic;

  const Game({
    required this.startTime,
    required this.endTime,
    required this.players,
    required this.board,
    required this.subject,
    required this.topic
  })

  
  
}