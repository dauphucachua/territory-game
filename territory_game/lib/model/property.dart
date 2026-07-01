import 'package:territory_game/model/user.dart';

class Property {
  User owner;
  int health;
  int x;
  int y;
  
  Property({
    required this.owner,
    required this.health,
    required this.x,
    required this.y
  });

  @override
  String toString() {
    return "PROP";
  }

  Map<String, dynamic> toMap() {
    return {
      "owner": owner,
      "health": health,
      "x": x,
      "y": y
    };
  }

  bool isEnemy(Property target) {
    return owner != target.owner;
  }

  bool isAdjacent(Property target) { 
    Set adjacencyVectors = {
      (0, 1), (1, 1), (1, 0), (-1, 1), (-1, 0), (-1, -1), (0, -1)
    };

    Record vector = (target.x - x, target.y - y);
    print(vector);

    return (adjacencyVectors.contains(vector));      
  }

  bool isAttackable(Property target) {
    return isEnemy(target) && isAdjacent(target);
  }

  void takeDamage(int amount) {
    health -= amount;
    print("$owner's property took $amount damage. $health health remaining");
  }
}
