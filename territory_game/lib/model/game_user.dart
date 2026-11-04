import 'package:firebase_auth/firebase_auth.dart';

/// A data model for the users who play the game.
class GameUser {
  // Firestore-generated unique id.
  final String id;
  final String email;
  // List of user's active game IDs.
  List<String> activeGameIds;

  GameUser({required this.id, required this.email, List<String>? activeGameIds})
    : activeGameIds = activeGameIds ?? [];

  /// Loads a GameUser from a JSON object.
  factory GameUser.fromJson(Map<String, dynamic> json) {
    return GameUser(
      id: json["id"],
      email: json["email"],
      activeGameIds: List<String>.from(json["activeGameIds"])
    );
  }

  /// Return a JSON-friendly Map version of the GameUser object.
  Map<String, dynamic> toJson() {
    return {"id": id, "email": email, "activeGameIds": activeGameIds};
  }

  /// Adds a game ID to the activeGameIds List.
  void addGameId(String gameId) {
    activeGameIds.add(gameId);
  }
}
