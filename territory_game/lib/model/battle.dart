import 'package:territory_game/model/property.dart';

class Battle {
  Property? attacker;
  Property? defender;

  Battle({
    this.attacker,
    this.defender
  });

  factory Battle.fromJson(Map<String, dynamic> json) {
    return Battle(
      attacker: json["attacker"] != null ? Property.fromJson(json["attacker"]) : null,
      defender: json["defender"] != null ? Property.fromJson(json["defender"]) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "attacker": attacker?.toJson(),
      "defender": defender?.toJson()
    };
  }

  void setBattlers({
    required Property attacker,
    required Property defender
  }) {
    this.attacker = attacker;
    this.defender = defender;
  }

  void clearBattlers() {
    attacker = null;
    defender = null;
  }
}