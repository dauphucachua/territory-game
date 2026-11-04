import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/repositories/game_repository.dart';

class DummyGameRepository implements GameRepository {
  Game storedGame;
  DummyGameRepository(this.storedGame);

  @override
  Future<Game> joinGame(String gameId, Player player) async {
    final players = storedGame.players;

    if (players.containsKey(player.id) || players.length != 1 || !storedGame.isActive) {
        throw StateError("This game is no longer available to join.");
    }

    storedGame.addPlayer(player);
    return storedGame;
  }

  @override
  Future<Game> loadGame(String gameId) {
    // TODO: implement loadGame
    throw UnimplementedError();
  }

  @override
  Future<String> newGameId() {
    // TODO: implement newGameId
    throw UnimplementedError();
  }

  @override
  Future<void> saveGame(Game game) {
    // TODO: implement saveGame
    throw UnimplementedError();
  }

  @override
  Future<Game> updateGame(String gameId, void Function(Game current) change) async {
    if (gameId != storedGame.id) {
      throw StateError("Unexpected game ID: $gameId");
    }

    final currentGame = Game.fromJson(storedGame.toJson());
    change(currentGame);
    storedGame = currentGame;
    return Game.fromJson(currentGame.toJson());
  }

  @override
  Stream<List<Game>> watchActiveGames(List<String> activeGameIds) {
    // TODO: implement watchActiveGames
    throw UnimplementedError();
  }

  @override
  Stream<List<Game>> watchAvailableGames(String userId) {
    // TODO: implement watchAvailableGames
    throw UnimplementedError();
  }

  @override
  Stream<Game> watchGame(String gameId) {
    // TODO: implement watchGame
    throw UnimplementedError();
  }

  
}