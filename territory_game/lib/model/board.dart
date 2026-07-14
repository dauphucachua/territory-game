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

  /// Loads a board state from a JSON file.
  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      rows: json["rows"],
      cols: json["cols"],
      state: json["state"].map(
        (row) => row.map(
          (square) {
            if (square.isNotEmpty) {
              return square.fromJson();
            } else {
              return null;
            }
          },
        ),
      ),
    );
  } 

  /// Returns the properties of the board as a JSON-friendly map.
  Map<String, dynamic> toJson() {
    return {
      "rows": rows,
      "cols": cols,
      "state": state.map(
        (row) => row.map(
          (square) {
            if (square.isNotEmpty) {
              return square.toJson();
            } else {
              return null;
            }
          },
        ),
      ),
    };
  }

  

  /// Prints a representation of the board state.
  void checkBoardState() {
    for (int i = 0; i < state.length; i++) {
      print("$i: ${state[i].join(" ")}");
    }
  }
}