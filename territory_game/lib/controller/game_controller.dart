import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:territory_game/model/battle.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/player.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/question_models/question.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_feedback.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_service.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/firebase_services/firebase_auth_service.dart';
import 'package:territory_game/services/timer_service/timer_service.dart';

/// A controller class that manages interactions between the major classes of the game.
class GameController extends ChangeNotifier {
  final FirebaseAuthService firebaseAuth;
  final ChatbotApiProvider chatbotProvider;
  final TimerService timer;
  Game game; 
  StreamSubscription? gameSubscription; 
  final FirebaseFirestore db = FirebaseFirestore.instance; 
  

  GameController({
    required this.firebaseAuth,
    required this.chatbotProvider,
    required this.timer,
    required this.game
  });

  Subject get subject => game.subject;
  Topic get topic => game.topic;
  String get topicName => game.topic.name;
  List<String> get subTopics => game.topic.subTopics;
  ChatbotApiService get chatbot => chatbotProvider.chatbot;
  Board get board => game.board;
  List<List<dynamic>> get boardState => game.board.state;
  DateTime get endTime => game.endTime;
  GameUser get activeUser => firebaseAuth.activeUser!;
  Player get activePlayer => game.players[activeUser.id]!;
  Player? get opponent => game.players.length > 1 ? game.players.values.where(
    (player) => player.id != activeUser.id).first : null;
  bool get gameIsActive => game.isActive;
  
  /// Opens a stream subscription to the Firestore document for the current game.
  Future<void> listenForStateUpdates() async {
    final DocumentReference gameRef = db.collection("games").doc(game.id);
    gameSubscription = gameRef.snapshots().listen((gameState) {
      final gameData = gameState.data();
      if (gameData != null) {
        game = Game.fromJson(gameData as Map<String, dynamic>);
      }
      notifyListeners();
    });
  }

  /// Updates the document with the active user's id on Firestore.
  Future<void> updateFirestoreActiveUserDoc() async {
    await db.collection("users").doc(activeUser.id).set(activeUser.toJson());
  }

  /// Updates the document with the current game's id on Firestore.
  Future<void> updateFirestoreGameDoc() async {
    await db.collection("games").doc(game.id).set(game.toJson());
  }

  /// Adds a player to the game.
  Future<void> addPlayerToGame(Player player) async {
    if (activeUser.id == player.id) {
      game.addPlayer(player);
      activeUser.addGameId(game.id);
      notifyListeners();
      await updateFirestoreGameDoc();
      await updateFirestoreActiveUserDoc();
    } else {
      throw "Authorized user ID does not match Player object ID.";
    }
  }

  /// Sets the propertyToPlace field for the active player.
  Future<void> setPropertyToPlace(Property property) async {
    activePlayer.propertyToPlace = property;
    notifyListeners();
    await updateFirestoreGameDoc();
  } 
  
  /// Reverts the activePlayer's propertyToPlace field to null.
  void _removePropertyToPlace() {
    activePlayer.propertyToPlace = null;
  }

  /// Gets the current count of sub-topics within a board area.
  /// 
  /// This is used for checking if a Property's placement will surpass the sub-topic limit for the intended area.
  Map<String, Map<String, int>> subTopicCountPerArea() {
    final subTopicCounts = {};

    for (String subTopic in topic.subTopics) {
      subTopicCounts[subTopic] = {
        "The Dojo": 0,
        "The Arena": 0,
        "The Battleground": 0,
        "The Pit": 0
      };
    }
    
    for (List row in boardState) {
      for (var item in row) {
        if (item is Property) {
          final propertySubTopic = item.quiz.subTopic;
          final propertyArea = item.boardArea;
          subTopicCounts[propertySubTopic][propertyArea] += 1;
        }
      }
    }

    return Map<String, Map<String, int>>.from(subTopicCounts);
  }

  /// Checks if an area of the board will surpass the sub-topic limit if the incoming property is added.
  bool subTopicLimitSurpassed(Property property, {required int row, required int col}) {
    final intendedArea = board.getBoardArea(row, col);
    final subTopic = property.quiz.subTopic;
    final limits = board.areaLimits;
    final currentAreaCounts = subTopicCountPerArea();

    if (currentAreaCounts[subTopic]![intendedArea]! + 1 > limits[intendedArea]!) {
      return true;
    } else {
      return false;
    }
  }

  /// Places a property at the 2d list position indicated by the row and col parameters.
  Future<bool> placeProperty(Property property, {required int row, required int col}) async {
    if (subTopicLimitSurpassed(property, row: row, col: col)) {
      print("Area too full of this sub-topic");
      return false;
    }

    if (boardState[row][col] != null) {
      print("Square is occupied.");
      return false;
    }

    property.row = row;
    property.col = col;
    boardState[row][col] = property;
    _removePropertyToPlace();

    final message = "${activePlayer.displayName} placed a property with ${property.health} health at ${property.humanCoord}.";
    saveEventMessage(message);
    notifyListeners();
    await updateFirestoreGameDoc();
    return true;
  }

