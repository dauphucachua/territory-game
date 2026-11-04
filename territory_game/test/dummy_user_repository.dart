import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/repositories/user_repository.dart';

class DummyUserRepository implements UserRepository {
  final Map<String, GameUser> users = {};

  @override
  Future<GameUser> loadUser(String userId) async {
    final user = users[userId];
    if (user == null) throw StateError("User $userId not found.");
    return user;
  }

  @override
  Future<void> saveUser(GameUser user) async {
    users[user.id] = user;
  } 
}