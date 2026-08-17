import 'package:flutter/material.dart';
/// This file contains classes of constant values for global use throughout the application.

/// A class of color constants.
class AppColors {
  static const darkBlue = Color.fromARGB(255, 33, 48, 68);
  static const blue = Color.fromARGB(255, 45, 65, 90);
  static const opaqueWhite = Color.fromARGB(164, 255, 255, 255);
  static const heartRed = Color.fromARGB(165, 244, 67, 54);
  static const pitRed = Color.fromARGB(255, 165, 55, 51);
  static const battlegroundPurple = Color.fromARGB(255, 118, 50, 135);
  static const arenaGreen = Color.fromARGB(255, 87, 138, 50);
  static const dojoGrey = Color.fromARGB(255, 78, 101, 123);
  static const propertyBlack = Colors.black;
  static const propertyWhite = Colors.white;
  static const backgroundCream = Color.fromARGB(255, 217, 213, 206);
  static const correctBoxGreen = Color.fromARGB(177, 74, 113, 57);
  static const midBoxYellow = Color.fromARGB(137, 255, 197, 8);
  static const wrongBoxRed = Color.fromARGB(185, 113, 57, 57);
  static const selectedBlue = Color.fromARGB(255, 69, 99, 136); 
}

/// A class of common dimensions.
class AppDimensions {
  static final cornerRadius = BorderRadius.circular(15.0);
  static final boardRows = 10;
  static final boardCols = 10;
}

/// A class for the rules of the app.
class AppRules {
  static const rules = 
    """
    This is a multiplayer territory board game.
    The object of the game is to have more control points than your opponent at the end of the time limit.

    PLACING PROPERTIES:

    Players earn pieces ("properties") to place on the board by completing activities.
    Click "+ New property" in the sidebar to begin an activity.
    Set the desired activity settings and complete the activity.
    The score you get in the activity makes up your new property's health points.
    The questions you answer get saved inside the new property. 
    Upon completion, you will have a new property to place in the "Properties" tab of the sidebar.
    Drag it onto the board to place it. 

    CONTROL POINTS:

    Different areas of the board provide different numbers of control points.
    -	Centre (RED): “The Pit” – 10 control points
    -	2nd from centre (PURPLE): “The Battleground” – 5 control points
    -	3rd from centre (GREEN): “The Arena” – 2 control points
    -	Outer ring (GREY): “The Dojo" – 1 control point

    ATTACKING:

    Click and drag from your own property to an opponent's to attack it.
    Properties must be directly adjacent to be able to attack each other.
    If you beat your opponent's score on the questions saved in their property, it becomes yours.
    If you fail, your attacking property will lose half of its health.
    If your opponetn

    STRENGTHENING: 

    Click on one of your own properties to strengthen it.
    This allows you to add more questions to the property with the existing activity type and topic.

    """;
}