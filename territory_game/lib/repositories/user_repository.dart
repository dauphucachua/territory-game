import 'package:territory_game/model/game_user.dart';

abstract interface class UserRepository {
  Future<void> saveUser(GameUser user);
  Future<GameUser> loadUser(String userId);
}