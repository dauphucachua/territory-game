import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/firebase_options.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/view/screens/game_screen.dart';

void main() async {
  // Example topic for testing
  Map<String, dynamic> exampleTopic = {
    "name": "Variables",
    "subTopics": [
      "Naming", "Types", "Values", "Conventions", "Another", "Another", "Another", "Another"
    ]
  };

  Map<String, dynamic> exampleSubject = {
    "name": "Introduction to Programming",
    "topics": [
      {
          "name": "Variables",
          "week": 1,
          "subTopics": [
              "Naming",
              "Conventions",
              "Values"
          ]
      },
      {
          "name": "Functions",
          "week": 2,
          "subTopics": [
              "Scope",
              "Iteration"
          ]
      },
    ],
    "questionTypes": [
        "multipleChoice",
        "theory",
        "codingProblem",
        "codingExercise"
    ]
  };


  Subject subject = Subject.fromJson(exampleSubject);
  print(subject);

  // Example objects for testing
  final board = Board(
    rows: 10,
    cols: 10
  );
  
  final gameController = GameController(
    board: board, 
    subject: subject,
    topic: subject.topics[0]
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MainApp(gameController));
}

class MainApp extends StatelessWidget {
  final GameController gameController;
  const MainApp(this.gameController, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(gameController)
    );
  }
}
