import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/user.dart';

class GameController {
  final Board board;
  const GameController({required this.board});

  void placeProperty(int x, int y, User owner, int health) {
    board.board[x][y] = Property(owner: owner, health: health, x: x, y: y);
  }

  void attack(Property attacker, Property target, int damage) {
    if (attacker.isAttackable(target)) {
      target.takeDamage(damage);
    } else {
      print("You can't attack this property.");
    }
  }
}
