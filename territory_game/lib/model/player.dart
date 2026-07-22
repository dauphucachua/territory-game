import 'dart:ui';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/model/battle.dart';
import 'package:territory_game/model/property.dart';

class Player {
  final String id;
  final String displayName;
  final Color propertyColor;
  Battle? activeBattle;
  Property? propertyToPlace;

  Player({
    required this.id, 
    required this.displayName,
    required this.propertyColor,
    this.activeBattle,
    this.propertyToPlace,
  });
   
  bool get mustPlaceProperty {
    return propertyToPlace != null;
  }


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

