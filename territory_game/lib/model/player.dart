import 'dart:ui';

import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/model/property.dart';

class Player {
  final String id;
  final String displayName;
  final Color propertyColor;
  List<Property> properties;
  Property? propertyToPlace;

  Player({
    required this.id, 
    required this.displayName,
    required this.propertyColor,
    List<Property>? properties,
    this.propertyToPlace,
  }) : properties = properties ?? [];
   
  bool get mustPlaceProperty {
    return propertyToPlace != null;
  }

  int get propertyCount => properties.length;

  int get totalControlPoints {
    int total = 0;
    if (properties.isNotEmpty) {
      for (Property property in properties) {
        total += property.controlPoints;
      }
    }

    return total;
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json["id"],
      displayName: json["displayName"],
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
      "displayName": displayName,
      "propertyColor": propertyColor == AppColors.propertyBlack ? "black" : "white",
      "properties": properties.isNotEmpty 
        ? properties.map((property) => property.toJson())
        : [],
      "propertyToPlace": propertyToPlace?.toJson()
    };
  }

  void addToProperties(Property property) {
    properties.add(property);
  }

  void removeFromProperties(Property property) {
    properties.remove(property);
  }
}

