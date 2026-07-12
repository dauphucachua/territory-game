import 'package:flutter/material.dart';

class PropertyIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const PropertyIcon({
    this.width = 100.0,
    this.height = 100.0,
    required this.color,
    super.key,
    
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
        color: color,
      ),
      width: width,
      height: height,
      
    );
  }
}