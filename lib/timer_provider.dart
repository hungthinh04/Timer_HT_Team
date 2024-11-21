import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class TimerProvider extends ChangeNotifier {
  Timer? _timer;
  int _totalSeconds = 0;
  bool _isRunning = false;
  bool _isPaused = false; // Trạng thái tạm dừng
  bool _isReset = false; // Trạng thái reset
  bool _isFirstReset = true; // Track if this is the first reset

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
  bool get isPaused => _isPaused;

  // Getter for reset state
  bool get isReset => _isReset;

  // Track whether input should be enabled or not
  bool get canEditInput => _isFirstReset || _isReset;

  // Chỉ giữ lại một getter canStart
  bool get canStart {
    return (int.tryParse(hoursController.text) ?? 0) > 0 ||
        (int.tryParse(minutesController.text) ?? 0) > 0 ||
        (int.tryParse(secondsController.text) ?? 0) > 0;
  }

  void startTimer() {
    if (_isRunning) return; // Nếu đã chạy, bỏ qua
    if (_isPaused) {
      _isPaused = false;
      _isRunning = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _tick();
      });
    } else {
      _totalSeconds = (int.tryParse(hoursController.text) ?? 0) * 3600 +
          (int.tryParse(minutesController.text) ?? 0) * 60 +
          (int.tryParse(secondsController.text) ?? 0);
      if (_totalSeconds > 0) {
        _isRunning = true;
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          _tick();
        });
      }
    }
    _isReset = false; // Reset state to false once the timer starts
    _isFirstReset = false; // Disable input after first reset
    notifyListeners();
  }

  void _tick() {
    if (_totalSeconds > 0) {
      _totalSeconds--;
      notifyListeners();
    } else {
      _timer?.cancel();
      _isRunning = false;
      notifyListeners();
      playAlarm();
    }
  }

  void pauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
      _isPaused = true;
      notifyListeners();
    }
  }

  void onInputChanged() {
    notifyListeners();
  }

  void resetTimer() {
    if (!_isRunning) {
      _timer?.cancel();
      _isRunning = false;
      _isPaused = false;
      _totalSeconds = 0;

      hoursController.clear();
      minutesController.clear();
      secondsController.clear();

      _isReset = true; // Set reset state to true when the timer is reset
      notifyListeners();
    }
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