  /// Strengthens a property by adding to its health and storing a new set of questions.
  Future<void> strengthenProperty(Property property, Quiz newQuiz, int newQuizScore) async {
    property.quiz.addQuestionsFromQuiz(newQuiz);
    property.health += newQuizScore;
    notifyListeners();
    await updateFirestoreGameDoc();
  }

  /// Sets two properties in the roles of attacker and defender in the attacking player's activeBattle field.
  Future<void> setBattle(Property attacker, Property defender) async {
    activePlayer.activeBattle = Battle(
      attacker: attacker,
      defender: defender
    );
    
    attacker.isBattling = true;
    defender.isBattling = true;

    // saveEventMessage calls notifyListeners and updates Firestore, so these don't need to be repeated.
    await saveEventMessage("${activePlayer.displayName}'s property at ${attacker.humanCoord} is attacking ${defender.humanCoord}.");
  }

  /// Facilitates a battle between two properties.
  Future<void> battle(int attackerScore) async {
    final attacker = activePlayer.activeBattle!.attacker;
    final defender = activePlayer.activeBattle!.defender;
    
    if (attacker == null || defender == null) {
      throw "The battling properties are not set.";
    }
    
    final boardAttacker = boardState[attacker.row!][attacker.col!];
    final boardDefender = boardState[defender.row!][defender.col!];
    final attackingPlayer = game.players[attacker.ownerId];

    if (attackerScore > defender.health) {
      boardDefender.ownerId = attacker.ownerId;
      boardDefender.health = attackerScore;
      final message = "${attackingPlayer!.displayName}'s attack on ${defender.humanCoord} was successful. "
                      "It now belongs to ${attackingPlayer.displayName} and has $attackerScore health.";
      saveEventMessage(message);
    } else {
      boardAttacker.health ~/= 2;    

      final message = "${attackingPlayer!.displayName}'s attack on ${defender.humanCoord} failed. "
                      "The property at ${attacker.humanCoord} lost half of its health - ${boardAttacker.health} left.";
      saveEventMessage(message);
    }

    boardAttacker.isBattling = false;
    boardDefender.isBattling = false;
    activePlayer.activeBattle = null;

    notifyListeners();
    await updateFirestoreGameDoc();
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
  Future<Quiz> getQuiz(String subTopic, String questionType, int questionCount, String difficulty) async {
    final questionHistory = game.history.questionHistory[questionType]!;

    Map<String, dynamic>? quizJson = await chatbot.getQuizJson(
      game.topic, 
      subTopic, 
      questionType, 
      questionCount,
      questionHistory,
      difficulty
    );

    if (quizJson != null) {
      return Quiz.fromJson(quizJson);
    } else {
      throw "Failed to get quiz from chatbot";
    }
  }

  /// Adds a difficult bonus question to an existing quiz for when a property has an unbeatable perfect score
  Future<void> addBonusQuestionToQuiz(Quiz quiz) async {
    final questionHistory = game.history.questionHistory[quiz.type]!;

    Map<String, dynamic>? bonusQuestionJson = await chatbot.getQuizJson(
      game.topic, 
      quiz.subTopic, 
      quiz.type, 
      1,
      questionHistory,
      "Hard"
    );

    Quiz? bonusQuestion;
    if (bonusQuestionJson != null) {
      bonusQuestion = Quiz.fromJson(bonusQuestionJson);
    } else {
      throw "Failed to get quiz from chatbot";
    }

    quiz.addQuestionsFromQuiz(bonusQuestion);
  }

  /// Gets a QuizFeedback object based on a completed quiz from the active chatbot.
  Future<QuizFeedback> getFeedback(Quiz quiz) async {
    Map<String, dynamic>? quizFeedbackJson = await chatbot.getFeedbackJson(quiz);
    if (quizFeedbackJson != null) {
      return QuizFeedback.fromJson(quizFeedbackJson);
    } else {
      throw "Failed to get feedback from chatbot";
    }
  }

  /// Saves a set of questions to a global question history for the game.
  Future<void> saveToQuestionHistory(String questionType, List<Question> questions) async {
    game.history.addQuestions(questionType, questions);
    notifyListeners();
    await updateFirestoreGameDoc();
  }

  /// Saves a chat message to the activity history.
  Future<void> saveChatMessage(String message) async {
    game.history.addChatMessage(activePlayer, message);
    notifyListeners();
    await updateFirestoreGameDoc();
  }

  /// Saves an event message to the activity history.
  Future<void> saveEventMessage(String event) async {
    game.history.addEvent(event);
    notifyListeners();
    await updateFirestoreGameDoc();
  }

  /// Ends the current game.
  Future<void> endGame() async {
    game.isActive = false;
    activeUser.activeGameIds.remove(game.id);
    notifyListeners(); 
    await updateFirestoreActiveUserDoc();
    await updateFirestoreGameDoc();
  }
}
