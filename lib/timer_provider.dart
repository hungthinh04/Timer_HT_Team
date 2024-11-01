import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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

    if (_totalSeconds == 0) {
      _totalSeconds = (int.tryParse(hoursController.text) ?? 0) * 3600 +
                      (int.tryParse(minutesController.text) ?? 0) * 60 +
                      (int.tryParse(secondsController.text) ?? 0);
    }

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
class NumberInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  NumberInputField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}

class TimerApp extends StatelessWidget {
  final TimerProvider timerProvider = TimerProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => timerProvider,
      child: Scaffold(
        appBar: AppBar(title: Text('Timer')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              NumberInputField(controller: timerProvider.hoursController, label: 'Hours'),
              SizedBox(height: 10),
              NumberInputField(controller: timerProvider.minutesController, label: 'Minutes'),
              SizedBox(height: 10),
              NumberInputField(controller: timerProvider.secondsController, label: 'Seconds'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  timerProvider.startTimer();
                },
                child: Text('Start Timer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
