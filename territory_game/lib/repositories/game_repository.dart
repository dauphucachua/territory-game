import 'dart:core';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/player.dart';

abstract interface class GameRepository {
  Future<Game> updateGame(String gameId, void Function(Game current) change);
  Future<void> saveGame(Game game);
  Future<Game> loadGame(String gameId);
  Future<Game> joinGame(String gameId, Player player);
  Stream<Game> watchGame(String gameId);
  Stream<List<Game>> watchActiveGames(List<String> activeGameIds );
  Stream<List<Game>> watchAvailableGames(String userId);
  Future<String> newGameId();
}