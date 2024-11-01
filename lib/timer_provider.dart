import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  Timer? _timer;
  int _totalSeconds = 0;
  bool _isRunning = false;

  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();
  final TextEditingController secondsController = TextEditingController();

  String get timeLeft {
    final hours = (_totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  bool get isRunning => _isRunning;

  void startTimer() {
    if (_isRunning) return;

    _totalSeconds = (int.tryParse(hoursController.text) ?? 0) * 3600 +
                (int.tryParse(minutesController.text) ?? 0) * 60 +
                (int.tryParse(secondsController.text) ?? 0);


    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_totalSeconds > 0) {
        _totalSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _isRunning = false;
        notifyListeners();
        // Phát âm báo ở đây nếu cần.
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    _totalSeconds = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    hoursController.dispose();
    minutesController.dispose();
    secondsController.dispose();
    super.dispose();
  }
}
