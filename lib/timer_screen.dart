import 'package:flutter/material.dart';
import 'package:hengio/timer_input.dart';
import 'package:hengio/timer_provider.dart';
import 'package:provider/provider.dart';

class TimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Timer App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TimerInput(),
            SizedBox(height: 20),
            Text(
              timerProvider.timeLeft,
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: timerProvider.isRunning
                      ? timerProvider.pauseTimer
                      : timerProvider.startTimer,
                  child: Text(timerProvider.isRunning ? 'Tạm dừng' : 'Bắt đầu'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: timerProvider.resetTimer,
                  child: Text('Đặt lại'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
