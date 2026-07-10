import 'package:flutter/material.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';
import 'package:territory_game/services/chatbot_services/mistral_api_service.dart';
import 'package:territory_game/view/screens/game_screen.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';

class MainMenuScreen extends StatefulWidget {
  final GameUser currentUser;

  const MainMenuScreen({
    required this.currentUser,
    super.key
  });

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {

  @override
  Widget build(BuildContext context) {
    // New game, opens dialog - choose subject, choose topic, choose duration, start game
    return Scaffold(
      body: Column(
        mainAxisAlignment: .center,
        spacing: 50.0,
        children: [
          Text(
            "Welcome, ${widget.currentUser.email}",
            style: TextStyle(
              color: AppColors.blue,
              fontSize: 25.0,
              fontWeight: FontWeight.w800,
            )
          ),
          Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: .center,
                spacing: 20.0,
                children: [
                  MainMenuButton(
                    text: "New game",
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => NewGameDialog(
                        currentUser: widget.currentUser,
                      ),
                    )
                  ),
                  MainMenuButton(
                    text: "Rules",
                    onPressed: () {} // RulesScreen
                  ),
                  MainMenuButton(
                    text: "Logout",
                    onPressed: () {}// Signout - create with firebaseauth class
                  )
                ],
              ),
              Column(
                mainAxisAlignment: .center,
                children: [
                  Text("Ongoing games: "),
                  for (int i = 0; i < 5; i++)
                  Text("Current game ${i + 1}")
                ]
              )
            ]
          ),
        ],
      )
    );
  }
}

class MainMenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MainMenuButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        fixedSize: Size(200, 50),
      ),
      onPressed: onPressed,//newGameDialog
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.opaqueWhite,
          fontSize: 18.0
        ),
      ),
    );
  }
}

class NewGameDialog extends StatefulWidget {
  final GameUser currentUser;
  final List<Subject> subjectOptions = subjectList;

  NewGameDialog({
    required this.currentUser,
    super.key
  });

  @override
  State<NewGameDialog> createState() => _NewGameDialogState();
}

class _NewGameDialogState extends State<NewGameDialog> {
  Subject? selectedSubject;
  Topic? selectedTopic;

  /// Starts a new game once all necessary selections have been made by the user.
  void startGame() {
    if (selectedSubject != null && selectedTopic != null) {
      // Initialize Board object
      final board = Board(
        rows: 10,
        cols: 10
      );      

      // Initialize ChatbotApi services.
      final ChatbotApiProvider chatbotProvider = ChatbotApiProvider();
      final mistralClient = MistralApiService(
        config: ChatbotConfig());
      chatbotProvider.addChatbot(mistralClient);

      // Initialize GameController with objects passed in.
      final gameController = GameController(
        user: widget.currentUser,
        chatbotProvider: chatbotProvider,
        board: board, 
        subject: selectedSubject!,
        topic: selectedTopic!
      );

      // Push to the main game screen.
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:(context) => GameScreen(gameController),
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
                  SizedBox(height: 40.0),
                  SelectionDropdownRow(
                    instructionText: "Select a topic", 
                    dropdownItems: selectedSubject != null // If a subject has been selected
                    ? List<DropdownMenuEntry>.from(
                      selectedSubject!.topics.map( // Populate the dropdown with subject.topics items
                        (subject) => DropdownMenuEntry(
                          value: subject, 
                          label: subject.name,
                        ),
                      ),
                    )
                    : [], 
                    onItemSelected: (topic) {
                      setState(() {
                        selectedTopic = topic;
                      });
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