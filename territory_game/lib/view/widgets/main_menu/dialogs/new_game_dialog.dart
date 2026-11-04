import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/repositories/subject_repository.dart';
import 'package:territory_game/services/initialization_services/game_builder.dart';
import 'package:territory_game/view/screens/game_screen_wrapper.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';

/// A dialog box that provides setting selection for creating a new game.
class NewGameDialog extends StatefulWidget {
  const NewGameDialog({super.key});

  @override
  State<NewGameDialog> createState() => _NewGameDialogState();
}

class _NewGameDialogState extends State<NewGameDialog> {
  late final Future<List<Subject>> subjectsFuture;

  // Nullable fields for assigning the user's selections.
  Subject? selectedSubject;
  Topic? selectedTopic;
  Color? selectedColor;
  DateTime? selectedEndTime;
  String? selectedDisplayName;

  final nameController = TextEditingController();

  final Map<String, Color> propertyColorsMap = {
    "Black": AppColors.propertyBlack,
    "White": AppColors.propertyWhite,
  };

  final Map<String, Duration> durationMap = {
    "10 seconds": Duration(seconds: 10),
    "1 day": Duration(days: 1),
    "3 days": Duration(days: 3),
    "1 week": Duration(days: 7),
  };

  

  /// Checks that all of the options have been selected.
  bool allOptionsSelected() {
    return selectedSubject != null &&
        selectedTopic != null &&
        selectedColor != null &&
        selectedEndTime != null &&
        selectedDisplayName != null;
  }

  /// Creates a GameController with the selections that have been made by the user.
  Future<GameController> createGameController() async {
    final gameController = await context.read<GameBuilder>().createNewGame(
      subject: selectedSubject!,
      topic: selectedTopic!,
      displayName: selectedDisplayName!,
      propertyColor: selectedColor!,
      endTime: selectedEndTime!,
    );

    return gameController;
  }

  @override
  void initState() {
    super.initState();
    subjectsFuture = context.read<SubjectRepository>().getSubjects();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.darkBlue,
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.cornerRadius),
      child: SizedBox(
        width: 700,
        height: 600,
        child: Column(
          mainAxisAlignment: .start,
          children: [
            Row(mainAxisAlignment: .end, children: [CloseWindowButton()]),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  TitleText(text: "New game"),
                  SizedBox(height: 40.0),
                  // Subject selection
                  FutureBuilder<List<Subject>>(
                    future: subjectsFuture,
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.hasError) {
                        return const Text("Could not load subjects.");
                      }
                      if (!asyncSnapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      final subjects = asyncSnapshot.data!;
                      return SelectionDropdownRow(
                        instructionText: "Select a subject",
                        dropdownItems: List<DropdownMenuEntry>.from(
                          subjects.map(
                            (subject) => DropdownMenuEntry(
                              value: subject,
                              label: subject.name,
                            ),
                          ),
                        ),
                        onItemSelected: (subject) {
                          setState(() {
                            selectedSubject = subject;
                            selectedTopic = null;
                          });
                        },
                      );
                    }
                  ),
                  SizedBox(height: 32.0),
                  // Topic selection
                  SelectionDropdownRow(
                    instructionText: "Select a topic",
                    dropdownItems:
                        selectedSubject !=
                            null // If a subject has been selected
                        ? List<DropdownMenuEntry>.from(
                            selectedSubject!.topics.map(
                              // Populate the dropdown with subject.topics items
                              (topic) => DropdownMenuEntry(
                                value: topic,
                                label: topic.name,
                              ),
                            ),
                          )
                        : [
                            DropdownMenuEntry(
                              value: null,
                              label: "Select a subject first",
                            ),
                          ],
                    onItemSelected: (topic) {
                      setState(() {
                        selectedTopic = topic;
                      });
                    },
                  ),
                  SizedBox(height: 32.0),
                  // Property color selection
                  SelectionDropdownRow(
                    instructionText: "Select a property color",
                    dropdownItems: List<DropdownMenuEntry>.from(
                      propertyColorsMap.keys.toList().map(
                        (colorName) => DropdownMenuEntry(
                          value: propertyColorsMap[colorName],
                          label: colorName,
                        ),
                      ),
                    ),
                    onItemSelected: (color) {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                  ),
                  SizedBox(height: 32.0),
                  // Game duration selection
                  SelectionDropdownRow(
                    instructionText: "Select a game duration",
                    dropdownItems: List<DropdownMenuEntry>.from(
                      durationMap.keys.toList().map(
                        (durationName) => DropdownMenuEntry(
                          value: DateTime.now().add(durationMap[durationName]!),
                          label: durationName,
                        ),
                      ),
                    ),
                    onItemSelected: (duration) {
                      setState(() {
                        selectedEndTime = duration;
                      });
                    },
                  ),
                  SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      SizedBox(
                        width: 300,
                        // Textfield for display names
                        child: TextField(
                          controller: nameController,
                          style: TextStyle(color: AppColors.opaqueWhite),
                          decoration: InputDecoration(
                            hintText: "Enter display name",
                            hintStyle: TextStyle(color: AppColors.opaqueWhite),
                          ),
                        ),
                      ),
                      // Start new game button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.opaqueWhite,
                          padding: EdgeInsets.all(16.0),
                        ),
                        onPressed: () async {
                          selectedDisplayName = nameController.text.trim();

                          if (!allOptionsSelected()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Make sure all options are selected.",
                                ),
                              ),
                            );
                            return;
                          }

                          final navigator = Navigator.of(context);

                          try {
                            final gameController = await createGameController();

                            if (!context.mounted) return;

                            navigator.pop();
                            navigator.push(
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => gameController,
                                  child: const GameScreenWrapper(),
                                ),
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Error: $e",
                                ),
                              ),
                            );
                          }
                        },

                        child: Text(
                          "Start new game",
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A custom widget for a row with a text label and a dropdown menu.
class SelectionDropdownRow extends StatelessWidget {
  final String instructionText;
  final List<DropdownMenuEntry> dropdownItems;
  final ValueChanged onItemSelected;

  const SelectionDropdownRow({
    required this.instructionText,
    required this.dropdownItems,
    required this.onItemSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        SubtitleText(text: instructionText),
        DropdownMenu(
          onSelected: onItemSelected,
          dropdownMenuEntries: dropdownItems,
          textStyle: TextStyle(color: AppColors.opaqueWhite),
          width: 250.0,
        ),
      ],
    );
  }
}
