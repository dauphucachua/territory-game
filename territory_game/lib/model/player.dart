import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/model/property.dart';

class Player {
  final String id;
  List<Property> properties;
  Property? propertyToPlace;

  Player({
    required this.id, 
    List<Property>? properties,
    this.propertyToPlace,
  }) : properties = properties ?? [];

  factory Player.newPlayerFromUser(GameUser user) {
    return Player(
      id: user.id
    );
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json["id"],
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
      "properties": properties.isNotEmpty 
        ? properties.map((property) => property.toJson())
        : [],
      "propertyToPlace": propertyToPlace?.toJson()
    };
  }

}

