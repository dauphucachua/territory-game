import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';
import 'package:territory_game/services/chatbot_services/mistral_api_service.dart';
import 'package:territory_game/services/firebase_services/firebase_auth_service.dart';
import 'package:territory_game/services/timer_service/timer_service.dart';
import 'package:territory_game/view/screens/game_screen.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';
import 'package:territory_game/view/widgets/main_menu/dialogs/new_game_dialog.dart';


class MainMenuScreen extends StatefulWidget {

  const MainMenuScreen({
    super.key
  });

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final db = FirebaseFirestore.instance;
  
  @override
  Widget build(BuildContext context) {
    final firebaseAuth = context.watch<FirebaseAuthService>();
    
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
                "Welcome, ${firebaseAuth.activeUser!.email}\n${firebaseAuth.activeUser!.id}",
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w800,
                )
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
                    )
                  ),
                  MainMenuButton(
                    text: "Rules",
                    onPressed: () {} // RulesScreen
                  ),
                  MainMenuButton(
                    text: "Logout",
                    onPressed: () {
                      firebaseAuth.logout();
                      Navigator.pop(context);
                    }
                  )
                ],
              ),

                ]
              ),
              Column(
                mainAxisAlignment: .center,
                children: [
                  Text("Continue a game"),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    width: 400,
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
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final currentGameData = Map<String, dynamic>.from(data[index]);
                            
                            void onGameChosen() {
                              print(currentGameData.runtimeType);
                              
                              final game = Game.fromJson(currentGameData);

                              final timer = TimerService(
                                endTime: game.endTime
                              );

                              final chatbotProvider = ChatbotApiProvider();
                              final mistralClient = MistralApiService(
                                config: ChatbotConfig());
                              chatbotProvider.addChatbot(mistralClient);

                              final gameController = GameController(
                                chatbotProvider: chatbotProvider,
                                game: game,
                                firebaseAuth: firebaseAuth,
                                timer: timer
                              );

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                    create: (context) => gameController,
                                    child: const GameScreen()
                                  ),
                                ),
                              );
                            }
                             
                            return ElevatedButton(
                              onPressed: () => onGameChosen(),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.all(5),
                                width: 150.0,
                                height: 75.0,
                                decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  borderRadius: AppDimensions.cornerRadius,
                                ),
                                child: Row(
                                  children: [
                                    ContentText(text: "Ends at: ${currentGameData["endTime"]}")
                                  ]
                                )
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
                  )
            ],
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

