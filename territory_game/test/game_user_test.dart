import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/game_user.dart';

void main() {
  final testGameUser = GameUser(id: "id1", email: "email@test.com");

  /// Tests that the JSON serialisation/deserialisation methods produce the expected result.
  test("json", () {
    final userJson = testGameUser.toJson();
    expect(userJson["id"], "id1");
    expect(userJson["email"], "email@test.com");

    final userObj = GameUser.fromJson(userJson);
    expect(userObj.id, "id1");
    expect(userObj.email, "email@test.com");
  })  
;}