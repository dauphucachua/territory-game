import 'dart:async';
import 'dart:io';

class TimerService {
  final DateTime endTime;
  Duration? timeLeft;
  Timer? timer;

  TimerService({
    required this.endTime
  });

  void runTimer(Function() onTimeout) {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      timeLeft = endTime.difference(DateTime.now());
      if (timeLeft! < const Duration(seconds: 0)) {
        timer!.cancel();
        onTimeout();
      }
    });
  }
}