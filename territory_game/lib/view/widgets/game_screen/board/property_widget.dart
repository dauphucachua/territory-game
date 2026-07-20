import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/view/widgets/game_screen/UI/dialogs/quiz_dialog.dart';
import 'package:territory_game/view/widgets/game_screen/property_icon.dart';

class PropertyWidget extends StatefulWidget {
  final Property property;
  final Color color;

  const PropertyWidget({
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

    String buildStatString() {
      final owner = gameController.game.players[property.ownerId]!.displayName;
      final health = property.health;
      final quizType = property.quizType;
      final subTopic = property.quiz.subTopic;
      final questionCount = property.quiz.questions.length;
      final controlPoints = property.controlPoints;

      return "Owner: $owner\nHealth: $health\nQuiz type: $quizType\nSub-topic: $subTopic\nQuestion count: $questionCount\nControl points: $controlPoints";    
    }

    return Tooltip(
      message: buildStatString(),
      verticalOffset: -175.0,
      padding: .all(15.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(214, 25, 32, 33),
        border: .all(
          color: const Color.fromARGB(197, 255, 255, 255)
        ),
        borderRadius: AppDimensions.cornerRadius,
      ),
      child: property.ownerId == gameController.activeUser.id
      ? Draggable(
        data: widget.property,
        feedback: Text("Attack!", style: TextStyle(color: AppColors.heartRed)), 
        child: PropertyIcon(color: widget.color),
      )
      : DragTarget<Property>(
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
                      gameController.game.battle.setBattlers(
                        attacker: attacker,
                        defender: defender
                      );
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => ChangeNotifierProvider.value(
                          value: gameController,
                          child: QuizDialog(
                            quiz: defender.quiz,
                            mode: .attack
                          ),
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
      ),
    );
  }
}

