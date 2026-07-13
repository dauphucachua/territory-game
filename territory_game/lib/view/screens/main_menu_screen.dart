import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/services/firebase_services/firebase_auth_service.dart';
import 'package:territory_game/view/widgets/main_menu/dialogs/new_game_dialog.dart';


class MainMenuScreen extends StatefulWidget {

  const MainMenuScreen({
    super.key
  });

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  
  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService firebaseAuth = context.watch<FirebaseAuthService>();
    // New game, opens dialog - choose subject, choose topic, choose duration, start game
    return Scaffold(
      body: Column(
        mainAxisAlignment: .center,
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
                        currentUser: firebaseAuth.activeUser!,
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
                    }// Signout - create with firebaseauth class
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

