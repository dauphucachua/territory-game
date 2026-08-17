/// A data class representing a board square, used for building the board in the UI.
class Square {
  final int row;
  final int col;
  final String area;
  final int points;

  const Square({
    required this.row,
    required this.col,
    required this.area,
    required this.points
  });
}