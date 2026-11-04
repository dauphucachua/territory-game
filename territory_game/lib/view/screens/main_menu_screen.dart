import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/repositories/game_repository.dart';
import 'package:territory_game/services/firebase_services/firebase_auth_service.dart';
import 'package:territory_game/services/initialization_services/session_builder.dart';
import 'package:territory_game/view/screens/game_screen_wrapper.dart';
import 'package:territory_game/view/widgets/main_menu/dialogs/new_game_dialog.dart';
import 'package:territory_game/view/widgets/rules_dialog.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  late Stream<List<Game>> activeGamesStream;
  late Stream<List<Game>> availableGamesStream;
  final nameController = TextEditingController();
  String? selectedDisplayName;

  @override
  void initState() {
    super.initState();
    _refreshGameStreams();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _refreshGameStreams() {
    final auth = context.read<FirebaseAuthService>();
    final user = auth.activeUser!;
    final gameRepository = context.read<GameRepository>();

    activeGamesStream = gameRepository.watchActiveGames(
      List<String>.of(user.activeGameIds),
    );

    availableGamesStream = gameRepository.watchAvailableGames(user.id);
  }

  void pushToGameScreen(BuildContext context, GameController gameController) {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(name: "/gameScreen"),
        builder: (_) => ChangeNotifierProvider(
          create: (_) => gameController,
          child: const GameScreenWrapper(),
        ),
      ),
    );

    if (context.mounted) {
      setState(() {
        _refreshGameStreams();
      });
    }
  }

  Player createPlayerWithOppositeColor(
    Game game,
    String activeUserId,
    String selectedDisplayName,
  ) {
    final opponentColor = game.players.values.first.propertyColor;

    return Player(
      id: activeUserId,
      displayName: selectedDisplayName,
      propertyColor: opponentColor == AppColors.propertyBlack
          ? AppColors.propertyWhite
          : AppColors.propertyBlack,
    );
  }

  Future<void> pushAvailableGame(
    BuildContext context,
    Game game,
    String activeUserId,
    String selectedDisplayName,
  ) async {
    final gameController = await context.read<SessionBuilder>().create(game);
    final newPlayer = createPlayerWithOppositeColor(
      game,
      activeUserId,
      selectedDisplayName,
    );
    try {
      await gameController.addPlayerToGame(newPlayer);

      if (context.mounted) {
        pushToGameScreen(context, gameController);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e. Could not join game.")),
        );
      }
      gameController.dispose();
    }
  }

  Future<void> pushActiveGame(
    BuildContext context,
    Game game,
    String activeUserId,
  ) async {
    if (game.containsPlayerWithId(activeUserId)) {
      final gameController = await context.read<SessionBuilder>().create(game);
      if (!context.mounted) return;
      pushToGameScreen(context, gameController);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = context.watch<FirebaseAuthService>();
    final activeUserId = firebaseAuth.activeUser!.id;

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
                      builder: (context) => NewGameDialog(),
                    ),
                  ),
                  MainMenuButton(
                    text: "Rules",
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => RulesDialog(),
                    ), // RulesScreen
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
                    style: TextStyle(fontSize: 20, color: AppColors.darkBlue),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_right, color: AppColors.darkBlue),
                ],
              ),
              SizedBox(height: 10),
              // This is a menu showing the active user's currently active games.
              SizedBox(
                height: 300,
                width: 450,
                child: GameListView(
                  games: activeGamesStream,
                  itemBuilder: (context, game) => ListTile(
                    title: Text(game.topic.name),
                    subtitle: Text("Ends: ${game.endTimeAsString}"),
                    onTap: () async =>
                        await pushActiveGame(context, game, activeUserId),
                  ),
                  loadingMessage: "Loading active games...",
                  emptyMessage: "No active games found.",
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Join an available game",
                    style: TextStyle(fontSize: 20, color: AppColors.darkBlue),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_right, color: AppColors.darkBlue),
                ],
              ),
              SizedBox(
                width: 400,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Enter display name before joining",
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                ),
              ), // This is a menu showing games that are available to join.
              SizedBox(
                width: 450,
                height: 300,
                child: GameListView(
                  games: availableGamesStream,
                  itemBuilder: (context, game) => ListTile(
                    title: Text(game.topic.name),
                    subtitle: Text("Ends: ${game.endTimeAsString}"),
                    onTap: () async {
                      final selectedDisplayName = nameController.text.trim();
                      if (selectedDisplayName == "" ||
                          selectedDisplayName.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Enter a display name.")),
                        );
                        return;
                      }
                      await pushAvailableGame(
                        context,
                        game,
                        activeUserId,
                        selectedDisplayName,
                      );
                    },
                  ),
                  loadingMessage: "Loading available games...",
                  emptyMessage: "No available games.",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A custom widget for the buttons in the main menu.
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
      onPressed: onPressed, //newGameDialog
      child: Text(
        text,
        style: TextStyle(color: AppColors.opaqueWhite, fontSize: 18.0),
      ),
    );
  }
}

typedef GameItemBuilder = Widget Function(BuildContext context, Game game);

class GameListView extends StatelessWidget {
  final Stream<List<Game>> games;
  final GameItemBuilder itemBuilder;
  final String loadingMessage;
  final String emptyMessage;

  const GameListView({
    required this.games,
    required this.itemBuilder,
    required this.loadingMessage,
    required this.emptyMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: games,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint(
            "$loadingMessage stream error: ${snapshot.error}\n${snapshot.stackTrace}",
          );
          return const Center(child: Text("Could not load games."));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text(loadingMessage));
        }

        final gameList = snapshot.data;
        if (gameList == null || gameList.isEmpty) {
          return Center(child: Text(emptyMessage));
        }

        return ListView.builder(
          itemCount: gameList.length,
          itemBuilder: (context, index) {
            return itemBuilder(context, gameList[index]);
          },
        );
      },
    );
  }
}
