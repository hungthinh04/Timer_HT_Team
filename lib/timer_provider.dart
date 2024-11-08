import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

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

    if (_totalSeconds > 0) {
      _isRunning = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_totalSeconds > 0) {
          _totalSeconds--;
          notifyListeners();
        } else {
          _timer?.cancel();
          _isRunning = false;
          notifyListeners();
          playAlarm();
        }
      });
    }
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

    hoursController.clear();
    minutesController.clear();
    secondsController.clear();

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

  void playAlarm() async {
    final player = AudioPlayer();
    await player.setSource(AssetSource('alarm_audio.wav'));
    await player.resume();
  }
}
