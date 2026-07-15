import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/player.dart';

void main() {
  Player player = Player(
    id: "1",
    properties: [],
    propertyToPlace: null
  );

  test("json", () {
    final playerJson = player.toJson();
    final playerObj = Player.fromJson(playerJson);

    print(playerObj.toString());
  });
}
  