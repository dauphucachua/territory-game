import 'package:territory_game/model/property.dart';

class Battle {
  Property? attacker;
  Property? defender;

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