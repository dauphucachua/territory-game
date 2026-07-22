import 'dart:async';

class TimerService {
  final DateTime endTime;
  Duration? timeLeft;
  Timer? timer;

  TimerService({
    required this.endTime
  });

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