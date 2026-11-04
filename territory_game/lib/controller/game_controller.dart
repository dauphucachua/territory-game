import 'dart:async';

import 'package:flutter/material.dart';
import 'package:territory_game/model/battle.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/question_models/question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_feedback.dart';
import 'package:territory_game/model/quiz_models/quiz_type.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/repositories/game_repository.dart';
import 'package:territory_game/repositories/user_repository.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_service.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/firebase_services/firebase_auth_service.dart';
import 'package:territory_game/services/timer_service/timer_service.dart';
import 'package:territory_game/view/widgets/game_screen/UI/dialogs/quiz_dialog.dart';

/// A controller class that manages interactions between the major classes of the game.
class GameController extends ChangeNotifier {
  final FirebaseAuthService firebaseAuth;
  final ChatbotApiProvider chatbotProvider;
  final TimerService timer;
  final GameRepository gameRepository;
  final UserRepository userRepository;
  Game game;
  StreamSubscription? gameSubscription;
  bool _disposed = false;

  GameController({
    required this.firebaseAuth,
    required this.chatbotProvider,
    required this.timer,
    required this.gameRepository,
    required this.userRepository,
    required this.game,
  });

  // Getters for ease of access.
  Subject get subject => game.subject;
  Topic get topic => game.topic;
  String get topicName => game.topic.name;
  List<String> get subTopics => game.topic.subTopics;
  ChatbotApiService get chatbot => chatbotProvider.chatbot;
  Board get board => game.board;
  List<List<dynamic>> get boardState => game.board.state;
  bool get gameIsActive => game.isActive;
  GameUser get activeUser => firebaseAuth.activeUser!;
  Player get activePlayer => game.players[activeUser.id]!;
  Player? get opponent => game.players.length > 1
      ? game.players.values.where((player) => player.id != activeUser.id).first
      : null;

  @override
  void dispose() {
    gameSubscription?.cancel();
    gameSubscription = null;
    timer.dispose();
    _disposed = true;
    super.dispose();
  }

  /// Opens a stream subscription to the Firestore document for the current game.
  void listenForStateUpdates() {
    if (gameSubscription != null) return;

    gameSubscription = gameRepository.watchGame(game.id).listen((updatedGame) {
      game = updatedGame;
      if (!_disposed) notifyListeners();
    });
  }

  Future<void> _updateGameState(void Function(Game g) change) async {
    game = await gameRepository.updateGame(game.id, change);
    if (!_disposed) notifyListeners();
  }

  /// Updates the "users" document with the active user's id on Firestore.
  Future<void> _updateUserState() async {
    await userRepository.saveUser(activeUser);
  }

  /// Adds a player to the game.
  Future<void> addPlayerToGame(Player player) async {
    if (activeUser.id == player.id) {
      final updatedGame = await gameRepository.joinGame(game.id, player);
      game = updatedGame;

      if (!activeUser.activeGameIds.contains(game.id)) {
        activeUser.addGameId(game.id);
        await _updateUserState();
      }

      notifyListeners();
    } else {
      throw StateError("Authorized user ID does not match Player object ID.");
    }
  }

  /// Sets the propertyToPlace field for the active player.
  Future<void> setPropertyToPlace(Property property) async {
    await _updateGameState(
      (g) => g.players[activeUser.id]!.propertyToPlace = property,
    );
  }

  /// Gets the current count of sub-topics within a board area.
  ///
  /// This is used for checking if a Property's placement will surpass the sub-topic limit for the intended area.
  Map<String, Map<String, int>> subTopicCountPerArea({Game? of}) {
    final g = of ?? game;

    final subTopicCounts = <String, Map<String, int>>{};

    for (String subTopic in g.topic.subTopics) {
      subTopicCounts[subTopic] = <String, int>{
        "The Dojo": 0,
        "The Arena": 0,
        "The Battleground": 0,
        "The Pit": 0,
      };
    }

    for (List row in g.board.state) {
      for (var item in row) {
        if (item is Property) {
          final areaCounts = subTopicCounts[item.quiz.subTopic];
          if (areaCounts == null) {
            continue;
          }
          final propertyArea = item.boardArea;
          areaCounts[propertyArea] = (areaCounts[propertyArea] ?? 0) + 1;
        }
      }
    }

    return Map<String, Map<String, int>>.from(subTopicCounts);
  }

  /// Checks if an area of the board will surpass the sub-topic limit if the incoming property is added.
  bool subTopicLimitSurpassed(
    Property property, {
    required int row,
    required int col,
    Game? of,
  }) {
    final g = of ?? game;
    final subTopic = property.quiz.subTopic;

    if (!g.topic.subTopics.contains(subTopic))
      throw StateError("Sub-topic not recognized.");

    final intendedArea = g.board.getBoardArea(row, col);
    final limit = g.board.areaLimits[intendedArea];
    final currentAreaCounts = subTopicCountPerArea(of: g);
    final subTopicCount = currentAreaCounts[subTopic]?[intendedArea] ?? 0;

    if (limit != null && subTopicCount > limit) {
      return true;
    }
    return false;
  }

