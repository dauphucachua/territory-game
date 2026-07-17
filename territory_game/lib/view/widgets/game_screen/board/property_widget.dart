import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/view/widgets/game_screen/UI/dialogs/quiz_dialog.dart';
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
    final gameController = context.watch<GameController>();
    Property property = widget.property;
    
    if (property.ownerId == gameController.activeUser.id) {
      return Draggable(
        data: widget.property,
        feedback: Text("Attack!", style: TextStyle(color: AppColors.heartRed)), 
        child: PropertyIcon(color: widget.color),
      );
    } else {
      return DragTarget<Property>(
        onAcceptWithDetails: (details) {
          Property attacker = details.data;
          Property defender = property;
          if (attacker.canAttack(defender)) {
            showDialog(
              context: context, 
              builder: (BuildContext context) => AlertDialog(
                title: Text("Attack initiated", textAlign: .center),
                content: Text("Attack property at ${defender.humanCoord}?", textAlign: .center,),
                backgroundColor: AppColors.backgroundCream,
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel", style: TextStyle(color: AppColors.heartRed),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => QuizDialog(
                          quiz: defender.quiz,
                        ),
                      ); 
                    },
                    child: Text("Confirm and begin task", style: TextStyle(color: Colors.blueAccent))
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, property, rejected) {
          return PropertyIcon(color: widget.color);
        }
      );
    }
  }
}

