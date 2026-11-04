import 'dart:ui';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/repositories/game_repository.dart';
import 'package:territory_game/repositories/user_repository.dart';
import 'package:territory_game/services/firebase_services/firebase_auth_service.dart';
import 'package:territory_game/services/initialization_services/session_builder.dart';

class GameBuilder {
  final SessionBuilder sessionBuilder;
  final FirebaseAuthService firebaseAuth;
  final GameRepository gameRepository;
  final UserRepository userRepository;
  
  GameBuilder({
    required this.sessionBuilder,
    required this.firebaseAuth,
    required this.gameRepository,
    required this.userRepository,  
  });

  Future<GameController> createNewGame({
    required Subject subject,
    required Topic topic,
    required String displayName,
    required Color propertyColor,
    required DateTime endTime,
  }) async {
    final user = firebaseAuth.activeUser!;
    final gameId = await gameRepository.newGameId();
    
    final game = Game(
      id: gameId,
      board: Board(
        rows: AppDimensions.boardRows,
        cols: AppDimensions.boardCols,
      ),
      players: {
        user.id: Player(
          id: user.id,
          displayName: displayName,
          propertyColor: propertyColor,        
        ),
      },
      subject: subject,
      topic: topic,
      startTime: DateTime.now(),
      endTime: endTime,
    );

    user.addGameId(game.id);
    await gameRepository.saveGame(game);
    await userRepository.saveUser(user);

    return sessionBuilder.create(game);
  }
}