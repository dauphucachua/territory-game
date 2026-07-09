import 'package:territory_game/model/game_user.dart';

 /// A data model for properties, which are territorial game pieces owned by players and placed on the board.
 /// 
 /// Probably needs an id attribute.
class Property {
  GameUser owner;
  int health;
  int x;
  int y;
  
  Property({
    required this.owner,
    required this.health,
    required this.x,
    required this.y
  });

  /// Returns a string for showing the property on the game board via its checkBoardState() method.
  /// 
  /// Probably need to create a specialised method for this so a more universal toString() override can be implemented.
  @override
  String toString() {
    return "PROP";
  }

  /// Returns a map version of the property for saving to JSON.
  Map<String, dynamic> toMap() {
    return {
      "owner": owner,
      "health": health,
      "x": x,
      "y": y
    };
  }

  /// Checks if a target property is an enemy property or not.
  bool isEnemyOf(Property target) {
    return owner != target.owner;
  }

  /// Checks if a target property is adjacent to (in the surrounding eight squares) the current property.
  bool isAdjacentTo(Property target) { 
    Set adjacencyVectors = {
      (0, 1), (1, 1), (1, 0), (-1, 1), (-1, 0), (-1, -1), (0, -1)
    };

    Record vector = (target.x - x, target.y - y);

    return (adjacencyVectors.contains(vector));      
  }

  /// Combines the results of isEnemyOf and isAdjacentTo to decide if the current property can attack the target one.
  bool canAttack(Property target) {
    return isEnemyOf(target) && isAdjacentTo(target);
  }

  /// Reduces the current property's health by a specified amount.
  void takeDamage(int amount) {
    health -= amount;
    print("$owner's property took $amount damage. $health health remaining");
  }
}
