import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/property.dart';

/// A data model for the game board.
class Board {
  final int rows;
  final int cols;
  // A 2D List that serves as a source of truth for the position. 
  // Items are either null or Property objects.
  List<List<dynamic>> state;
  // Stores the sub-topic limit per area.
  final Map<String, num> areaLimits = {
    "The Dojo": double.infinity,
    "The Arena": 4,
    "The Battleground": 2,
    "The Pit": 1
  };
  
  Board({
    required this.rows,
    required this.cols,
    List<List<dynamic>>? state
  }) 
  : state = state ?? List<List>.generate( // Generates an empty 2d list if no pre-existing board state is provided
    rows, (x) => List<dynamic>.generate(
      cols, (y) => null
    ), 
    growable: false
  );


  /// Returns the name of the board area given the row and col.
  String getBoardArea(int row, int col) {
    if (row >= 4 && row <= 5 && col >= 4 && col <= 5) {
      return "The Pit";
    } else if (row >= 3 && row <= 6 && col >= 3 && col <= 6) {
      return "The Battleground";
    } else if (row >= 2 && row <= 7 && col >= 2 && col <= 7) {
      return "The Arena";
    } else {
      return "The Dojo";
    }
  }
  
  /// Returns the number of control points a given Player has.
  int getControlPointsByPlayer(Player player) {
    int points = 0;
    for (List row in state) {
      for (var item in row) {
        if (item is Property && item.ownerId == player.id) {
          points += item.controlPoints;
        }
      }
    }
    return points;
  }

  /// Loads a board state from a JSON file.
  factory Board.fromJson(Map<String, dynamic> json) {
    final rowsList = [];
    for (int i = 0; i < json["state"].values.length; i++) {
      var currentRow = json["state"]["row $i"];
      final currentRowValues = [];
      for (var value in currentRow) {
        if (value != null) {
          currentRowValues.add(Property.fromJson(value));
        } else {
          currentRowValues.add(null);
        }
      }
      rowsList.add(currentRowValues);
      }
    
    return Board(
      rows: json["rows"],
      cols: json["cols"],
      state: List<List<dynamic>>.from(rowsList),
    );
  } 

  /// Returns the properties of the board as a JSON-friendly map.
  Map<String, dynamic> toJson() {
    // Serializes any Property objects on the board and keeps them in a List of their rows.
    final serializedList = [];
    for (List row in state) {
      var serializedRow = [];
      for (var item in row) {
        if (item is Property) {
          serializedRow.add(item.toJson());
        } else {
          serializedRow.add(null);
        }
      }
      serializedList.add(serializedRow);
    }
    
    // Create a Firestore-compatible (no nested Lists) data structure - eg. {"row 1": [row contents]}.
    final rowsMap = {};
    for (int i = 0; i < serializedList.length; i++) {
      rowsMap["row $i"] = serializedList[i];
    } 
    
    return {
      "rows": rows,
      "cols": cols,
      "state": rowsMap
    }; 
  }

  /// Prints a representation of the board state.
  void checkBoardState() {
    for (int i = 0; i < state.length; i++) {
      print("$i: ${state[i].join(" ")}");
    }
  }
}