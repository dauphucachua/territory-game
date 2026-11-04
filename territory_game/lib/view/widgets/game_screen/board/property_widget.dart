import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/quiz_type.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';
import 'package:territory_game/view/widgets/game_screen/UI/dialogs/quiz_dialog.dart';
import 'package:territory_game/view/widgets/game_screen/property_icon.dart';

/// A widget that visually represents a property on the board.
class PropertyWidget extends StatefulWidget {
  // PropertyWidget is mapped to a Property object.
  final Property property;
  final Color color;
  final double size;

  const PropertyWidget({
    required this.property,
    required this.color,
    required this.size,
    super.key,
  });

  @override
  State<PropertyWidget> createState() => _PropertyWidgetState();
}

class _PropertyWidgetState extends State<PropertyWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    final Property property = widget.property;

    /// Builds the string displayed on the property's hoverable tooltip.
    String buildStatString() {
      final owner = gameController.game.players[property.ownerId]!.displayName;
      final health = property.health;
      final quizType = property.quizType.name;
      final subTopic = property.quiz.subTopic;
      final questionCount = property.quiz.questions.length;
      final controlPoints = property.controlPoints;
      final battling = property.isBattling ? "Yes" : "No";

      return "Owner: $owner\nHealth: $health\nQuiz type: $quizType\nSub-topic: $subTopic\nQuestion count: $questionCount\nControl points: $controlPoints\nCurrently battling: $battling";
    }

    return Tooltip(
      message: buildStatString(),
      verticalOffset: -175.0,
      padding: .all(15.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(214, 25, 32, 33),
        border: .all(color: const Color.fromARGB(197, 255, 255, 255)),
        borderRadius: AppDimensions.cornerRadius,
      ),
      child: property.ownerId == gameController.activeUser.id
          // Makes the property draggable as an attacker.
          ? Draggable(
              data: widget.property,
              feedback: Text(
                "Attack!",
                style: TextStyle(color: AppColors.heartRed),
              ),
              // Makes the property clickable so it can be strengthened.
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => StatefulBuilder(
                      builder: (context, setState) => AlertDialog(
                        title: Text("Strengthen property?"),
                        content: Text(
                          "Strengthen your property by answering questions on the same topic",
                        ),
                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                        actions: [
                          _isLoading
                              ? Container()
                              : TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() => _isLoading = false);
                                  },
                                ),
                          _isLoading
                              ? Center(
                                  child: LoaderWithText(
                                    text: "Getting quiz from chatbot...",
                                    color: AppColors.darkBlue,
                                  ),
                                )
                              : TextButton(
                                  child: Text("Confirm and begin quiz"),
                                  onPressed: () async {
                                    setState(() => _isLoading = true);
                                    final newQuiz = await gameController
                                        .getQuiz(
                                          widget.property.quiz.subTopic,
                                          widget.property.quiz.type,
                                          widget.property.quiz.type ==
                                                  QuizType.multipleChoice
                                              ? 5
                                              : 1,
                                          widget.property.quiz.difficulty,
                                        );
                                    setState(() => _isLoading = false);

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ChangeNotifierProvider.value(
                                              value: gameController,
                                              child: QuizDialog(
                                                quiz: newQuiz,
                                                mode: .strengthen,
                                                propertyToStrengthen:
                                                    widget.property,
                                              ),
                                            ),
                                      );
                                    }
                                  },
                                ),
                        ],
                      ),
                    ),
                  );
                },
                child: PropertyIcon(
                  color: widget.color,
                  // Displays an 'X' if property is currently battling.
                  child: widget.property.isBattling
                      ? Icon(
                          Icons.close,
                          size: 100,
                          color: const Color.fromARGB(238, 199, 21, 21),
                        )
                      : null,
                ),
              ),
            )
          // Makes the property a drag target so that it can accept an attack.
          : DragTarget<Property>(
              onAcceptWithDetails: (details) {
                Property attacker = details.data;
                Property defender = property;
                if (attacker.canAttack(defender)) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        "Attack initiated",
                        textAlign: .center,
                        style: TextStyle(color: AppColors.opaqueWhite),
                      ),
                      // If the defender has perfect health, offer to add a hard bonus question.
                      content: defender.hasPerfectHealth
                          ? Text(
                              "The property at ${defender.humanCoord} has perfect health. "
                              "\nThere will be a difficult bonus question at the end of the activity."
                              "\nContinue?",
                              textAlign: .center,
                              style: TextStyle(color: AppColors.opaqueWhite),
                            )
                          : Text(
                              "Attack property at ${defender.humanCoord}?",
                              textAlign: .center,
                              style: TextStyle(color: AppColors.opaqueWhite),
                            ),
                      backgroundColor: AppColors.darkBlue,
                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: AppColors.heartRed),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (defender.hasPerfectHealth) {
                              setState(() => _isLoading = true);
                              await gameController.addBonusQuestionToQuiz(
                                defender.quiz,
                              );
                              setState(() => _isLoading = false);
                            }

                            if (context.mounted) {
                              Navigator.pop(context);
                              gameController.setBattle(attacker, defender);
                              // Open a QuizDialog in attack mode with the defender's quiz data.
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) =>
                                    ChangeNotifierProvider.value(
                                      value: gameController,
                                      child: QuizDialog(
                                        quiz: defender.quiz,
                                        mode: .attack,
                                      ),
                                    ),
                              );
                            }
                          },
                          child: Text(
                            "Confirm and begin task",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              builder: (context, property, rejected) {
                return PropertyIcon(
                  color: widget.color,
                  child: widget.property.isBattling
                      ? Icon(
                          Icons.close,
                          size: 100,
                          color: const Color.fromARGB(238, 199, 21, 21),
                        )
                      : null,
                );
              },
            ),
    );
  }
}
