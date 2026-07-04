import 'package:flutter/material.dart';

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