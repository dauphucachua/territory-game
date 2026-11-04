import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_type.dart';

 /// A data model for properties, which are game pieces owned by players and placed on the board.
class Property {
  // The unique id of the property's current owner.
  String ownerId;
  // A quiz is stored in a property on creation.
  Quiz quiz;
  // The property's health, given by the quiz score.
  int health;
  bool isBattling;
  int? row;
  int? col;
  
  Property({
    required this.ownerId,
    required this.quiz,
    required this.health,
    this.isBattling = false,
    this.row,
    this.col
  });

  int get questionCount => quiz.questions.length;
  QuizType get quizType => quiz.type;
  
  /// Returns true if the property has the maximum score for all questions stored in it.
  /// 
  /// Allows the bonus question mechanism to be triggered when attacking.
  bool get hasPerfectHealth {
    if (quiz.type == QuizType.multipleChoice && quiz.questions.length * 20 == health) {
      return true;
    } else if (quiz.type == QuizType.codingProblem && quiz.questions.length * 100 == health) {
      return true;
    }
    return false;
  }
  
  /// Gets the board area of the property as a String.
  String get boardArea {
    if (row != null && col != null) {
      if (row! >= 4 && row! <= 5 && col! >= 4 && col! <= 5) {
        return "The Pit";
      } else if (row! >= 3 && row! <= 6 && col! >= 3 && col! <= 6) {
        return "The Battleground";
      } else if (row! >= 2 && row! <= 7 && col! >= 2 && col! <= 7) {
        return "The Arena";
      } else {
        return "The Dojo";
      }
    } throw "The property has not been placed (Board Area Failure).";
  }

  /// Gets the number of control points that the property is currently securing.
  int get controlPoints {
    switch (boardArea) {
      case "The Pit": return 10;
      case "The Battleground": return 5;
      case "The Arena": return 2;
      case "The Dojo": return 1;
    } throw "The property has not been placed (Control Points Failure).";
  } 

  /// Loads a Property from a JSON object.
  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      ownerId: json["ownerId"],
      quiz: Quiz.fromJson(json["quiz"]),
      health: json["health"],
      isBattling: json["isBattling"] == "true",
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
      "isBattling": isBattling.toString(),
      "row": row,
      "col": col
    };
  }

  /// Returns true if property has a position on the board.
  bool get isPlaced {
    return row != null && col != null;
  }

  /// Returns a human-readable coordinate from the row and col indices.
  Record get humanCoord {
    return (col! + 1, AppDimensions.boardCols - row!);
  }

  /// Returns a string for showing the property on the game board via its checkBoardState() method.
  @override
  String toString() {
    return "PROP";
  }

  /// Checks if a target property is an enemy property or not.
  bool isEnemyOf(Property target) {
    return ownerId != target.ownerId;
  }

  /// Checks if a target property is adjacent to (in the surrounding eight squares of) the current property.
  bool isAdjacentTo(Property target) { 
    Set adjacencyVectors = {
      (0, 1), (1, 1), (1, 0), (1, -1), (-1, 1), (-1, 0), (-1, -1), (0, -1)
    };

    Record vector = (target.row! - row!, target.col! - col!);

    return (adjacencyVectors.contains(vector));      
  }

  /// Combines the results of isEnemyOf and isAdjacentTo to decide if the current property can attack the target one.
  ///
  /// Both properties also must not be currently involved in a battle.
  bool canAttack(Property target) {
    return isEnemyOf(target) && isAdjacentTo(target) && !isBattling && !target.isBattling;
  }
}