  /// Places a property at the 2d list position indicated by the row and col parameters.
  Future<void> placeProperty(
    Property property, {
    required int row,
    required int col,
  }) async {
    await _updateGameState((g) {
      // Check that the new property will not surpass the intended area's sub-topic limits.
      if (subTopicLimitSurpassed(property, row: row, col: col, of: g)) {
        throw StateError("Area too full of this subtopic.");
      }

      // Check that the intended square is not occupied.
      if (g.board.state[row][col] != null) {
        throw StateError("Square is occupied already.");
      }

      // Place the property
      property.row = row;
      property.col = col;
      g.board.state[row][col] = property;
      g.players[activeUser.id]!.propertyToPlace = null;
      // Log a message for the event history.
      g.history.addEvent(
        "${g.players[activeUser.id]!.displayName} placed a property with "
        "${property.health} health at ${property.humanCoord}.",
      );
    });
  }

  Property _propertyAt(Game g, Property ref) {
    final square = g.board.state[ref.row!][ref.col!];
    if (square is! Property)
      throw StateError("No property at ${ref.humanCoord}.");
    return square;
  }

  /// Strengthens a property by adding to its health and storing a new set of questions.
  Future<void> strengthenProperty(
    Property property,
    Quiz newQuiz,
    int newQuizScore,
  ) async {
    await _updateGameState((g) {
      final p = _propertyAt(g, property);

      // Check ownership.
      if (p.ownerId != activeUser.id) {
        throw StateError("Property does not belong to active player.");
      }
      // Check property is not currently engaged in battle.
      if (p.isBattling) {
        throw StateError(
          "A property cannot be strengthened while it is battling.",
        );
      }

      // Perform strengthening actions.
      p.quiz.addQuestionsFromQuiz(Quiz.fromJson(newQuiz.toJson()));
      p.health += newQuizScore;
    });
  }

  /// Sets two properties in the roles of attacker and defender in the attacking player's activeBattle field.
  Future<void> setBattle(Property attacker, Property defender) async {
    await _updateGameState((g) {
      final a = _propertyAt(g, attacker);
      final d = _propertyAt(g, defender);

      // Ownership and currently battling checks.
      if (a.ownerId != activeUser.id) {
        throw StateError("You can only attack with your own property.");
      }
      if (d.ownerId == activeUser.id) {
        throw StateError("You cannot attack your own property.");
      }
      if (a.isBattling || d.isBattling) {
        throw StateError("One of these properties is already in a battle.");
      }

      a.isBattling = true;
      d.isBattling = true;
      g.players[activeUser.id]!.activeBattle = Battle(attacker: a, defender: d);
      final playerName = g.players[activeUser.id]!.displayName;
      g.history.addEvent(
        "$playerName's property at ${a.humanCoord} is attacking ${d.humanCoord}.",
      );
    });
  }

  /// Facilitates a battle between two properties.
  Future<void> battle(int attackerScore) async {
    await _updateGameState((g) {
      final attacker = g.players[activeUser.id]?.activeBattle?.attacker;
      final defender = g.players[activeUser.id]?.activeBattle?.defender;

      if (attacker == null || defender == null) {
        throw StateError("The battling properties are not set.");
      }

      // Ensure that battle affects the Property objects in the boardState List.
      final boardAttacker = g.board.state[attacker.row!][attacker.col!];
      final boardDefender = g.board.state[defender.row!][defender.col!];

      if (boardAttacker is! Property || boardDefender is! Property) {
        throw StateError("A battling property is no longer on the board.");
      }

      // Null safety in case player has left the game.
      final attackerName =
          g.players[attacker.ownerId]?.displayName ?? "Unknown player";

      if (attackerScore > boardDefender.health) {
        // Attacker wins
        boardDefender.ownerId = attacker.ownerId; // Swap owners
        boardDefender.health = attackerScore; // Convert score to health
        final message =
            "$attackerName's attack on ${defender.humanCoord} was successful. "
            "It now belongs to $attackerName and has $attackerScore health.";
        g.history.addEvent(message);
      } else {
        // Attacker loses
        boardAttacker.health ~/= 2; // Half attacker's health

        final message =
            "$attackerName's attack on ${defender.humanCoord} failed. "
            "The property at ${attacker.humanCoord} lost half of its health - ${boardAttacker.health} left.";
        g.history.addEvent(message);
      }

      // Reset affected fields.
      boardAttacker.isBattling = false;
      boardDefender.isBattling = false;
      g.players[activeUser.id]!.activeBattle = null;
    });
  }

