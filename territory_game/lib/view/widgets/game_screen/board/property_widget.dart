import 'package:flutter/material.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/view/widgets/game_screen/property_icon.dart';

class PropertyWidget extends StatefulWidget {
  Property property;
  Color color;

  PropertyWidget({
    required this.property, 
    required this.color,
    super.key
  });

  @override
  State<PropertyWidget> createState() => _PropertyWidgetState();
}

class _PropertyWidgetState extends State<PropertyWidget> {
  @override
  Widget build(BuildContext context) {
    Property property = widget.property;

    return PropertyIcon(color: widget.color);
  }
}

