import 'package:flutter_test/flutter_test.dart';
import 'package:territory_game/model/history.dart';

void main() {
  final history = History();

  test("json", () {
    final historyJson = history.toJson();
    print(historyJson);
    final historyObj = History.fromJson(historyJson);
    print(historyObj.activityHistory);
    print(historyObj.questionHistory);
  });
}