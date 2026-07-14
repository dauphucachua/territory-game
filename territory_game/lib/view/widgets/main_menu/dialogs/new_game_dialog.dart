import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';
import 'package:territory_game/services/chatbot_services/mistral_api_service.dart';
import 'package:territory_game/services/firebase_services/firebase_auth_service.dart';
import 'package:territory_game/services/timer_service/timer_service.dart';
import 'package:territory_game/view/screens/game_screen.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';

class NewGameDialog extends StatefulWidget {
  final FirebaseAuthService firebaseAuth;
  final List<Subject> subjectOptions = subjectList;

  NewGameDialog({
    required this.firebaseAuth,
    super.key
  });

  @override
  State<NewGameDialog> createState() => _NewGameDialogState();
}

class _NewGameDialogState extends State<NewGameDialog> {
  Subject? selectedSubject;
  Topic? selectedTopic;
  Color? selectedColor;
  DateTime? selectedEndTime;
  
  final Map<String, Color> propertyColorsMap = {
    "Black": AppColors.propertyBlack, 
    "White": AppColors.propertyWhite
  };

  final Map<String, Duration> durationMap = {
    "10 seconds": Duration(seconds: 10),
    "1 day": Duration(days: 1),
    "3 days": Duration(days: 3),
    "1 week": Duration(days: 7)
  };
  
  /// Starts a new game once all necessary selections have been made by the user.
  void startGame() {
    if (
      selectedSubject != null 
      && selectedTopic != null
      && selectedColor != null
      && selectedEndTime != null
    ) {
      // Convert GameUser into a Player object.
      final player = Player.newPlayerFromUser(widget.firebaseAuth.activeUser!);

      // Initialize Board object.
      final board = Board(
        rows: AppDimensions.boardRows,
        cols: AppDimensions.boardCols
      );

      // Capture the start time of the game.
      final startTime = DateTime.now();

      // Initialize Game object.
      final game = Game(
        board: board,
        players: [player],
        subject: selectedSubject!,
        topic: selectedTopic!, 
        startTime: startTime,
        endTime: selectedEndTime!,
      );

      final timer = TimerService(
        endTime: game.endTime
      );

      // Initialize ChatbotApi services.
      final chatbotProvider = ChatbotApiProvider();
      final mistralClient = MistralApiService(
        config: ChatbotConfig());
      chatbotProvider.addChatbot(mistralClient);


      // Initialize GameController with objects passed in.
      final gameController = GameController(
        firebaseAuth: widget.firebaseAuth,
        chatbotProvider: chatbotProvider,
        timer: timer,
        game: game,
      );

      gameController.timer.runTimer(() => showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text("The game is over"))));

      // Push to the main game screen.
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:(context) => ChangeNotifierProvider(
            create: (context) => gameController,
            child: const GameScreen()
          )
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.darkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.cornerRadius,
      ),
      child: SizedBox(
        width: 700,
        height: 600,
        child: Column(
          mainAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .end,
              children:[CloseWindowButton()],
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  TitleText(text: "New game"),
                  SizedBox(height: 40.0), 
                  SelectionDropdownRow(
                    instructionText: "Select a subject",
                    dropdownItems: List<DropdownMenuEntry>.from(
                      widget.subjectOptions.map(
                        (subject) => DropdownMenuEntry(
                          value: subject, 
                          label: subject.name,
                        ),
                      ),
                    ),
                    onItemSelected: (subject) {
                      setState(() {
                        selectedSubject = subject;
                      });
                    },
                  ),
                  SizedBox(height: 32.0),
                  SelectionDropdownRow(
                    instructionText: "Select a topic", 
                    dropdownItems: selectedSubject != null // If a subject has been selected
                    ? List<DropdownMenuEntry>.from(
                      selectedSubject!.topics.map( // Populate the dropdown with subject.topics items
                        (topic) => DropdownMenuEntry(
                          value: topic, 
                          label: topic.name,
                        ),
                      ),
                    )
                    : [DropdownMenuEntry(value: null, label: "Select a subject first")], 
                    onItemSelected: (topic) {
                      setState(() {
                        selectedTopic = topic;
                      });
                    }
                  ),
                  SizedBox(height: 32.0),
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
                      print(selectedColor);
                    }
                  ),
                  SizedBox(height: 32.0),
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
                      print(duration);
                    }
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.opaqueWhite,
                      padding: EdgeInsets.all(8.0)
                    ), 
                    onPressed: () => startGame(),
                    child: Text(
                      "Start new game",
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 18.0,
                      ),
                    ), 
                  )

                  
                ],
              ),
            ),
          ]
        ),
      )
    );
  }
}

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
          textStyle: TextStyle(
            color: AppColors.opaqueWhite
          ),
          width: 250.0,
    
        ),
      ],
    );
  }
}