  /// Cancels a currently set battle.
  Future<void> cancelBattle() async {
    await _updateGameState((g) {
      final player = g.players[activeUser.id];
      final activeBattle = g.players[activeUser.id]?.activeBattle;
      if (player == null || activeBattle == null) {
        return;
      }

      for (final p in [activeBattle.attacker, activeBattle.defender]) {
        final row = p?.row;
        final col = p?.col;
        if (row == null || col == null) {
          continue;
        }
        final square = g.board.state[row][col];
        if (square is Property) {
          square.isBattling = false;
        }
      }
      player.activeBattle = null;
    });
  }

  /// Gets a list of properties that are owned by a single player.
  List<Property> getPropertiesByPlayerId(String playerId) {
    List<Property> properties = [];
    for (List row in boardState) {
      for (var item in row) {
        if (item is Property && item.ownerId == playerId) {
          properties.add(item);
        }
      }
    }
    return properties;
  }

  /// Gets the amount of control points that a player has.
  int getControlPointsByPlayerId(String playerId) {
    List<Property> properties = getPropertiesByPlayerId(playerId);
    int total = 0;
    if (properties.isNotEmpty) {
      for (Property property in properties) {
        total += property.controlPoints;
      }
    }
    return total;
  }

  /// Gets a Quiz object with the specified parameters from the active chatbot.
  Future<Quiz> getQuiz(
    String subTopic,
    QuizType quizType,
    int questionCount,
    String difficulty,
  ) async {
    final questionHistory = game.history.questionHistory[quizType]!;

    try {
      final quizJson = await chatbot.getQuizJson(
        game.topic,
        subTopic,
        quizType,
        questionCount,
        questionHistory,
        difficulty,
      );

      if (quizJson == null) throw StateError("Failed to get quiz from chatbot");
      return Quiz.fromJson(quizJson);
    } catch (e) {
      debugPrint("getQuiz failed: $e");
      throw StateError("Could not get quiz.");
    }
  }

  /// Adds a difficult bonus question to an existing quiz for when a property has an unbeatable perfect score
  Future<void> addBonusQuestionToQuiz(Quiz quiz) async {
    final questionHistory = game.history.questionHistory[quiz.type]!;

    // Gets a quiz composed only of one hard question.
    Map<String, dynamic>? bonusQuestionJson = await chatbot.getQuizJson(
      game.topic,
      quiz.subTopic,
      quiz.type,
      1,
      questionHistory,
      "Hard",
    );

    Quiz? bonusQuestion;
    if (bonusQuestionJson != null) {
      bonusQuestion = Quiz.fromJson(bonusQuestionJson);
    } else {
      throw StateError("Failed to get quiz from chatbot");
    }

    quiz.addQuestionsFromQuiz(bonusQuestion);
  }

  Future<void> endQuiz({
    required QuizMode mode,
    required Quiz quiz,
    required QuizFeedback feedback,
    Property? propertyToStrengthen,
  }) async {
    switch (mode) {
      case QuizMode.creation:
        await saveToQuestionHistory(quiz.type, quiz.questions);

        final property = Property(
          health: feedback.totalScore,
          ownerId: activePlayer.id,
          quiz: quiz,
        );

        await setPropertyToPlace(property);
        break;

      case QuizMode.attack:
        await battle(feedback.totalScore);
        break;

      case QuizMode.strengthen:
        if (propertyToStrengthen == null) {
          throw StateError(
            "A property is required when ending a strengthening quiz.",
          );
        }

        await strengthenProperty(
          propertyToStrengthen,
          quiz,
          feedback.totalScore,
        );
        break;
    }
  }

  /// Gets a QuizFeedback object based on a completed quiz from the active chatbot.
  Future<QuizFeedback> getFeedback(Quiz quiz) async {
    try {
      final quizFeedbackJson = await chatbot.getFeedbackJson(quiz);
      if (quizFeedbackJson == null) throw StateError("No feedback returned.");
      return QuizFeedback.fromJson(quizFeedbackJson);
    } catch (e) {
      debugPrint("getFeedback failed: $e");
      throw StateError("Could not get feedback.");
    }
  }

  /// Saves a set of questions to a global question history for the game.
  Future<void> saveToQuestionHistory(
    QuizType quizType,
    List<Question> questions,
  ) async {
    await _updateGameState((g) => g.history.addQuestions(quizType, questions));
  }

  /// Saves a chat message to the activity history.
  Future<void> saveChatMessage(String message) async {
    await _updateGameState(
      (g) => g.history.addChatMessage(g.players[activeUser.id]!, message),
    );
  }

  /// Saves an event message to the activity history.
  Future<void> saveEventMessage(String event) async {
    await _updateGameState((g) => g.history.addEvent(event));
  }

  /// Ends the current game.
  Future<void> endGame() async {
    await _updateGameState((g) => g.isActive = false);
    activeUser.activeGameIds.remove(game.id);
    await _updateUserState();
  }
}
