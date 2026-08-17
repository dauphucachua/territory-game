import 'package:flutter/material.dart';
/// A custom widget used for displaying a property as an icon.
// ignore: must_be_immutable
class PropertyIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  Widget? child;

  PropertyIcon({
    this.width = 100.0,
    this.height = 100.0,
    required this.color,
    this.child,
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
      child: Center(
        child: child
      )
      
    );
  }
}