import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/square.dart';
import 'package:territory_game/view/widgets/game_screen/board/property_widget.dart';

/// This widget embodies a square of the game board.
// ignore: must_be_immutable
class SquareWidget extends StatefulWidget {
  final Square square;
  final Color color;
  PropertyWidget? property;
  
  SquareWidget({
    required this.square,
    required this.color, 
    this.property, 
    super.key
  });

  @override
  State<SquareWidget> createState() => _SquareWidgetState();
}

class _SquareWidgetState extends State<SquareWidget> {
  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    return GestureDetector(
      onTap: () {
        // Clicking on square behaviour here
        // May need to be a callback function
      },
      child: DragTarget<Property>(
        onAcceptWithDetails: (incomingProperty) async {
          if (!incomingProperty.data.isPlaced) {
            if (
              !await gameController.placeProperty(
                incomingProperty.data, 
                row: widget.square.row, 
                col: widget.square.col
              )
            ) {

              if (context.mounted) {
                final propertySubTopic = incomingProperty.data.quiz.subTopic;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("The $propertySubTopic limit for ${widget.square.area} is already full - choose a different board area.")
                  )
                );
              }
            }
          }
        },
        builder: (context, property, rejected) {
          return Container(
            decoration: BoxDecoration(
              border: BoxBorder.all(width: 2),
              color: widget.color,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: widget.property
            )
          );
        }
      )
    );
  }
}