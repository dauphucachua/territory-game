import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/repositories/game_repository.dart';

class FirestoreGameRepository implements GameRepository {
  final db = FirebaseFirestore.instance;

  FirestoreGameRepository();

  @override
  Future<Game> updateGame(String gameId, void Function(Game current) change) {
    final gameRef = db.collection("games").doc(gameId);

    return db.runTransaction((transaction) async {
      final data = (await transaction.get(gameRef)).data();
      if (data == null) throw StateError("Game $gameId does not exist.");

      final current = Game.fromJson(data);
      change(current);
      transaction.set(gameRef, current.toJson());
      return current;
    });
  }

  @override
  Future<Game> loadGame(String gameId) async {
    final gameDoc = await db.collection("games").doc(gameId).get();
    final gameData = gameDoc.data();
    if (gameData == null) {
      throw StateError("Game $gameId does not exist.");
    }

    return Game.fromJson(gameData);
  }

  @override
  Future<void> saveGame(Game game) async {
    final gameJson = game.toJson();
    await db.collection("games").doc(game.id).set(gameJson);
  }

  @override
  Stream<Game> watchGame(String gameId) {
    return db.collection("games").doc(gameId).snapshots().map((snapshot) {
      final gameData = snapshot.data();
      if (gameData == null) {
        throw StateError("Game $gameId does not exist.");
      }
      return Game.fromJson(gameData);
    });
  }

  @override
  Future<String> newGameId() async {
    return db.collection("games").doc().id;
  }

  @override
  Stream<List<Game>> watchActiveGames(List<String> activeGameIds) {
    if (activeGameIds.isEmpty) {
      return Stream.value(<Game>[]);
    }

    return db
        .collection("games")
        .where("id", whereIn: activeGameIds)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Game.fromJson(doc.data())).toList(),
        );
  }

  @override
  Stream<List<Game>> watchAvailableGames(String userId) {
    bool isAvailable(Game game) {
      return !game.players.containsKey(userId) && game.players.length == 1;
    }

    final gamesStream = db
        .collection("games")
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Game.fromJson(doc.data())).toList(),
        );

    return gamesStream.map(
      (games) => games.where((game) => isAvailable(game)).toList(),
    );
  }

  @override
  Future<Game> joinGame(String gameId, Player player) async {
    final gameRef = db.collection("games").doc(gameId);
    final userRef = db.collection("users").doc(player.id);
    
    return db.runTransaction((transaction) async {
      final gameSnapshot = await transaction.get(gameRef);
      final userSnapshot = await transaction.get(userRef);

      final gameData = gameSnapshot.data();
      
      if (gameData == null) {
        throw StateError("Game $gameId does not exist.");
      }

      if (!userSnapshot.exists) {
        throw StateError("User ${player.id} does not exist.");
      }

      final players = Map<String, dynamic>.from(gameData["players"] as Map);
      final isNotActive = gameData["isActive"] != true;

      if (players.containsKey(player.id) || players.length != 1 || isNotActive) {
        throw StateError("This game is no longer available to join.");
      }

      players[player.id] = player.toJson();
      
      final updatedData = Map<String, dynamic>.from(gameData);
      updatedData["players"] = players;

      transaction.update(gameRef, {"players": players});
      transaction.update(userRef, {
        "activeGameIds": FieldValue.arrayUnion([gameId]),
      });

      return Game.fromJson(updatedData);
    });
  }
}
