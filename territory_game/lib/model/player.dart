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
      properties: json["properties"],
      propertyToPlace: json["propertyToPlace"]
    );
  }
}

