import 'package:firebase_auth/firebase_auth.dart';
import 'package:territory_game/model/game.dart';

/// A data model for the users who play the game.
class GameUser {
  final String id;
  final String email;
  List<String> activeGameIds;
  
  GameUser({
    required this.id,
    required this.email,
    List<String>? activeGameIds
  }) : activeGameIds = activeGameIds ?? [];

  factory GameUser.fromFirebaseCredential(UserCredential credential) {
    return GameUser(
      id: credential.user!.uid,
      email: credential.user!.email!,
    );
  }

  factory GameUser.fromJson(Map<String, dynamic> json) {
    return GameUser(
      id: json["id"],
      email: json["email"],
      activeGameIds: List<String>.from(json["activeGameIds"])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "activeGameIds": activeGameIds
    };
  }

  void addGameId(String gameId) {
    activeGameIds.add(gameId);
  }
}