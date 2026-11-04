import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/repositories/user_repository.dart';

class FirestoreUserRepository implements UserRepository {
  final db = FirebaseFirestore.instance;

  FirestoreUserRepository();

  @override
  Future<GameUser> loadUser(String userId) async {
    final userDoc = await db.collection("users").doc(userId).get();
    final userData = userDoc.data();
    if (userData == null) {
      throw StateError("User with ID $userId was not found.");
    }

    return GameUser.fromJson(userData);
  }

  @override
  Future<void> saveUser(GameUser user) async {
    await db.collection("users").doc(user.id).set(user.toJson());
  }
}
