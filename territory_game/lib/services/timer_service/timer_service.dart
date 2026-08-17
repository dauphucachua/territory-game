import 'dart:async';

/// A service class for keeping track of game time.
class TimerService {
  // The set end time of the game.
  final DateTime endTime;
  // The current amount of time left before the end of the game.
  Duration? timeLeft;
  Timer? timer;

  TimerService({
    required this.endTime
  });

  /// Runs the timer with a 1-second tick.
  /// 
  /// Every 1 second, the timer checks if the endTime has been surpassed. 
  /// If so, its runs the onTimeout function passed to it.
  void runTimer({required Future<void>Function() onTimeout}) {
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      timeLeft = endTime.difference(DateTime.now());
      if (timeLeft! < const Duration(seconds: 0)) {
        timer!.cancel();
        await onTimeout();
      }
    });
  }
}