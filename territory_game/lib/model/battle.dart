import 'package:territory_game/model/property.dart';

/// A class which stores the Property objects currently involved in an attack.
class Battle {
  Property? attacker;
  Property? defender;

  Battle({
    this.attacker,
    this.defender
  });

  /// Loads a Battle object from JSON format.
  factory Battle.fromJson(Map<String, dynamic> json) {
    return Battle(
      attacker: json["attacker"] != null ? Property.fromJson(json["attacker"]) : null,
      defender: json["defender"] != null ? Property.fromJson(json["defender"]) : null
    );
  }

  /// Returns a JSON-friendly Map version of the Battle.
  Map<String, dynamic> toJson() {
    return {
      "attacker": attacker?.toJson(),
      "defender": defender?.toJson()
    };
  }

  /// Sets the attacker and defender fields with Property objects.
  void setBattlers({
    required Property attacker,
    required Property defender
  }) {
    this.attacker = attacker;
    this.defender = defender;
  }

  /// Returns the Battle to an empty state.
  void clearBattlers() {
    attacker = null;
    defender = null;
  }
}