import 'dart:ui';

import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/model/property.dart';

class Player {
  final String id;
  final Color propertyColor;
  List<Property> properties;
  Property? propertyToPlace;

  Player({
    required this.id, 
    required this.propertyColor,
    List<Property>? properties,
    this.propertyToPlace,
  }) : properties = properties ?? [];
   
  bool get mustPlaceProperty {
    return propertyToPlace != null;
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json["id"],
      propertyColor: json["propertyColor"] == "black" ? AppColors.propertyBlack : AppColors.propertyWhite,
      properties: json["properties"] != null 
        ? List<Property>.from(json["properties"].map((property) => Property.fromJson(property))) 
        : [],
      propertyToPlace: json["propertyToPlace"] != null 
        ? Property.fromJson(json["propertyToPlace"]) 
        : json["propertyToPlace"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "propertyColor": propertyColor == AppColors.propertyBlack ? "black" : "white",
      "properties": properties.isNotEmpty 
        ? properties.map((property) => property.toJson())
        : [],
      "propertyToPlace": propertyToPlace?.toJson()
    };
  }

  

}

