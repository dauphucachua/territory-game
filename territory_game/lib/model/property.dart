import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';

 /// A data model for properties, which are territorial game pieces owned by players and placed on the board.
 /// 
 /// Probably needs an id attribute.
class Property {
  String ownerId;
  Quiz quiz;
  int health;
  int? row;
  int? col;
  
  Property({
    required this.ownerId,
    required this.quiz,
    required this.health,
    this.row,
    this.col
  });

  int get questionCount => quiz.questions.length;
  String get quizType => quiz.type; 

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      ownerId: json["ownerId"],
      quiz: Quiz.fromJson(json["quiz"]),
      health: json["health"],
      row: json["row"],
      col: json["col"],
    );
  }
  
  /// Returns a map version of the property for saving to JSON.
  Map<String, dynamic> toJson() {
    return {
      "ownerId": ownerId,
      "quiz": quiz.toJson(),
      "health": health,
      "row": row,
      "col": col
    };
  }

  /// Returns a human-readable coordinate from the row and col indices.
  Record get humanCoord {
    return (col! + 1, AppDimensions.boardCols - row!);
  }

  /// Returns a string for showing the property on the game board via its checkBoardState() method.
  /// 
  /// Probably need to create a specialised method for this so a more universal toString() override can be implemented.
  @override
  String toString() {
    return "PROP";
  }

  /// Checks if a target property is an enemy property or not.
  bool isEnemyOf(Property target) {
    return ownerId != target.ownerId;
  }

  // Checks if a target property is adjacent to (in the surrounding eight squares) the current property.
  bool isAdjacentTo(Property target) { 
    Set adjacencyVectors = {
      (0, 1), (1, 1), (1, 0), (-1, 1), (-1, 0), (-1, -1), (0, -1)
    };

    Record vector = (target.row! - row!, target.col! - col!);

    return (adjacencyVectors.contains(vector));      
  }

  // Combines the results of isEnemyOf and isAdjacentTo to decide if the current property can attack the target one.
  bool canAttack(Property target) {
    return isEnemyOf(target) && isAdjacentTo(target);
  }

  /// Reduces the current property's health by a specified amount.
  void takeDamage(int amount) {
    health -= amount;
    print("$ownerId's property took $amount damage. $health health remaining");
  }


}
