import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';
import 'package:territory_game/services/chatbot_services/mistral_api_service.dart';
import 'package:territory_game/services/firebase_services/firebase_auth_service.dart';
import 'package:territory_game/services/timer_service/timer_service.dart';
import 'package:territory_game/view/screens/game_screen.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';
import 'package:territory_game/view/widgets/main_menu/dialogs/new_game_dialog.dart';
import 'package:territory_game/view/widgets/rules_dialog.dart';


class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({
    super.key
  });

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final db = FirebaseFirestore.instance;
  final nameController = TextEditingController();
  String? selectedDisplayName;
  
  @override
  Widget build(BuildContext context) {
    final firebaseAuth = context.watch<FirebaseAuthService>();
    
    GameController initializeGameController(Game game) {
      final timer = TimerService(
        endTime: game.endTime
        );

      final chatbotProvider = ChatbotApiProvider();
      final mistralClient = MistralApiService(
        config: ChatbotConfig());
      chatbotProvider.addChatbot(mistralClient);

      return GameController(
        chatbotProvider: chatbotProvider,
        game: game,
        firebaseAuth: firebaseAuth,
        timer: timer
      );
    }

    void pushToGameScreen(GameController gameController) {
      Navigator.of(context).push(
        MaterialPageRoute(
          settings: RouteSettings(name: "/gameScreen"),
          builder: (context) => ChangeNotifierProvider(
            create: (context) => gameController,
            child: const GameScreen()
          ),
        ),
      );
    }

    Player createPlayerWithOppositeColor(Game game) {
      final opponentColor = game.players.values.first.propertyColor;

      return Player(
        id: firebaseAuth.activeUser!.id,
        displayName: selectedDisplayName!,
        propertyColor: opponentColor == AppColors.propertyBlack 
          ? AppColors.propertyWhite 
          : AppColors.propertyBlack 
      );
    }

    void onGameChosen(Game game) async {                 
      final gameController = initializeGameController(game);

      if (game.containsPlayerWithId(firebaseAuth.activeUser!.id)) {       
        pushToGameScreen(gameController);
      } else {
        if (selectedDisplayName != null && selectedDisplayName!.isNotEmpty) {
          final newPlayer = createPlayerWithOppositeColor(game);
          await gameController.addPlayerToGame(newPlayer);
          pushToGameScreen(gameController);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Enter a display name to join a game."
                ),
              ),
            );
          }
        }
      }
    }
    
    // New game, opens dialog - choose subject, choose topic, choose duration, start game
    return Scaffold(
      body: Row(
        mainAxisAlignment: .spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .start,
            spacing: 50.0,
            children: [
              Text(
                "Welcome, ${firebaseAuth.activeUser!.email}",
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Column(
                mainAxisAlignment: .center,
                spacing: 20.0,
                children: [
                  MainMenuButton(
                    text: "New game",
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => NewGameDialog(
                        firebaseAuth: firebaseAuth,
                      ),
                    ),
                  ),
                  MainMenuButton(
                    text: "Rules",
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => RulesDialog()
                    ) // RulesScreen
                  ),
                  MainMenuButton(
                    text: "Logout",
                    onPressed: () {
                      firebaseAuth.logout();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              Row(
                children: [
                  Text(
                    "Continue a game",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.darkBlue
                    )
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_right,
                    color: AppColors.darkBlue
                  ),
                ],
              ),
              SizedBox(height: 10),

              // This is a menu showing the active user's currently active games.
              SizedBox(
                height: 300,
                width: 450,
                child: firebaseAuth.activeUser!.activeGameIds.isNotEmpty 
                ? StreamBuilder(
                  stream: db.collection("games")
                    .where("id", whereIn: firebaseAuth.activeUser!.activeGameIds)
                    .snapshots(),    
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading active games...");
                    }
                    
                    final data = snapshot.data!.docs.map((doc) => doc.data()).toList();

                    return ListView.builder(
                      scrollDirection: .vertical,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final currentGameData = Map<String, dynamic>.from(data[index]);
                        final currentGame = Game.fromJson(currentGameData);
                        String? opponentName = currentGame.players.keys.map((playerId) {
                          if (playerId != firebaseAuth.activeUser!.id) {
                            return currentGame.players[playerId]!.displayName;
                          }
                        }).first;
                          
                        return GestureDetector(
                          onTap: () => onGameChosen(currentGame),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.all(5),

                            height: 85.0,
                            decoration: BoxDecoration(
                              color: AppColors.blue,
                              borderRadius: AppDimensions.cornerRadius,
                            ),
                            child: Column(
                              children: [
                                opponentName != null && opponentName.isNotEmpty
                                  ? ContentText(text: "You vs. $opponentName")
                                  : ContentText(text: "You vs. unassigned"),
                                ContentText(text: "Ends: ${currentGame.endTimeAsString}")
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  }
                )
                : Center(
                  child: Text(
                    "You currently have no active games. "
                  )
                )
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Join an available game",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.darkBlue
                    )
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_right,
                    color: AppColors.darkBlue
                  ),
                ],
              ),
              SizedBox(
                width: 400,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Enter display name before joining",
                    hintStyle: TextStyle(
                      fontSize: 14
                    )
                  )
                ),
              ),

              // This is a menu showing games that are available to join.
              SizedBox(
                height: 300,
                width: 450,
                child: StreamBuilder(
                  stream: db.collection("games").snapshots(),    
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading available games...");
                    }
                    
                    final data = snapshot.data!.docs.map((doc) => doc.data()).toList();

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final currentGameData = Map<String, dynamic>.from(data[index]);

                        // Filter out games with no players and games which are full.
                        if (
                          currentGameData["players"].isEmpty
                          || currentGameData["players"].length > 1
                        ) {
                          return Container();
                        }
                        
                        // Filter out games that the active player is already in.
                        for (String playerId in currentGameData["players"].keys) {
                          if (playerId == firebaseAuth.activeUser!.id) {
                            return Container();
                          }
                        }

                        final currentGame = Game.fromJson(currentGameData);
                        final opponentName = currentGame.players.keys.map((playerId) {
                          if (playerId != firebaseAuth.activeUser!.id) {
                            return currentGame.players[playerId]!.displayName;
                          }
                        }).first;
                          
                        return GestureDetector(
                          onTap: () async {
                            selectedDisplayName = nameController.text.trim();
                            print(selectedDisplayName);
                            onGameChosen(currentGame);
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.all(5),
                            height: 85.0,
                            decoration: BoxDecoration(
                              color: AppColors.blue,
                              borderRadius: AppDimensions.cornerRadius,
                            ),
                            child: Column(
                              children: [
                                ContentText(text: "vs. $opponentName"),
                                ContentText(text: "Ends at: ${currentGameData["endTime"]}")
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
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

