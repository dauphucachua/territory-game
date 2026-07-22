import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/property.dart';

/// A data model for the game board.
class Board {
  final int rows;
  final int cols;
  List<List<dynamic>> state;
  
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
    
    final serializedList = [];
    for (List row in state) {
      var serializedRow = [];
      for (var value in row) {
        if (value != null) {
          serializedRow.add(value.toJson());
        } else {
          serializedRow.add(null);
        }
      }
      serializedList.add(serializedRow);
    }
    
    final rowsMap = {};
    for (int i = 0; i < serializedList.length; i++) {
      rowsMap["row $i"] = serializedList[i];
    } 
    
    print(rowsMap);
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