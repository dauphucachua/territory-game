import 'dart:ui';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/model/battle.dart';
import 'package:territory_game/model/property.dart';

/// Represents a player in the context of the game. 
class Player {
  // Firestore-generated unique ID, shared with a GameUser.
  final String id;
  // The name that will be shown for the player in-game.
  final String displayName;
  // The color of the player's properties.
  final Color propertyColor;
  // Stores any properties currently involved in this player's attack.
  Battle? activeBattle;
  // Stores a recently loaded property for placement.
  Property? propertyToPlace;

  Player({
    required this.id, 
    required this.displayName,
    required this.propertyColor,
    this.activeBattle,
    this.propertyToPlace,
  });
  
  /// Checks if the player has a property they must place before loading a new one.
  bool get mustPlaceProperty {
    return propertyToPlace != null;
  }

  /// Loads a Player from a JSON object.
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json["id"],
      displayName: json["displayName"],
      propertyColor: json["propertyColor"] == "black" ? AppColors.propertyBlack : AppColors.propertyWhite,
      activeBattle: json["activeBattle"] != null ? Battle.fromJson(json["activeBattle"]) : null,
      propertyToPlace: json["propertyToPlace"] != null 
        ? Property.fromJson(json["propertyToPlace"]) 
        : json["propertyToPlace"]
    );
  }

  /// Returns a JSON-friendly Map version of the Player object.
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "displayName": displayName,
      "propertyColor": propertyColor == AppColors.propertyBlack ? "black" : "white",
      "activeBattle": activeBattle?.toJson(),
      "propertyToPlace": propertyToPlace?.toJson()
    };
  }


}

