import 'package:flutter/material.dart';

/// This widget embodies a square of the game board.
/// 
/// Unimplemented: it will contain a Property? field for displaying a property within the square.
class SquareWidget extends StatefulWidget {
  final Color color;
  const SquareWidget({required this.color, super.key});

  @override
  State<SquareWidget> createState() => _SquareWidgetState();
}

class _SquareWidgetState extends State<SquareWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Clicking on square behaviour here
        // May need to be a callback function
      },
      child: Container(
        decoration: BoxDecoration(
          border: BoxBorder.all(width: 2),
          color: widget.color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
        )
      )
    );
  }
}