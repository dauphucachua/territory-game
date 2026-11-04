import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/repositories/game_repository.dart';
import 'package:territory_game/repositories/user_repository.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/firebase_services/firebase_auth_service.dart';
import 'package:territory_game/services/timer_service/timer_service.dart';

class SessionBuilder {
  final FirebaseAuthService firebaseAuth;
  final GameRepository gameRepository;
  final UserRepository userRepository;
  final ChatbotApiProvider Function() createChatbotProvider;
  
  SessionBuilder({
    required this.firebaseAuth,
    required this.gameRepository,
    required this.userRepository,
    required this.createChatbotProvider
  });

  Future<GameController> create(Game game) async {
    final gameController = GameController(
      game: game,
      firebaseAuth: firebaseAuth,
      gameRepository: gameRepository,
      userRepository: userRepository,
      chatbotProvider: createChatbotProvider(),
      timer: TimerService(endTime: game.endTime)
    );

    try {
      await gameController.cancelBattle();
    } catch (_) {}

    gameController.timer.runTimer(onTimeout: gameController.endGame);
    return gameController;
  }
}